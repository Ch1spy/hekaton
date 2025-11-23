from fastapi import APIRouter, UploadFile, File, BackgroundTasks
from pydantic import BaseModel
from typing import List
from services.ocr_service import extract_text_with_tesseract, parse_invoice_items
from services.gemini_services import process_receipt_direct
from config import ENABLE_SUPABASE_WRITE

router = APIRouter(prefix="/extract", tags=["Extraction"])

class ExtractedItem(BaseModel):
    id: str
    name: str
    price: float

class ExtractionResponse(BaseModel):
    source: str   
    items: List[ExtractedItem]

def bg_save_invoice(filename: str, source: str, items: list):
    if ENABLE_SUPABASE_WRITE:
        try:
            from db_invoice import save_invoice_to_db
            save_invoice_to_db(filename, source, items)
        except Exception as e: 
            print(f"DB Save Error: {e}")

@router.post("/invoice-image", response_model=ExtractionResponse)
async def scan_invoice(
    background_tasks: BackgroundTasks, 
    file: UploadFile = File(...)
):
    contents = await file.read()
    items = []
    source = "unknown"

    items = process_receipt_direct(contents)
    
    if items:
        source = "gemini"
    else:
        print("Gemini failed or returned None. Falling back to OCR...")
        raw_text = extract_text_with_tesseract(contents)
        items = parse_invoice_items(raw_text)
        source = "ocr_fallback"

    if items:
        background_tasks.add_task(bg_save_invoice, file.filename, source, items)
    
    return {
        "source": source,
        "items": items
    }