import os
from supabase import create_client, Client

url: str = "https://hnzboevbvhmdaokxavws.supabase.co"
key: str = "sb_publishable_r_AMMyCDARSmTMddzE7JuA_vGb8vAGU"

supabase: Client = create_client(url, key)