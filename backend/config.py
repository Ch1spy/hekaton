import os

ENABLE_SUPABASE_WRITE = os.getenv("ENABLE_SUPABASE_WRITE", "false").lower() == "true"
