import cv2
import pytesseract
import numpy as np
import re
import shutil
import os
from typing import List, Dict


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
    image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    
    height, width = gray.shape
    if width < 1000:
        scale = 2.0
        gray = cv2.resize(gray, None, fx=scale, fy=scale, interpolation=cv2.INTER_CUBIC)

    denoised = cv2.fastNlMeansDenoising(gray)
    
    thresh = cv2.adaptiveThreshold(denoised, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, 
                                   cv2.THRESH_BINARY, 11, 2)
    
    return thresh

def extract_items_from_text(text: str) -> List[Dict]:
    lines = text.split('\n')
    candidates = []
    
    regex = r'(.+?)\s+(-?\d+[,\.]\d{2})\s*[A-Z]?\s*$'
    
    for line in lines:
        clean_line = line.strip()
        if not clean_line: continue

        match = re.search(regex, clean_line)
        if match:
            name_raw = match.group(1).strip()
            price_str = match.group(2).replace(',', '.')
            
            try:
                price = float(price_str)
                
                if len(name_raw) < 2: continue
                
                name = re.sub(r'\s\d+[\.,]?\d*[xX]$', '', name_raw)
                name = re.sub(r'^\d+x\s', '', name) 

                candidates.append({
                    "name": name,
                    "price": price
                })
            except ValueError:
                continue

    if not candidates:
        return []

    
    final_items = []
    running_total = 0.0
    item_id_counter = 1
    
    TOLERANCE = 0.05 

    for i, candidate in enumerate(candidates):
        price = candidate['price']
        name = candidate['name'].upper()
        
        if i > 0 and abs(price - running_total) <= TOLERANCE:
            print(f"Found Total: {price} matches sum {running_total}. Stopping.")
            break
        
        if i > 0 and abs(price - running_total) <= TOLERANCE:
             continue

        if i > 0 and price > (running_total * 1.5) and price > 0:
             print(f"Found Payment Info: {price} > {running_total}. Stopping.")
             break
             
        if re.search(r'\b(TAX|DDV|VAT|PDV|MWST|NETO)\b', name):
            continue
            
        final_items.append({
            "id": str(item_id_counter),
            "name": candidate['name'],
            "price": price
        })
        
        running_total += price
        item_id_counter += 1

    return final_items

def process_invoice_image(image_bytes) -> List[Dict]:
    processed_img = preprocess_image(image_bytes)
    custom_config = r'--oem 3 --psm 6' 
    text = pytesseract.image_to_string(processed_img, lang='eng', config=custom_config)
    
    return extract_items_from_text(text)