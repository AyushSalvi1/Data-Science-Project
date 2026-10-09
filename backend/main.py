import uvicorn
from typing import List, Optional
from fastapi import FastAPI, Query, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware

from backend.config import settings
from backend.models.schemas import (
    UnifiedProduct,
    MultiRetailerSearchRequest,
    MultiRetailerSearchResponse,
    ProductComparisonRequest,
    ProductComparisonResponse,
    AIAssistantRequest,
    AIAssistantResponse,
    VisualSearchRequest,
    VisualSearchResponse,
    PriceHistoryResponse,
)
from backend.providers.base import ProductSourceProvider
from backend.providers.amazon import AmazonIndiaProvider
from backend.providers.flipkart import FlipkartProvider
from backend.providers.croma import CromaProvider
from backend.providers.shopwave import ShopWaveProvider
from backend.services.recommendation_service import HybridRecommendationEngine
from backend.services.assistant_service import AIShoppingAssistant
from backend.services.comparison_service import ProductComparisonService
from backend.services.visual_search_service import VisualSearchService
from backend.services.price_tracking_service import PriceTrackingService

app = FastAPI(
    title="ShopWave AI Orchestration Backend",
    description="Multi-Retailer Search, AI Shopping Assistant, Visual Search, and Price Tracking API",
    version="1.0.0",
)

# Enable CORS for Flutter mobile & web clients
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register providers
providers: List[ProductSourceProvider] = [
    AmazonIndiaProvider(),
    FlipkartProvider(),
    CromaProvider(),
    ShopWaveProvider(),
]

async def get_aggregated_catalog() -> List[UnifiedProduct]:
    all_products: List[UnifiedProduct] = []
    for provider in providers:
        items = await provider.search(query="", limit=20)
        all_products.extend(items)
    return all_products

@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "service": "ShopWave AI Orchestration Backend",
        "providers_active": [p.name for p in providers],
    }

@app.post(f"{settings.api_prefix}/search/multi-retailer", response_model=MultiRetailerSearchResponse)
async def multi_retailer_search(req: MultiRetailerSearchRequest):
    """
    Search across Amazon India, Flipkart, Croma, and ShopWave.
    Applies filters and sorts results.
    """
    all_results: List[UnifiedProduct] = []
    selected_providers = providers
    if req.retailers:
        selected_providers = [p for p in providers if p.name in req.retailers]

    for p in selected_providers:
        results = await p.search(
            query=req.query,
            category=req.category,
            min_price=req.min_price,
            max_price=req.max_price,
            limit=10,
        )
        all_results.extend(results)

    # Apply Sorting
    if req.sort_by == "price_asc":
        all_results.sort(key=lambda x: x.price)
    elif req.sort_by == "price_desc":
        all_results.sort(key=lambda x: x.price, reverse=True)
    elif req.sort_by == "rating":
        all_results.sort(key=lambda x: x.rating, reverse=True)
    else:  # relevance
        all_results = HybridRecommendationEngine.rank_products(
            products=all_results,
            query=req.query,
            limit=len(all_results),
        )

    return MultiRetailerSearchResponse(
        query=req.query,
        total_results=len(all_results),
        products=all_results,
        retailers_queried=[p.name for p in selected_providers],
    )

@app.post(f"{settings.api_prefix}/assistant", response_model=AIAssistantResponse)
async def ai_shopping_assistant(req: AIAssistantRequest):
    """
    Understands natural language request, user budget, and preference constraints,
    then recommends verified products with explanations.
    """
    catalog = await get_aggregated_catalog()
    return await AIShoppingAssistant.process_request(req, catalog)

@app.post(f"{settings.api_prefix}/compare", response_model=ProductComparisonResponse)
async def compare_products(req: ProductComparisonRequest):
    """
    Compares products across retailers.
    Returns Top 3 overall and best offer from each website.
    """
    catalog = await get_aggregated_catalog()
    target_products: List[UnifiedProduct] = []

    if req.product_ids:
        target_products = [p for p in catalog if p.id in req.product_ids]
    elif req.product_title:
        q = req.product_title.lower()
        target_products = [p for p in catalog if q in p.title.lower()]
    elif req.category:
        target_products = [p for p in catalog if req.category.lower() in p.category.lower()]

    if not target_products:
        target_products = catalog[:6]

    return ProductComparisonService.compare_products(
        products=target_products,
        target_title=req.product_title or (target_products[0].title if target_products else "Comparison"),
    )

@app.post(f"{settings.api_prefix}/search/visual", response_model=VisualSearchResponse)
async def visual_search(req: VisualSearchRequest):
    """
    Image-based product search matching visually similar products from the catalog.
    """
    catalog = await get_aggregated_catalog()
    return await VisualSearchService.process_visual_search(req, catalog)

@app.get(f"{settings.api_prefix}/price-history/{{product_id}}", response_model=PriceHistoryResponse)
async def get_price_history(product_id: str):
    """
    Returns timestamped price history and 30-day savings trend for a product.
    """
    catalog = await get_aggregated_catalog()
    product = next((p for p in catalog if p.id == product_id), None)
    if not product:
        # Fallback to first item for demonstration if specific ID not found
        product = catalog[0] if catalog else None
    
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    return PriceTrackingService.get_price_history(product)

@app.get(f"{settings.api_prefix}/recommendations/personalized", response_model=List[UnifiedProduct])
async def get_personalized_recommendations(
    user_id: Optional[str] = None,
    category: Optional[str] = None,
    budget: Optional[float] = None,
    limit: int = 6,
):
    """
    Returns personalized product recommendations based on user preference and popularity.
    """
    catalog = await get_aggregated_catalog()
    ranked = HybridRecommendationEngine.rank_products(
        products=catalog,
        query="",
        budget=budget,
        preferred_category=category,
        limit=limit,
    )
    return ranked

if __name__ == "__main__":
    uvicorn.run("backend.main:app", host="0.0.0.0", port=8000, reload=True)
