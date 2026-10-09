from typing import List, Optional
from backend.models.schemas import UnifiedProduct, RetailerInfo, ProductSpecification
from backend.providers.base import ProductSourceProvider

class ShopWaveProvider(ProductSourceProvider):
    """
    ShopWave internal catalog provider connecting local vendor offerings.
    """

    @property
    def name(self) -> str:
        return "ShopWave"

    _catalog: List[UnifiedProduct] = [
        UnifiedProduct(
            id="sw_prod_001",
            title="Premium Ergonomic Wireless Keyboard & Mouse Combo",
            description="Whisper-quiet mechanical feel keys, rechargeable lithium battery, dual bluetooth 5.0 + 2.4G wireless adapter.",
            brand="ShopWave Pro",
            category="Computers",
            price=2499.0,
            original_price=3999.0,
            discount_percentage=37.5,
            currency="INR",
            rating=4.5,
            review_count=840,
            image_urls=["https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600"],
            specifications=[
                ProductSpecification(key="Connectivity", value="Bluetooth 5.0 + 2.4G USB"),
                ProductSpecification(key="Battery", value="500mAh Rechargeable"),
                ProductSpecification(key="Compatibility", value="Windows, macOS, Android, iOS"),
            ],
            retailer=RetailerInfo(
                name="ShopWave",
                logo_url=None,
                direct_url="/products/sw_prod_001",
                in_stock=True,
                delivery_info="Free ShopWave Prime delivery in 2 days",
                return_policy="10-day direct replacement",
            ),
            product_url="/products/sw_prod_001",
            visual_tags=["keyboard", "mouse", "wireless", "computer", "ergonomic", "electronics"],
        ),
        UnifiedProduct(
            id="sw_prod_002",
            title="Active Noise Cancelling Wireless Earbuds (IPX5 Water Resistant)",
            description="Deep bass 12mm drivers, 4-mic ENC for crystal-clear calls, 36 hours total battery with fast USB-C charge case.",
            brand="SoundWave",
            category="Audio",
            price=1999.0,
            original_price=4499.0,
            discount_percentage=55.5,
            currency="INR",
            rating=4.3,
            review_count=1290,
            image_urls=["https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600"],
            specifications=[
                ProductSpecification(key="Driver", value="12mm Dynamic Bass Driver"),
                ProductSpecification(key="Water Resistance", value="IPX5 Sweat & Splash Proof"),
                ProductSpecification(key="Battery Life", value="36 Hours total"),
            ],
            retailer=RetailerInfo(
                name="ShopWave",
                logo_url=None,
                direct_url="/products/sw_prod_002",
                in_stock=True,
                delivery_info="Express shipping available",
                return_policy="7-day return policy",
            ),
            product_url="/products/sw_prod_002",
            visual_tags=["earbuds", "audio", "wireless", "tws", "soundwave", "electronics"],
        ),
        UnifiedProduct(
            id="sw_prod_003",
            title="Smart Fitness Watch with 1.85-inch AMOLED Display & Bluetooth Calling",
            description="Always-on AMOLED display, 120+ sports modes, 24/7 heart rate, SpO2, and sleep tracking with zinc alloy frame.",
            brand="FitPulse",
            category="Wearables",
            price=2799.0,
            original_price=5999.0,
            discount_percentage=53.3,
            currency="INR",
            rating=4.4,
            review_count=2150,
            image_urls=["https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600"],
            specifications=[
                ProductSpecification(key="Display", value="1.85 inch AMOLED 454x454"),
                ProductSpecification(key="Sensors", value="Optical HR, SpO2, Accelerometer"),
                ProductSpecification(key="Battery", value="7 days normal usage"),
            ],
            retailer=RetailerInfo(
                name="ShopWave",
                logo_url=None,
                direct_url="/products/sw_prod_003",
                in_stock=True,
                delivery_info="ShopWave Next-Day delivery",
                return_policy="7-day replacement",
            ),
            product_url="/products/sw_prod_003",
            visual_tags=["smartwatch", "wearables", "fitness", "watch", "black", "electronics"],
        ),
    ]

    async def search(
        self,
        query: str,
        category: Optional[str] = None,
        min_price: Optional[float] = None,
        max_price: Optional[float] = None,
        limit: int = 10,
    ) -> List[UnifiedProduct]:
        query_terms = [t.lower() for t in query.split() if t]
        results = []
        for item in self._catalog:
            if min_price is not None and item.price < min_price:
                continue
            if max_price is not None and item.price > max_price:
                continue
            if category and category.lower() not in item.category.lower():
                continue
            item_text = f"{item.title} {item.description} {item.brand} {' '.join(item.visual_tags)}".lower()
            if not query_terms or any(term in item_text for term in query_terms):
                results.append(item)
        return results[:limit]

    async def get_by_id(self, product_id: str) -> Optional[UnifiedProduct]:
        for item in self._catalog:
            if item.id == product_id:
                return item
        return None
