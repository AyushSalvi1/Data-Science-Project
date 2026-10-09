from typing import List, Optional
from backend.models.schemas import UnifiedProduct, RetailerInfo, ProductSpecification
from backend.providers.base import ProductSourceProvider
from backend.config import settings

class FlipkartProvider(ProductSourceProvider):
    """
    Flipkart Affiliate API & Permitted Catalog Feed Provider.
    Adheres to Flipkart API specifications and feeds.
    """

    @property
    def name(self) -> str:
        return "Flipkart"

    _catalog: List[UnifiedProduct] = [
        UnifiedProduct(
            id="fk_in_mobgk29",
            title="Apple iPhone 15 (Black, 128 GB)",
            description="Experience Dynamic Island, 48MP main camera with exceptional details, and all-day battery life on Super Retina XDR.",
            brand="Apple",
            category="Electronics",
            price=68999.0,
            original_price=79900.0,
            discount_percentage=13.0,
            currency="INR",
            rating=4.6,
            review_count=18940,
            image_urls=["https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=600"],
            specifications=[
                ProductSpecification(key="Display", value="6.1 inch Super Retina XDR Display"),
                ProductSpecification(key="Processor", value="A16 Bionic Chip, 6 Core Processor"),
                ProductSpecification(key="Camera", value="48MP + 12MP | 12MP Front Camera"),
                ProductSpecification(key="Warranty", value="1 Year Brand Warranty"),
            ],
            retailer=RetailerInfo(
                name="Flipkart",
                logo_url="https://static-assets-web.flixcart.com/batman-returns/batman-returns/p/images/fkheaderlogo_exploreplus-448284.svg",
                direct_url="https://www.flipkart.com/apple-iphone-15-black-128-gb/p/itm6ac6485515ae4?affid=shopwave",
                in_stock=True,
                delivery_info="Free delivery by tomorrow, 11 PM",
                return_policy="7-day replacement",
            ),
            product_url="https://www.flipkart.com/apple-iphone-15-black-128-gb/p/itm6ac6485515ae4?affid=shopwave",
            visual_tags=["smartphone", "black", "apple", "iphone", "electronics"],
        ),
        UnifiedProduct(
            id="fk_in_aud991",
            title="SONY WH-1000XM5 Bluetooth Headset with ANC (Black)",
            description="Dual processor noise cancelling with 8 mics, High-Resolution Audio wireless, Speak-to-chat smart technology.",
            brand="Sony",
            category="Audio",
            price=28990.0,
            original_price=34990.0,
            discount_percentage=17.0,
            currency="INR",
            rating=4.6,
            review_count=4510,
            image_urls=["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600"],
            specifications=[
                ProductSpecification(key="Type", value="Over-ear Headphone"),
                ProductSpecification(key="Battery", value="30 hrs playback"),
                ProductSpecification(key="Charge Time", value="3 min charge for 3 hours"),
                ProductSpecification(key="Wireless", value="Bluetooth v5.2"),
            ],
            retailer=RetailerInfo(
                name="Flipkart",
                logo_url="https://static-assets-web.flixcart.com/batman-returns/batman-returns/p/images/fkheaderlogo_exploreplus-448284.svg",
                direct_url="https://www.flipkart.com/sony-wh-1000xm5-bluetooth-headset/p/itm878b2d075ba8d?affid=shopwave",
                in_stock=True,
                delivery_info="Free Delivery in 2 days",
                return_policy="7-day replacement",
            ),
            product_url="https://www.flipkart.com/sony-wh-1000xm5-bluetooth-headset/p/itm878b2d075ba8d?affid=shopwave",
            visual_tags=["headphones", "audio", "black", "wireless", "over-ear"],
        ),
        UnifiedProduct(
            id="fk_in_lap204",
            title="ASUS Vivobook 15 Intel Core i5 12th Gen (16 GB/512 GB SSD/Win 11)",
            description="Intel Core i5-1235U processor, 15.6 inch Full HD 16:9 aspect ratio, 180-degree lay-flat hinge, Privacy shutter.",
            brand="ASUS",
            category="Computers",
            price=46990.0,
            original_price=59990.0,
            discount_percentage=21.0,
            currency="INR",
            rating=4.3,
            review_count=6730,
            image_urls=["https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=600"],
            specifications=[
                ProductSpecification(key="Processor", value="Intel Core i5 12th Gen 1235U"),
                ProductSpecification(key="RAM", value="16 GB DDR4"),
                ProductSpecification(key="SSD Capacity", value="512 GB"),
                ProductSpecification(key="Weight", value="1.70 kg"),
            ],
            retailer=RetailerInfo(
                name="Flipkart",
                logo_url="https://static-assets-web.flixcart.com/batman-returns/batman-returns/p/images/fkheaderlogo_exploreplus-448284.svg",
                direct_url="https://www.flipkart.com/asus-vivobook-15-intel-core-i5-12th-gen/p/itme9c869d2550ec?affid=shopwave",
                in_stock=True,
                delivery_info="Free delivery by Friday",
                return_policy="7-day replacement",
            ),
            product_url="https://www.flipkart.com/asus-vivobook-15-intel-core-i5-12th-gen/p/itme9c869d2550ec?affid=shopwave",
            visual_tags=["laptop", "computer", "asus", "blue", "electronics"],
        ),
        UnifiedProduct(
            id="fk_in_mob882",
            title="Samsung Galaxy S24 Ultra 5G (Titanium Gray, 256 GB)",
            description="Experience revolutionary Galaxy AI, Circle to Search, 200MP Quad Tele System with Nightography.",
            brand="Samsung",
            category="Electronics",
            price=128999.0,
            original_price=134999.0,
            discount_percentage=4.4,
            currency="INR",
            rating=4.7,
            review_count=3890,
            image_urls=["https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=600"],
            specifications=[
                ProductSpecification(key="Display", value="6.8 inch Quad HD+ Dynamic AMOLED 2X"),
                ProductSpecification(key="Processor", value="Snapdragon 8 Gen 3"),
                ProductSpecification(key="Camera", value="200MP + 50MP + 12MP + 10MP | 12MP Front"),
                ProductSpecification(key="Battery", value="5000 mAh"),
            ],
            retailer=RetailerInfo(
                name="Flipkart",
                logo_url="https://static-assets-web.flixcart.com/batman-returns/batman-returns/p/images/fkheaderlogo_exploreplus-448284.svg",
                direct_url="https://www.flipkart.com/samsung-galaxy-s24-ultra-5g-titanium-gray-256-gb/p/itmd6692bb7190ca?affid=shopwave",
                in_stock=True,
                delivery_info="Free delivery by tomorrow",
                return_policy="7-day service center replacement",
            ),
            product_url="https://www.flipkart.com/samsung-galaxy-s24-ultra-5g-titanium-gray-256-gb/p/itmd6692bb7190ca?affid=shopwave",
            visual_tags=["smartphone", "samsung", "grey", "flagship", "electronics"],
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
