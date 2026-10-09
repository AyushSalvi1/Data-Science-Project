from typing import List, Optional, Dict, Any
from pydantic import BaseModel, Field

class RetailerInfo(BaseModel):
    name: str  # "Amazon India", "Flipkart", "Croma", "ShopWave"
    logo_url: Optional[str] = None
    direct_url: str
    in_stock: bool = True
    delivery_info: Optional[str] = "Standard delivery in 2-4 days"
    return_policy: Optional[str] = "7-day replacement"

class ProductSpecification(BaseModel):
    key: str
    value: str

class UnifiedProduct(BaseModel):
    id: str
    title: str
    description: str
    brand: Optional[str] = "Generic"
    category: str
    price: float
    original_price: Optional[float] = None
    discount_percentage: Optional[float] = None
    currency: str = "INR"
    rating: float = Field(ge=0, le=5)
    review_count: int = 0
    image_urls: List[str] = []
    specifications: List[ProductSpecification] = []
    retailer: RetailerInfo
    product_url: str
    visual_tags: List[str] = []
    score: Optional[float] = None
    recommendation_reason: Optional[str] = None

class MultiRetailerSearchRequest(BaseModel):
    query: str
    category: Optional[str] = None
    min_price: Optional[float] = None
    max_price: Optional[float] = None
    retailers: Optional[List[str]] = None
    sort_by: Optional[str] = "relevance"  # relevance, price_asc, price_desc, rating

class MultiRetailerSearchResponse(BaseModel):
    query: str
    total_results: int
    products: List[UnifiedProduct]
    retailers_queried: List[str]

class ProductComparisonRequest(BaseModel):
    product_ids: Optional[List[str]] = None
    product_title: Optional[str] = None
    category: Optional[str] = None

class ComparisonMatrixItem(BaseModel):
    retailer: str
    title: str
    price: float
    original_price: Optional[float] = None
    savings: float = 0.0
    rating: float
    review_count: int
    availability: str
    product_url: str
    key_highlights: List[str] = []
    is_best_price: bool = False
    is_highest_rated: bool = False
    is_best_value: bool = False

class ProductComparisonResponse(BaseModel):
    product_title: str
    top_3_overall: List[UnifiedProduct]
    best_offers_by_retailer: List[ComparisonMatrixItem]
    verdict: str

class AIAssistantRequest(BaseModel):
    user_id: Optional[str] = None
    message: str
    budget: Optional[float] = None
    category_preference: Optional[str] = None
    user_history: Optional[List[str]] = None

class AIAssistantResponse(BaseModel):
    reply: str
    detected_budget: Optional[float] = None
    detected_category: Optional[str] = None
    detected_features: List[str] = []
    recommendations: List[UnifiedProduct]
    explanation: str

class VisualSearchRequest(BaseModel):
    image_base64: Optional[str] = None
    image_url: Optional[str] = None
    category_hint: Optional[str] = None

class VisualSearchResponse(BaseModel):
    detected_labels: List[str]
    dominant_colors: List[str]
    matched_products: List[UnifiedProduct]
    similarity_threshold: float = 0.65

class PriceHistoryPoint(BaseModel):
    date: str
    price: float
    retailer: str

class PriceHistoryResponse(BaseModel):
    product_id: str
    product_title: str
    current_price: float
    lowest_recorded_price: float
    highest_recorded_price: float
    price_trend: str  # "dropping", "stable", "rising"
    history: List[PriceHistoryPoint]
    potential_savings: float
