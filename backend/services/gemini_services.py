import google.generativeai as genai
import os
from dotenv import load_dotenv
from typing import List, Dict, Optional
import json
from PIL import Image, ImageEnhance 
import io
import re
from pillow_heif import register_heif_opener

register_heif_opener()
load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

if GEMINI_API_KEY:
    genai.configure(api_key=GEMINI_API_KEY) 


def convert_heic_to_png_bytes(image_bytes: bytes) -> bytes:
    try:
        with Image.open(io.BytesIO(image_bytes)) as img:
            img = img.convert("RGBA")
            png_buffer = io.BytesIO()
            img.save(png_buffer, format="PNG")
            return png_buffer.getvalue()
    except Exception:
        return image_bytes


def preprocess_receipt(image_bytes: bytes) -> Image.Image:
    """
    SMART RESIZING:
    - Scales WIDTH to 1024px to fit context window.
    - Keeps HEIGHT natural (preserves long receipts like racun_8).
    """

    image_bytes = convert_heic_to_png_bytes(image_bytes)

    image = Image.open(io.BytesIO(image_bytes))
    
    if image.mode != 'RGB':
        image = image.convert('RGB')

    target_width = 1024
    if image.width > target_width:
        w_percent = (target_width / float(image.width))
        h_size = int((float(image.height) * float(w_percent)))
        image = image.resize((target_width, h_size), Image.Resampling.LANCZOS)
    
    enhancer = ImageEnhance.Contrast(image)
    image = enhancer.enhance(1.4)
    
    return image


def process_receipt_direct(image_bytes: bytes) -> Optional[List[Dict]]:
    try:
        image = preprocess_receipt(image_bytes)

        model = genai.GenerativeModel(
            "gemini-2.5-flash",
            generation_config={
                "temperature": 0.0,
                "response_mime_type": "application/json"
            }
        )

        prompt = """
        You are a highly accurate receipt extraction system for Slovenian supermarkets (Spar, Lidl, Hofer, Mercator).
        
        ### INSTRUCTIONS
        Extract a list of purchased items.
        
        ### HANDLING STORE TYPES:
        
        1. **INTERSPAR / SPAR:**
           - Layout: Columns often show "Cena" (Unit Price) and "Znesek" (Total).
           - RULE: You MUST extract the value from the **"Znesek"** (Right-most) column.
           - IGNORE the "Popust" (Discount) column values.
        
        2. **LIDL:**
           - Layout: Item name on one line, Price on the right.
           - Discount: Sometimes a line below says "Lidl Plus popust" with a negative value (e.g. -0.56).
           - RULE: Calculate the net price. (Item Price - Discount).
           - OR: Output the Item as positive, and the Discount as a separate item with a negative price.
        
        ### CLEANING RULES:
        - **Ignore:** "Vračilo" (Return), "Embalaža" (Bottle deposit), "Točke" (Points), "Skupaj" (Total), "DDV" (Tax).
        - **Format:** JSON Array: [{"id": "1", "name": "Banana", "price": 1.99}]
        - **Prices:** Convert "12,99" -> 12.99.
        
        Output only the JSON.
        """

        response = model.generate_content([prompt, image])
        text = response.text.strip()
        if text.startswith("```json"):
            text = text[7:]
        if text.endswith("```"):
            text = text[:-3]

        items = json.loads(text)

        final_items = []
        for i, item in enumerate(items, 1):
            name = item.get("name", "Unknown").strip()
            raw_price = str(item.get("price", "0"))

            raw_price = raw_price.upper().replace("EUR", "").replace("€", "").strip()

            if "," in raw_price:
                if "." in raw_price:
                    raw_price = raw_price.replace(".", "").replace(",", ".")
                else:
                    raw_price = raw_price.replace(",", ".")

            try:
                price = float(raw_price)
            except:
                price = 0.0

            if price != 0:
                final_items.append({
                    "id": str(i),
                    "name": name,
                    "price": price
                })

        return final_items

    except Exception as e:
        print(f"❌ Gemini Error: {e}")
        return None


def check_internet() -> bool:
    try:
        import socket
        socket.create_connection(("8.8.8.8", 53), timeout=2)
        return True
    except OSError:
        return False
