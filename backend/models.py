from pydantic import BaseModel
from typing import List, Optional

class Item(BaseModel):
    id: str
    name: str
    price: float

class User(BaseModel):
    id: str
    name: str

class ItemAssignment(BaseModel):
    item_id: str
    user_id: str

class CalculationRequest(BaseModel):
    payer_id: str             
    users: List[User]         
    items: List[Item]         
    assignments: List[ItemAssignment] 

class UserBreakdown(BaseModel):
    user_id: str
    user_name: str
    items: List[Item]         
    total_share: float        

class DebtInstruction(BaseModel):
    from_user_id: str
    from_user_name: str
    to_user_id: str
    to_user_name: str
    amount: float
    message: str              

class CalculationResponse(BaseModel):
    total_bill_amount: float
    user_breakdowns: List[UserBreakdown]
    settlements: List[DebtInstruction]