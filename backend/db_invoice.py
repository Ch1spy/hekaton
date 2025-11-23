from typing import Any, Dict, List
from db import supabase
from config import ENABLE_SUPABASE_WRITE

def save_invoice_to_db(image_name: str, source: str, items: list) -> str:
    if not ENABLE_SUPABASE_WRITE:
        print("Supabase write disabled (kill switch active)")
        return "dry-run"

    invoice_res = supabase.table("invoices").insert({
        "image_name": image_name,
        "source": source
    }).execute()

    if not invoice_res.data or not isinstance(invoice_res.data, list):
        raise Exception("Failed to insert invoice")

    first_row = invoice_res.data[0]

    if not isinstance(first_row, dict) or "id" not in first_row:
        raise Exception("Unexpected response from Supabase")

    invoice_id = str(first_row["id"])

    rows: List[Dict[str, Any]] = []

    for item in items:
        item_id = getattr(item, "id", None) or item.get("id")
        name = getattr(item, "name", None) or item.get("name")
        price = getattr(item, "price", None) or item.get("price")

        if not name or price is None:
            continue

        rows.append({
            "invoice_id": invoice_id,
            "external_item_id": str(item_id),
            "name": str(name),
            "price": float(price)
        })

    if rows:
        supabase.table("invoice_items").insert(rows).execute()

    return invoice_id
