import os
from supabase import create_client, Client

url: str = "https://hnzboevbvhmdaokxavws.supabase.co"
key: str = "sb_secret_E66tCDUx7EOYVbYXSxCiMA_kmS3lAnq"

supabase: Client = create_client(url, key)