from fastapi import APIRouter, UploadFile, File
from pydantic import BaseModel
from typing import List
from services.ocr_service import extract_text_with_tesseract, parse_invoice_items
from services.gemini_services import process_receipt_direct, check_internet
from config import ENABLE_SUPABASE_WRITE

router = APIRouter(prefix="/extract", tags=["Extraction"])

class ExtractedItem(BaseModel):
    id: str
    name: str
    price: float

class ExtractionResponse(BaseModel):
    source: str   
    items: List[ExtractedItem]

@router.post("/invoice-image", response_model=ExtractionResponse)
async def scan_invoice(file: UploadFile = File(...)):
    contents = await file.read()
    items = []
    source = "unknown"

    if check_internet():
        print(f"Sending {file.filename} to Gemini...")
        items = process_receipt_direct(contents)
        if items:
            source = "gemini"
        else:
            print("Gemini returned None, falling back...")
    else:
        print("No Internet connection detected. Skipping AI.")

    if not items:
        print("📷 Falling back to Tesseract OCR...")
        raw_text = extract_text_with_tesseract(contents)
        items = parse_invoice_items(raw_text)
        source = "ocr_fallback"

    if ENABLE_SUPABASE_WRITE:
        try:
            from db_invoice import save_invoice_to_db
            save_invoice_to_db(file.filename, source, items) # type: ignore
        except Exception as e: 
            print(f"DB Save Error: {e}")
    
    return {
        "source": source,
        "items": items
    }