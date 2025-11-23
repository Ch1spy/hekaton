from fastapi import APIRouter, HTTPException
from typing import List, Dict
from db import supabase 

from models import (
    CalculationRequest, 
    CalculationResponse, 
    UserBreakdown, 
    DebtInstruction
)

router = APIRouter(prefix="/split", tags=["Logic"])

@router.post("/calculate-debt", response_model=CalculationResponse)
def calculate_debt(payload: CalculationRequest):
    
    item_map = {item.id: item for item in payload.items}
    user_map = {user.id: user.name for user in payload.users}
    
    user_buckets = {user.id: {"items": [], "total": 0.0} for user in payload.users}
    
    total_bill = 0.0
    for assignment in payload.assignments:
        item = item_map.get(assignment.item_id)
        if not item:
            continue 
            
        uid = assignment.user_id
        if uid in user_buckets:
            user_buckets[uid]["items"].append(item)
            user_buckets[uid]["total"] += item.price
            total_bill += item.price

    breakdown_results = []
    for uid, data in user_buckets.items():
        breakdown_results.append(UserBreakdown(
            user_id=uid,
            user_name=user_map.get(uid, "Unknown"),
            items=data["items"],
            total_share=round(data["total"], 2)
        ))

    settlements = []
    payer_id = payload.payer_id
    payer_name = user_map.get(payer_id, "Payer")

    for uid in user_map.keys():
        share = user_buckets[uid]["total"]
        if uid != payer_id and share > 0:
            debtor_name = user_map.get(uid, "Unknown")           
            settlements.append(DebtInstruction(
                from_user_id=uid,
                from_user_name=debtor_name,
                to_user_id=payer_id,
                to_user_name=payer_name,
                amount=round(share, 2),
                message=f"{debtor_name} owes {payer_name} €{share:.2f}"
            ))
    
    try:
        bill_data = {
            "total_amount": total_bill,
            "payer_id": payer_id
        }
        
        response = supabase.table("bills").insert(bill_data).execute()
        
        new_bill_id = None

        if response.data and isinstance(response.data, list) and len(response.data) > 0:
            first_record = response.data[0]
            
            if isinstance(first_record, dict):
                new_bill_id = first_record.get("id")

        if new_bill_id:
            settlement_rows = []
            for s in settlements:
                settlement_rows.append({
                    "bill_id": new_bill_id,
                    "from_user_name": s.from_user_name,
                    "to_user_name": s.to_user_name,
                    "amount": s.amount,
                    "message": s.message
                })
            
            if settlement_rows:
                supabase.table("settlements").insert(settlement_rows).execute()
                print(f"Successfully saved Bill {new_bill_id} to Supabase.")
        else:
            print("Warning: Could not retrieve new Bill ID.")

    except Exception as e:
        print(f"Database Error: {e}")

    return {
        "total_bill_amount": round(total_bill, 2),
        "user_breakdowns": breakdown_results,
        "settlements": settlements
    }