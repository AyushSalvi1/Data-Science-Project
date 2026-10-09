from typing import List, Optional
from backend.models.schemas import UnifiedProduct, RetailerInfo, ProductSpecification
from backend.providers.base import ProductSourceProvider
from backend.config import settings

class CromaProvider(ProductSourceProvider):
    """
    Croma Electronics Permitted Catalog & Store Feed Provider.
    Tata digital omnichannel retailer feeds for electronics and home appliances.
    """

    @property
    def name(self) -> str:
        return "Croma"

    _catalog: List[UnifiedProduct] = [
        UnifiedProduct(
            id="cro_in_300812",
            title="Apple iPhone 15 (128GB, Black)",
            description="6.1-inch Super Retina XDR OLED Display, A16 Bionic chip with 5-core GPU, Ceramic Shield front glass.",
            brand="Apple",
            category="Electronics",
            price=70900.0,
            original_price=79900.0,
            discount_percentage=11.0,
            currency="INR",
            rating=4.7,
            review_count=3200,
            image_urls=["https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=600"],
            specifications=[
                ProductSpecification(key="Display", value="6.1-inch OLED Super Retina"),
                ProductSpecification(key="Chipset", value="Apple A16 Bionic"),
                ProductSpecification(key="Store Pickup", value="Available at 240+ Croma Stores"),
                ProductSpecification(key="Warranty", value="1 Year Apple Manufacturer Warranty"),
            ],
            retailer=RetailerInfo(
                name="Croma",
                logo_url="https://media.croma.com/sys-master/dimages/h9c/hd7/8916307181598/croma_logo.png",
                direct_url="https://www.croma.com/apple-iphone-15-128gb-black-/p/300812?utm_source=shopwave",
                in_stock=True,
                delivery_info="Standard delivery in 2 days | Express store pickup",
                return_policy="14-day hassle-free exchange",
            ),
            product_url="https://www.croma.com/apple-iphone-15-128gb-black-/p/300812?utm_source=shopwave",
            visual_tags=["smartphone", "black", "apple", "iphone", "electronics"],
        ),
        UnifiedProduct(
            id="cro_in_256840",
            title="Sony WH-1000XM5 Over-Ear Noise Cancelling Headphones (Black)",
            description="Integrated Processor V1 and QN1, ultra-comfortable soft fit leather, 30-hour battery life with Quick Charging.",
            brand="Sony",
            category="Audio",
            price=29490.0,
            original_price=34990.0,
            discount_percentage=15.0,
            currency="INR",
            rating=4.6,
            review_count=1820,
            image_urls=["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600"],
            specifications=[
                ProductSpecification(key="Form Factor", value="Over-Ear Headband"),
                ProductSpecification(key="Noise Cancellation", value="Dual Processor ANC"),
                ProductSpecification(key="Battery Life", value="30 Hours"),
                ProductSpecification(key="Store Demo", value="Available at local Croma store"),
            ],
            retailer=RetailerInfo(
                name="Croma",
                logo_url="https://media.croma.com/sys-master/dimages/h9c/hd7/8916307181598/croma_logo.png",
                direct_url="https://www.croma.com/sony-wh-1000xm5-over-ear-headphones/p/256840?utm_source=shopwave",
                in_stock=True,
                delivery_info="Delivery in 24 hours in metro cities",
                return_policy="15-day replacement",
            ),
            product_url="https://www.croma.com/sony-wh-1000xm5-over-ear-headphones/p/256840?utm_source=shopwave",
            visual_tags=["headphones", "audio", "black", "wireless", "over-ear"],
        ),
        UnifiedProduct(
            id="cro_in_265431",
            title="Dell 15 Intel Core i5 12th Gen Laptop (16GB RAM, 512GB SSD, Windows 11)",
            description="15.6 FHD 120Hz display with narrow borders, spill-resistant keyboard, Dell ExpressCharge technology.",
            brand="Dell",
            category="Computers",
            price=48490.0,
            original_price=61990.0,
            discount_percentage=21.0,
            currency="INR",
            rating=4.4,
            review_count=1450,
            image_urls=["https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=600"],
            specifications=[
                ProductSpecification(key="Processor", value="Intel Core i5-1235U"),
                ProductSpecification(key="RAM", value="16GB DDR4"),
                ProductSpecification(key="Storage", value="512GB SSD"),
                ProductSpecification(key="Warranty", value="1 Year Dell Onsite Warranty"),
            ],
            retailer=RetailerInfo(
                name="Croma",
                logo_url="https://media.croma.com/sys-master/dimages/h9c/hd7/8916307181598/croma_logo.png",
                direct_url="https://www.croma.com/dell-15-laptop-intel-core-i5/p/265431?utm_source=shopwave",
                in_stock=True,
                delivery_info="Standard delivery in 2 days",
                return_policy="7-day replacement",
            ),
            product_url="https://www.croma.com/dell-15-laptop-intel-core-i5/p/265431?utm_source=shopwave",
            visual_tags=["laptop", "computer", "dell", "silver", "electronics"],
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
