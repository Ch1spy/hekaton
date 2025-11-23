from supabase import create_client, Client
from dotenv import load_dotenv
import os

load_dotenv()

url_supabase = os.getenv("PROJECT_URL")
key_supabase = os.getenv("ANON_KEY")

if not url_supabase or not key_supabase:
    raise ValueError("Supabase credentials not found. Check your .env file.")

supabase: Client = create_client(url_supabase, key_supabase)

print("Supabase client initialized successfully")