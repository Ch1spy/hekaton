from fastapi import APIRouter, HTTPException
from db import supabase

router = APIRouter(
    prefix="/flashcards",
    tags=["Flashcards"]
)

@router.get("/")
def get_all_flashcards():
    response = supabase.table("flashcards").select("*").execute()
    return response.data


@router.get("/{card_id}")
def get_flashcard(card_id: int):
    response = (
        supabase.table("flashcards")
        .select("*")
        .eq("id", card_id)
        .single()
        .execute()
    )

    if not response.data:
        raise HTTPException(status_code=404, detail="Flashcard not found")

    return response.data
