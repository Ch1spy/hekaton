import google.generativeai as genai
import os
from dotenv import load_dotenv
from typing import List, Dict, Optional
import json
from PIL import Image
import io
from pillow_heif import register_heif_opener

register_heif_opener()
load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

if GEMINI_API_KEY:
    genai.configure(api_key=GEMINI_API_KEY) 

def preprocess_receipt_fast(image_bytes: bytes) -> Optional[Image.Image]:
    """
    Optimized for speed: 
    1. Opens directly (handling HEIC via register_heif_opener).
    2. Resizes using faster algorithm.
    3. Skips contrast enhancement (Gemini 1.5 usually doesn't need it).
    """
    try:
        image = Image.open(io.BytesIO(image_bytes))
    except Exception:
        return None

    if image.mode != 'RGB':
        image = image.convert('RGB')

    target_width = 1024
    if image.width > target_width:
        w_percent = (target_width / float(image.width))
        h_size = int((float(image.height) * float(w_percent)))
        image = image.resize((target_width, h_size), Image.Resampling.BICUBIC)
    
    return image


def process_receipt_direct(image_bytes: bytes) -> Optional[List[Dict]]:
    try:
        image = preprocess_receipt_fast(image_bytes)
        
        if image is None:
            print("Image processing failed: Invalid image data")
            return None

        model = genai.GenerativeModel(
            "gemini-2.5-flash", 
            generation_config={
                "temperature": 0.0,
                "response_mime_type": "application/json"
            }
        )

        prompt = """
        Extract items from this Slovenian supermarket receipt (Spar, Lidl, Hofer, Mercator).
        
        RULES:
        1. Extract "Znesek" (Total price) per line. IGNORE unit price if qty > 1.
        2. For LIDL: Subtract discounts immediately or list as negative item.
        3. Ignore: "Popust", "Vračilo", "Embalaža", "DDV", "Skupaj".
        4. Format prices: "12,99" -> 12.99.
        
        Return JSON Array: [{"id": "1", "name": "Item", "price": 1.00}]
        """

        response = model.generate_content([prompt, image])
        
        text = response.text.strip()
        if text.startswith("```"):
            text = text.split("\n", 1)[1]
            if text.endswith("```"):
                text = text.rsplit("\n", 1)[0]

        items = json.loads(text)

        final_items = []
        for i, item in enumerate(items, 1):
            try:
                raw_price = str(item.get("price", 0))
                if isinstance(item.get("price"), (int, float)):
                     price = float(item["price"])
                else:
                    raw_price = raw_price.replace("EUR", "").replace("€", "").replace(",", ".").strip()
                    price = float(raw_price)
                
                if price != 0:
                    final_items.append({
                        "id": str(i),
                        "name": item.get("name", "Unknown").strip(),
                        "price": price
                    })
            except ValueError:
                continue

        return final_items

    except Exception as e:
        print(f"Gemini Error: {e}")
        return None