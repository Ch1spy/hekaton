import cv2
import pytesseract
import pandas as pd
from PIL import Image
import re
import numpy as np

# IMPORTANT: Set Tesseract path
pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

def preprocess_image(image_path):
    """Improve image quality for better OCR"""
    print("Preprocessing image...")
    
    # Read image
    image = cv2.imread(image_path)
    
    # Convert to grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    
    # Noise reduction
    denoised = cv2.fastNlMeansDenoising(gray)
    
    # Increase contrast (CLAHE)
    clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
    contrast = clahe.apply(denoised)
    
    # Sharpen
    kernel = np.array([[-1,-1,-1],
                       [-1, 9,-1],
                       [-1,-1,-1]])
    sharpened = cv2.filter2D(contrast, -1, kernel)
    
    # Save preprocessed image
    output_path = image_path.replace('.png', '_processed.png')
    cv2.imwrite(output_path, sharpened)
    
    print(f"Image preprocessed: {output_path}")
    return output_path

def read_ocr(image_path):
    """Read text from image using OCR"""
    print("Using OCR...")
    
    # First preprocess the image
    processed_path = preprocess_image(image_path)
    
    # Use preprocessed image
    image = Image.open(processed_path)
    
    # OCR with better settings
    custom_config = r'--oem 3 --psm 6'
    text = pytesseract.image_to_string(image, lang='eng', config=custom_config)
    
    print("OCR completed!")
    return text

def extract_items_prices(text):
    """Extract items and prices from text"""
    print("Searching for items and prices...")
    
    lines = text.split('\n')
    items = []
    
    for line in lines:
        # Search for patterns like: "ITEM 1x 0,69 A" or "ITEM 2,79"
        # Price is usually at the end of the line
        match = re.search(r'([A-ZČŠŽ\s\.]+).*?(\d+[,\.]\d{2})\s*[A-Z]?\s*$', line)
        
        if match:
            name = match.group(1).strip()
            price = match.group(2).replace(',', '.')
            
            # Filter out short or meaningless results
            if len(name) > 3:
             items.append({
                'id': len(items) + 1,
                'Item': name,
                'Price': float(price)
                })
    
    print(f"Found {len(items)} items!")
    return items

def save_to_csv(items, output_path):
    """Save items to CSV"""
    df = pd.DataFrame(items)
    df.to_csv(output_path, index=False, encoding='utf-8-sig')
    print(f"Saved to: {output_path}")

# =================================================================

# Paths to images
RECEIPT_PATH = r'C:\Users\38640\Desktop\racun_test\racun_1.png'
CSV_PATH = r'C:\Users\38640\Desktop\racun_test\rezultat_1.csv'


print("=" * 50)
print("OCR RECEIPT SYSTEM")
print("=" * 50)

# 1. Use OCR
text = read_ocr(RECEIPT_PATH)

print("\nRead text (first 500 characters):")
print(text[:500])
print("\n" + "=" * 50)

# 2. Extract items and prices
items = extract_items_prices(text)

# 3. Save to CSV
if items:
    save_to_csv(items, CSV_PATH)
    print("\nSUCCESSFULLY COMPLETED!")
    print(f"Found {len(items)} items")
else:
    print("\nNo items found - try another image or adjust regex")