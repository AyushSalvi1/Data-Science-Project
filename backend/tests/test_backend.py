import pytest
from backend.models.schemas import (
    UnifiedProduct,
    RetailerInfo,
    AIAssistantRequest,
    VisualSearchRequest,
    ProductComparisonRequest,
)
from backend.services.recommendation_service import HybridRecommendationEngine
from backend.services.assistant_service import AIShoppingAssistant
from backend.services.comparison_service import ProductComparisonService
from backend.services.visual_search_service import VisualSearchService
from backend.services.price_tracking_service import PriceTrackingService
from backend.providers.amazon import AmazonIndiaProvider
from backend.providers.flipkart import FlipkartProvider
from backend.providers.croma import CromaProvider

@pytest.mark.asyncio
async def test_providers_catalog_search():
    amz = AmazonIndiaProvider()
    fk = FlipkartProvider()
    croma = CromaProvider()

    amz_results = await amz.search(query="iPhone")
    assert len(amz_results) > 0
    assert "Apple" in amz_results[0].title or "iPhone" in amz_results[0].title

    fk_results = await fk.search(query="Sony")
    assert len(fk_results) > 0
    assert fk_results[0].retailer.name == "Flipkart"

    croma_results = await croma.search(query="Laptop")
    assert len(croma_results) > 0
    assert croma_results[0].retailer.name == "Croma"

def test_bayesian_rating():
    # 5.0 rating with 1 review should NOT outscore 4.8 rating with 5000 reviews
    low_review = HybridRecommendationEngine.calculate_bayesian_rating(5.0, 1)
    high_review = HybridRecommendationEngine.calculate_bayesian_rating(4.8, 5000)
    assert high_review > low_review

def test_budget_extraction():
    assert AIShoppingAssistant.extract_budget("Looking for a phone under 50k") == 50000.0
    assert AIShoppingAssistant.extract_budget("laptop below ₹45,000") == 45000.0
    assert AIShoppingAssistant.extract_budget("earbuds within 2500") == 2500.0

@pytest.mark.asyncio
async def test_ai_shopping_assistant():
    amz = AmazonIndiaProvider()
    catalog = await amz.search(query="")
    req = AIAssistantRequest(message="Best laptop for work under 50000")
    response = await AIShoppingAssistant.process_request(req, catalog)

    assert response.detected_budget == 50000.0
    assert len(response.recommendations) > 0
    assert response.recommendations[0].price <= 50000.0 * 1.15
    assert response.recommendations[0].recommendation_reason is not None

def test_product_comparison_service():
    p1 = UnifiedProduct(
        id="1", title="Phone X", description="Desc", category="Electronics",
        price=50000.0, original_price=55000.0, rating=4.5, review_count=1000,
        retailer=RetailerInfo(name="Amazon India", direct_url="https://amazon.in"),
        product_url="https://amazon.in",
    )
    p2 = UnifiedProduct(
        id="2", title="Phone X", description="Desc", category="Electronics",
        price=48000.0, original_price=55000.0, rating=4.6, review_count=1200,
        retailer=RetailerInfo(name="Flipkart", direct_url="https://flipkart.com"),
        product_url="https://flipkart.com",
    )
    resp = ProductComparisonService.compare_products([p1, p2], "Phone X")
    assert len(resp.top_3_overall) == 2
    assert len(resp.best_offers_by_retailer) == 2
    assert resp.best_offers_by_retailer[0].retailer == "Flipkart"
    assert resp.best_offers_by_retailer[0].is_best_price is True

def test_price_tracking_service():
    p = UnifiedProduct(
        id="1", title="Gadget", description="Desc", category="Electronics",
        price=1000.0, original_price=1200.0, rating=4.5, review_count=50,
        retailer=RetailerInfo(name="ShopWave", direct_url=""), product_url="",
    )
    hist = PriceTrackingService.get_price_history(p)
    assert hist.current_price == 1000.0
    assert len(hist.history) == 5
    assert hist.price_trend in ["dropping", "stable", "rising"]
