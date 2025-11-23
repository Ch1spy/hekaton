import google.generativeai as genai
import json
import re
from typing import List, Dict, Optional

def clean_json_string(text: str) -> str:
    text = re.sub(r'```json\s*', '', text)
    text = re.sub(r'```\s*', '', text)
    return text.strip()

def validate_items_with_llm(raw_text: str, parsed_items: List[Dict]) -> Optional[List[Dict]]:
    try:
        model = genai.GenerativeModel("gemini-1.5-pro")


        prompt = f"""stop
        You are a Forensic Accountant validating receipt data.

        1. INPUT DATA:
        Raw OCR Text:
        {raw_text}

        2. YOUR TASK:
        Extract the final list of purchased items. 
        
        3. CRITICAL PRICING RULES (READ CAREFULLY):
        - Receipts often show: [Quantity] x [Unit Price] ... [FINAL PRICE]
        - You MUST extract the [FINAL PRICE] (Znesek).
        - NEVER extract the Unit Price (Cena) if the quantity is > 1.
        - HEURISTIC: The correct price is usually the **last number on the right** of the line item line.
        
        Example of correct logic:
        Line: "2x   Coca Cola    1.50    3.00"
        -> Incorrect: 1.50
        -> Correct:   3.00
        
        4. CLEANUP:
        - Ignore non-product lines (discounts, "Popust", "Kartica", "Davčna", "Total").
        - Fix product names if OCR text is garbled.

        5. OUTPUT FORMAT:
        Return ONLY a valid JSON array:
        [{{"id": "1", "name": "ITEM NAME", "price": 0.00}}]
        """

        resp = model.generate_content(prompt)
        
        clean_text = clean_json_string(resp.text)
        items = json.loads(clean_text)
        
        if isinstance(items, list):
            for i, item in enumerate(items, 1):
                item['id'] = str(i)
                if isinstance(item.get('price'), str):
                    try:
                        val = item['price'].replace(',', '.')
                        if val.count('.') > 1:
                            parts = val.split('.')
                            val = "".join(parts[:-1]) + "." + parts[-1]
                        item['price'] = float(val)
                    except ValueError:
                        item['price'] = 0.0
            return items
            
        return None

    except Exception as e:
        print(f"LLM validation failed: {e}")
        return None