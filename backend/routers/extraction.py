from fastapi import APIRouter, UploadFile, File, HTTPException
from pydantic import BaseModel
from typing import List
from ..ocr_service import process_invoice_image

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

    try:
        contents = await file.read()
        
        detected_items = process_invoice_image(contents)
        
        return {
            "source": "ocr_custom",
            "items": detected_items
        }
        
    except Exception as e:
        print(f"OCR Error: {e}")
        raise HTTPException(status_code=500, detail="Failed to process image")