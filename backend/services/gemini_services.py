import google.generativeai as genai
import os
from dotenv import load_dotenv
from typing import List, Dict, Optional
import json
from PIL import Image
import io
import numpy as np
import cv2
import re

load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

if GEMINI_API_KEY:
    genai.configure(api_key=GEMINI_API_KEY)
else:
    print("WARNING: GEMINI_API_KEY not found in .env")

def preprocess_image(pil_image: Image.Image) -> Image.Image:
    img = np.array(pil_image)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    enhanced = cv2.convertScaleAbs(gray, alpha=1.4, beta=10)
    return Image.fromarray(enhanced)

def process_with_gemini(image_bytes: bytes) -> Optional[List[Dict]]:
    try:
        image = Image.open(io.BytesIO(image_bytes))
        image = preprocess_image(image)

        model = genai.GenerativeModel(
            'gemini-2.5-flash',
            generation_config={
                "temperature": 0.0,
                "top_p": 0.1,
                "top_k": 1,
                "max_output_tokens": 2048,
                "response_mimetype": "application/json"
            }
        )

        prompt = """You are reading a receipt image.

Return a valid JSON array ONLY in this exact format:
[
  {"id": "1", "name": "ITEM NAME", "price": 0.00}
]

Rules:
Preserve characters: š, č, ž exactly as shown
Do not include totals, tax, cash, change, subtotals
IDs must be strings starting from "1"
Prices must be floats
No explanation, no markdown, only JSON array
"""

        for _ in range(2):
            response = model.generate_content([prompt, image])

            try:
                text = response.text.strip()
                items = json.loads(text)

                if isinstance(items, list):
                    return items

            except json.JSONDecodeError:
                match = re.search(r'[\s{.?}\s*]', text, re.DOTALL)
                if match:
                    try:
                        return json.loads(match.group())
                    except:
                        pass

        print("Gemini failed to return valid JSON")
        return None

    except Exception as e:
        print(f"Gemini failed: {e}")
        return None


def check_internet() -> bool:
    try:
        import socket
        socket.create_connection(("8.8.8.8", 53), timeout=3)
        return True
    except OSError:
        return False

