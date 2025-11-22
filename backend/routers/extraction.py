from fastapi import APIRouter, UploadFile, File, HTTPException
from pydantic import BaseModel
from typing import List
from services.ocr_service import process_invoice_image
from services.gemini_services import process_with_gemini, check_internet

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
    """
    Extract items from receipt image.
    Uses Gemini API if available, falls back to OCR.
    """
    try:
        contents = await file.read()
        
        
        if check_internet():
            print("🌐 Internet available - trying Gemini API...")
            gemini_result = process_with_gemini(contents)
            
            if gemini_result:
                return {
                    "source": "gemini",
                    "items": gemini_result
                }
            else:
                print(" Gemini failed, falling back to OCR...")
        else:
            print("📴 No internet - using OCR fallback...")
        
        
        ocr_result = process_invoice_image(contents)
        
        return {
            "source": "ocr_fallback",
            "items": ocr_result
        }
        
    except Exception as e:
        print(f" Error: {e}")
        raise HTTPException(status_code=500, detail="Failed to process image")