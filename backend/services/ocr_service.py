import cv2
import pytesseract
import numpy as np
import re
import shutil
import os
from typing import List, Dict
from pillow_heif import register_heif_opener
from PIL import Image
import io
register_heif_opener()


tesseract_cmd = shutil.which("tesseract")

if not tesseract_cmd:
    potential_paths = [
        "/opt/homebrew/bin/tesseract",
        "/usr/local/bin/tesseract",
        "/usr/bin/tesseract",
        r"C:\Program Files\Tesseract-OCR\tesseract.exe"
    ]
    for p in potential_paths:
        if os.path.exists(p):
            tesseract_cmd = p
            break

if tesseract_cmd:
    pytesseract.pytesseract.tesseract_cmd = tesseract_cmd
else:
    print("WARNING: Tesseract binary not found. Please install it (brew install tesseract).")

# ------------------------------------

def preprocess_image(image_bytes):
    """
    Aggressive preprocessing to ensure numbers are read correctly.
    """
    nparr = np.frombuffer(image_bytes, np.uint8)


    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    image = np.array(image)
    gray = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY)

        
    height, width = gray.shape
    if width < 1000:
        scale = 2.0
        gray = cv2.resize(gray, None, fx=scale, fy=scale, interpolation=cv2.INTER_CUBIC)

    clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
    enhanced = clahe.apply(gray)

    return enhanced

def extract_text_with_tesseract(image_bytes: bytes) -> str:
    processed_img = preprocess_image(image_bytes)
    config = r'--oem 3 --psm 6'
    return pytesseract.image_to_string(processed_img, lang='slv+eng', config=config)

import re
from typing import List, Dict

def parse_invoice_items(raw_text: str) -> List[Dict]:
    lines = raw_text.split("\n")
    items = []

    start_idx = -1
    end_idx = -1

    for i, line in enumerate(lines):
        u = line.upper()

        if "IZDELEK" in u and "KOLI" in u and "CENA" in u:
            start_idx = i
        if "SKUPAJ" in u:
            end_idx = i
            break

    if start_idx == -1:
        return []

    scoped_lines = lines[start_idx:end_idx]

    pattern = r"^(.+?)\s+\d+[\.,]?\d*\s+\d+[,\.]\d{2}\s+[-\d,\.]+\s+(\d+[,\.]\d{2})"

    item_id = 1

    for line in scoped_lines:
        clean = line.strip()
        if not clean:
            continue

        match = re.search(pattern, clean)
        if not match:
            continue

        name = match.group(1).strip()
        price = float(match.group(2).replace(",", "."))

        if len(name) < 2 or price <= 0:
            continue

        items.append({
            "id": str(item_id),
            "name": name,
            "price": price
        })

        item_id += 1

    return items
