import pytest
import os
import sys
import logging
import random
import time
from fastapi.testclient import TestClient
from dotenv import load_dotenv

load_dotenv()

current_dir = os.path.dirname(os.path.abspath(__file__))
if current_dir not in sys.path:
    sys.path.append(current_dir)

from main import app
from models import User, Item, ItemAssignment
try:
    from db_invoice import save_invoice_to_db
except ImportError:
    save_invoice_to_db = None

class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

class ConsoleFormatter(logging.Formatter):
    def format(self, record):
        if record.levelno == logging.INFO:
            return f"{record.msg}"
        elif record.levelno == logging.WARNING:
            return f"{Colors.WARNING} {record.msg}{Colors.ENDC}"
        elif record.levelno == logging.ERROR:
            return f"{Colors.FAIL} {record.msg}{Colors.ENDC}"
        return super().format(record)

logger = logging.getLogger("TestRunner")
logger.setLevel(logging.INFO)

file_handler = logging.FileHandler("test_run.log", mode="a")
file_handler.setFormatter(logging.Formatter('%(asctime)s [%(levelname)s] %(message)s'))
logger.addHandler(file_handler)

console_handler = logging.StreamHandler(sys.stdout)
console_handler.setFormatter(ConsoleFormatter())
logger.addHandler(console_handler)

client = TestClient(app) 
TEST_DOCS_DIR = os.path.join(current_dir, 'test_docs')

@pytest.fixture
def synthetic_users():
    return [
        User(id="user_1", name="Dmitri"),
        User(id="user_2", name="Jost"),
        User(id="user_3", name="Ema")
    ]

def print_separator(char="-", length=60, color=Colors.BLUE):
    logger.info(f"{color}{char * length}{Colors.ENDC}")

def test_full_pipeline(synthetic_users):
    if not os.path.exists(TEST_DOCS_DIR):
        pytest.fail(f"Directory not found: {TEST_DOCS_DIR}")

    image_files = [f for f in os.listdir(TEST_DOCS_DIR) if f.lower().endswith(('.png', '.jpg', '.jpeg', '.heic'))]
    
    if not image_files:
        logger.warning(f"No images found in {TEST_DOCS_DIR}. Please add .png/.jpg files.")
        return

    print_separator("=")
    logger.info(f"{Colors.HEADER}{Colors.BOLD}STARTING PIPELINE TEST{Colors.ENDC}")
    logger.info(f"Found {len(image_files)} invoices to process")
    print_separator("=")

    stats = {"total": 0, "success": 0, "failed": 0, "gemini": 0, "ocr": 0}

    for img_filename in image_files:
        stats["total"] += 1
        logger.info(f"\n{Colors.CYAN}PROCESSING: {img_filename}{Colors.ENDC}")
        
        img_path = os.path.join(TEST_DOCS_DIR, img_filename)

        logger.info("Sending to Extraction API...")
        
        try:
            start_time = time.perf_counter()
            
            with open(img_path, "rb") as f:
                response = client.post(
                    "/extract/invoice-image", 
                    files={"file": (img_filename, f, "image/png")}
                )
            
            end_time = time.perf_counter()
            duration = end_time - start_time

            if response.status_code != 200:
                logger.error(f"Extraction Failed ({duration:.2f}s): {response.text}")
                stats["failed"] += 1
                continue

            data = response.json()
            source = data.get("source", "unknown")
            items_data = data.get("items", [])
            
            time_color = Colors.GREEN if duration < 5 else Colors.WARNING
            
            logger.info(f"Source: {source.upper()}")
            logger.info(f"Latency: {time_color}{duration:.2f}s{Colors.ENDC}")

            if source == "gemini": stats["gemini"] += 1
            else: stats["ocr"] += 1

            if not items_data:
                logger.warning("Extraction finished but found 0 items.")
                stats["failed"] += 1
                continue

            logger.info(f" Found {len(items_data)} items:")
            print(f"      {Colors.BOLD}{'ITEM NAME':<30} | {'PRICE':>8}{Colors.ENDC}")
            print(f"      {'-'*30} | {'-'*8}")
            
            items = []
            for item_data in items_data:
                item = Item(**item_data)
                items.append(item)
                print(f"      {item.name[:30]:<30} | {item.price:>8.2f} €")

            if save_invoice_to_db:
                try:
                    invoice_id = save_invoice_to_db(img_filename, source, items)
                    logger.info(f"Saved to DB (ID: {invoice_id})")
                except Exception as e:
                    logger.error(f"DB Save failed: {e}")

            random.seed(42) 
            assignments = []
            for item in items:
                assignments.append(ItemAssignment(item_id=item.id, user_id=random.choice(synthetic_users).id))
            
            logger.info(f"Simulated {len(assignments)} random user assignments.")

            logger.info(f"Calculating Split...")
            payer = synthetic_users[0]
            
            payload = {
                "payer_id": payer.id,
                "users": [u.dict() for u in synthetic_users],
                "items": [i.dict() for i in items],
                "assignments": [a.dict() for a in assignments]
            }

            calc_response = client.post("/split/calculate-debt", json=payload)
            
            if calc_response.status_code != 200:
                logger.error(f"Calculation Failed: {calc_response.text}")
                stats["failed"] += 1
                continue
                
            result = calc_response.json()

            total_ocr = sum(i.price for i in items)
            total_calc = result['total_bill_amount']
            
            if abs(total_ocr - total_calc) >= 0.05:
                logger.error(f"Math Mismatch! OCR: {total_ocr} != Backend: {total_calc}")
                stats["failed"] += 1
                continue

            logger.info(f"Total Bill: {Colors.BOLD}{total_calc:.2f} €{Colors.ENDC}")
            
            if result['settlements']:
                logger.info("Settlements:")
                for s in result['settlements']:
                    logger.info(f"       -> {s['message']}")
            else:
                logger.info("       -> No debts generated.")

            logger.info(f"{Colors.GREEN}INVOICE PASSED{Colors.ENDC}")
            stats["success"] += 1
            
        except Exception as e:
            logger.error(f"Unexpected error: {e}")
            stats["failed"] += 1

    print("\n")
    print_separator("=")
    logger.info(f"{Colors.HEADER}TEST SUMMARY{Colors.ENDC}")
    logger.info(f"   Total:   {stats['total']}")
    logger.info(f"   Passed:  {Colors.GREEN}{stats['success']}{Colors.ENDC}")
    logger.info(f"   Failed:  {Colors.FAIL}{stats['failed']}{Colors.ENDC}")
    logger.info(f"   Sources: Gemini({stats['gemini']}) | OCR({stats['ocr']})")
    print_separator("=")
    
    if stats["failed"] > 0:
        pytest.fail(f"{stats['failed']} tests failed")
    else:
        logger.info(f"{Colors.GREEN}ALL SYSTEMS GO 🚀{Colors.ENDC}")

if __name__ == "__main__":
    sys.exit(pytest.main(["-s", "-v", __file__]))