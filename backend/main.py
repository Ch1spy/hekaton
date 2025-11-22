from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import split_logic, extraction

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(split_logic.router)
app.include_router(extraction.router)
@app.get("/")
def root():
    return {"status": "joskice Running"}