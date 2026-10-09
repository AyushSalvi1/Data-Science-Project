import os
from pydantic import BaseModel
from dotenv import load_dotenv

load_dotenv()

class Settings(BaseModel):
    app_name: str = "ShopWave AI Orchestration Backend"
    api_prefix: str = "/api/v1"
    
    # Supabase Configuration
    supabase_url: str = os.getenv("SUPABASE_URL", "https://xyzcompany.supabase.co")
    supabase_anon_key: str = os.getenv("SUPABASE_ANNONKEY", "anon_key")
    supabase_service_role_key: str = os.getenv("SUPABASE_SERVICE_ROLE_KEY", "")
    
    # AI API Keys (Stored backend-only)
    gemini_api_key: str = os.getenv("GEMINI_API_KEY", "")
    
    # Authorized Retailer API Credentials (Stored backend-only)
    # 1. Amazon India Product Advertising API (PA-API 5.0)
    amazon_partner_tag: str = os.getenv("AMAZON_PARTNER_TAG", "shopwave-21")
    amazon_access_key: str = os.getenv("AMAZON_ACCESS_KEY", "")
    amazon_secret_key: str = os.getenv("AMAZON_SECRET_KEY", "")
    
    # 2. Flipkart Affiliate API
    flipkart_tracking_id: str = os.getenv("FLIPKART_TRACKING_ID", "shopwave_in")
    flipkart_api_token: str = os.getenv("FLIPKART_API_TOKEN", "")
    
    # 3. Croma Permitted Feed / Affiliate API
    croma_affiliate_id: str = os.getenv("CROMA_AFFILIATE_ID", "shopwave_croma")
    croma_api_token: str = os.getenv("CROMA_API_TOKEN", "")

settings = Settings()
