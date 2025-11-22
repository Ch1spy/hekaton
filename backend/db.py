import os
from supabase import create_client, Client

url: str = "YOUR_SUPABASE_PROJECT_URL"
key: str = "YOUR_SUPABASE_ANON_KEY"

supabase: Client = create_client(url, key)