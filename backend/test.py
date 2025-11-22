import pytest
import os
import sys
import logging
import random
from fastapi.testclient import TestClient

current_dir = os.path.dirname(os.path.abspath(__file__))
if current_dir not in sys.path:
    sys.path.append(current_dir)

from main import app
from models import User, Item, ItemAssignment

logging.basicConfig(
    level=logging.INFO, 
    format='%(asctime)s [%(levelname)s] %(message)s',
    handlers=[
        logging.FileHandler("test_run.log", mode="a"),
        logging.StreamHandler(sys.stdout)
    ],
    force=True
)
logger = logging.getLogger(__name__)

client = TestClient(app) 

TEST_DOCS_DIR = os.path.join(current_dir, 'test_docs')

@pytest.fixture
def synthetic_users():
    return [
        User(id="user_1", name="Alice"),
        User(id="user_2", name="Bob"),
        User(id="user_3", name="Charlie")
    ]

def test_full_pipeline(synthetic_users):
    if not os.path.exists(TEST_DOCS_DIR):
        pytest.fail(f"Directory not found: {TEST_DOCS_DIR}")

    image_files = [f for f in os.listdir(TEST_DOCS_DIR) if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
    
    if not image_files:
        logger.warning(f"No images found in {TEST_DOCS_DIR}. Please add .png or .jpg files.")
        return

    logger.info(f"STARTING TEST RUN. Found {len(image_files)} invoices.")

    # Track results
    total_processed = 0
    gemini_success = 0
    ocr_fallback = 0
    failed = 0

    for img_filename in image_files:
        logger.info("=" * 60)
        logger.info(f"PROCESSING INVOICE: {img_filename}")
        
        img_path = os.path.join(TEST_DOCS_DIR, img_filename)

        logger.info("Step 1: Sending image to Extraction Service (Gemini/OCR)...")
        
        try:
            with open(img_path, "rb") as f:
                response = client.post(
                    "/extract/invoice-image", 
                    files={"file": (img_filename, f, "image/png")}
                )
            
            if response.status_code != 200:
                logger.error(f" Extraction Failed: {response.text}")
                failed += 1
                continue

            extraction_data = response.json()
            source = extraction_data.get("source", "unknown")
            items_data = extraction_data.get("items", [])
            
            # Track which method was used
            if source == "gemini":
                logger.info(f" Used GEMINI API - High accuracy expected")
                gemini_success += 1
            elif source == "ocr_fallback":
                logger.warning(f" Used OCR FALLBACK - May need manual review")
                ocr_fallback += 1
            else:
                logger.warning(f" Unknown source: {source}")
            
            if not items_data:
                logger.warning(f"WARNING: Extraction finished but found 0 items in {img_filename}")
                failed += 1
                continue

            logger.info(f"Found {len(items_data)} items:")
            
            items = []
            for i, item_data in enumerate(items_data, 1):
                item = Item(**item_data)
                items.append(item)
                logger.info(f"   {i}. {item.name} - {item.price} EUR")

            random.seed(42) 
            
            assignments = []
            logger.info("Step 2: Simulating Drag & Drop (Random Assignment)...")

            for item in items:
                lucky_user = random.choice(synthetic_users)
                
                assignment = ItemAssignment(item_id=item.id, user_id=lucky_user.id)
                assignments.append(assignment)
                
                logger.info(f"   -> Item '{item.name}' ({item.price} EUR) assigned to {lucky_user.name}")

            payer = synthetic_users[0]
            logger.info(f"Step 3: Calculating Debt. Payer is {payer.name}.")

            payload = {
                "payer_id": payer.id,
                "users": [u.dict() for u in synthetic_users],
                "items": [i.dict() for i in items],
                "assignments": [a.dict() for a in assignments]
            }

            calc_response = client.post("/split/calculate-debt", json=payload)
            
            if calc_response.status_code != 200:
                logger.error(f" Calculation Failed: {calc_response.text}")
                failed += 1
                continue
                
            result = calc_response.json()

            total_bill_ocr = sum(i.price for i in items)
            total_bill_calc = result['total_bill_amount']
            
            logger.info(f"Step 4: Verification")
            logger.info(f"   Total Bill (Extracted Sum): {total_bill_ocr:.2f} EUR")
            logger.info(f"   Total Bill (Backend Calc): {total_bill_calc:.2f} EUR")
            
            if abs(total_bill_ocr - total_bill_calc) >= 0.05:
                logger.error(" MISMATCH: Extracted sum != Backend calculation!")
                failed += 1
                continue

            logger.info("   User Breakdown:")
            user_share_sum = 0.0
            for u_breakdown in result['user_breakdowns']:
                logger.info(f"     - {u_breakdown['user_name']} ate {u_breakdown['total_share']:.2f} EUR")
                user_share_sum += u_breakdown['total_share']
            
            if abs(user_share_sum - total_bill_calc) >= 0.05:
                logger.error(" MISMATCH: Sum of user shares != total bill!")
                failed += 1
                continue

            logger.info("   Final Settlements (Who owes Alice?):")
            if not result['settlements']:
                logger.info("     - No debts (Alice ate everything alone?)")
            else:
                for settlement in result['settlements']:
                    logger.info(f"      {settlement['message']}")

            logger.info(" Invoice Verified Successfully.")
            total_processed += 1
            
        except Exception as e:
            logger.error(f" Unexpected error processing {img_filename}: {e}")
            failed += 1
            continue

    logger.info("=" * 60)
    logger.info("TEST SUMMARY:")
    logger.info(f"  Total Receipts: {len(image_files)}")
    logger.info(f"   Successfully Processed: {total_processed}")
    logger.info(f"   Used Gemini API: {gemini_success}")
    logger.info(f"   Used OCR Fallback: {ocr_fallback}")
    logger.info(f"   Failed: {failed}")
    logger.info("=" * 60)
    
    if failed > 0:
        logger.warning(f" {failed} receipts failed processing. Check logs above.")
    
    if total_processed > 0:
        logger.info(" ALL PROCESSED TESTS PASSED.")
    else:
        pytest.fail(" No receipts were successfully processed!")


if __name__ == "__main__":
    sys.exit(pytest.main(["-s", "-v", __file__]))