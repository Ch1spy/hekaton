import cv2
import pytesseract
import numpy as np
import re
from typing import List, Dict


def preprocess_image(image_bytes):

    nparr = np.frombuffer(image_bytes, np.uint8)
    
    image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY) # type: ignore
    
    denoised = cv2.fastNlMeansDenoising(gray)
    
    clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
    contrast = clahe.apply(denoised)
    
    kernel = np.array([[-1,-1,-1],
                       [-1, 9,-1],
                       [-1,-1,-1]])
    sharpened = cv2.filter2D(contrast, -1, kernel)
    
    return sharpened

def extract_items_from_text(text: str) -> List[Dict]:

    lines = text.split('\n')
    items = []

    item_id_counter = 1
    
    for line in lines:


        match = re.search(r'([A-ZČŠŽa-z\s\.]+).*?(\d+[,\.]\d{2})\s*[A-Z]?\s*$', line)
        
        if match:
            name = match.group(1).strip()
            price_str = match.group(2).replace(',', '.')
            
            try:
                price = float(price_str)
                
                if len(name) > 3 and "TOTAL" not in name.upper():
                    items.append({
                        "id": str(item_id_counter),
                        "name": name,
                        "price": price
                    })
                    item_id_counter += 1
            except ValueError:
                continue
                
    return items

def process_invoice_image(image_bytes) -> List[Dict]:

    processed_img = preprocess_image(image_bytes)
    
    custom_config = r'--oem 3 --psm 6'
    text = pytesseract.image_to_string(processed_img, lang='eng', config=custom_config)
    
    items = extract_items_from_text(text)
    
    return items