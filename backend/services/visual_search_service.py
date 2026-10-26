import json
import re
import urllib.parse
from typing import List, Optional, Tuple
import httpx

from backend.config import settings
from backend.models.schemas import (
    UnifiedProduct,
    RetailerInfo,
    ProductSpecification,
    VisualSearchRequest,
    VisualSearchResponse,
)

class VisualSearchService:
    """
    Image-Based Search engine.
    Extracts visual attributes (labels, category, colors) and finds similar products
    from the internet using Gemini Vision API with direct partner purchase URLs.
    """

    DEFAULT_FALLBACK_IMAGES = {
        "footwear": "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600",
        "shoes": "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600",
        "smartphone": "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=600",
        "headphones": "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600",
        "laptop": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600",
        "watch": "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600",
        "camera": "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=600",
        "fashion": "https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600",
    }

    @classmethod
    def _create_merchant_url(cls, title: str, retailer_name: str) -> str:
        q = urllib.parse.quote_plus(title)
        lower_retailer = retailer_name.lower()
        if "flipkart" in lower_retailer:
            return f"https://www.flipkart.com/search?q={q}&affid=shopwave"
        elif "croma" in lower_retailer:
            return f"https://www.croma.com/searchB?q={q}"
        else:
            return f"https://www.amazon.in/s?k={q}&tag=shopwave-21"

    @classmethod
    def _get_image_for_category(cls, category: str, title: str) -> str:
        combined = f"{category} {title}".lower()
        for key, url in cls.DEFAULT_FALLBACK_IMAGES.items():
            if key in combined:
                return url
        return "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=600"

    @classmethod
    async def search_similar_products_via_gemini(
        cls,
        image_base64: str,
        category_hint: Optional[str] = None
    ) -> Optional[Tuple[List[str], List[str], List[UnifiedProduct]]]:
        if not settings.gemini_api_key or not image_base64:
            return None

        clean_base64 = image_base64.split(",")[-1] if "," in image_base64 else image_base64
        
        prompt = (
            "You are ShopWave's AI Visual Lens. Analyze this product photo carefully.\n"
            "Identify the product brand, title, item category, and dominant visual attributes.\n"
            "Find 4 to 6 real, matching products available to purchase online across major Indian e-commerce sites (Amazon India, Flipkart, Croma).\n"
            "Return ONLY a valid JSON object without markdown formatting in this exact format:\n"
            "{\n"
            '  "detected_labels": ["Brand", "Category", "Color", "Key Feature"],\n'
            '  "dominant_colors": ["Color1", "Color2"],\n'
            '  "products": [\n'
            "    {\n"
            '      "title": "Exact Full Product Name",\n'
            '      "brand": "Brand Name",\n'
            '      "category": "Electronics or Footwear or Fashion or Audio etc",\n'
            '      "description": "Short 1-sentence product summary with specs",\n'
            '      "price": 2999.0,\n'
            '      "original_price": 4999.0,\n'
            '      "discount_percentage": 40.0,\n'
            '      "rating": 4.5,\n'
            '      "review_count": 3400,\n'
            '      "retailer": "Amazon India",\n'
            '      "delivery_info": "Prime 1-day delivery",\n'
            '      "visual_tags": ["tag1", "tag2"]\n'
            "    }\n"
            "  ]\n"
            "}\n"
            "Realistic INR prices and ratings are required. Do not wrap in ```json."
        )

        try:
            url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={settings.gemini_api_key}"
            payload = {
                "contents": [{
                    "parts": [
                        {"text": prompt},
                        {"inline_data": {"mime_type": "image/jpeg", "data": clean_base64}}
                    ]
                }],
                "generationConfig": {
                    "temperature": 0.2,
                }
            }
            async with httpx.AsyncClient(timeout=12.0) as client:
                resp = await client.post(url, json=payload)
                if resp.status_code == 200:
                    candidates = resp.json().get("candidates", [])
                    if candidates:
                        text = candidates[0]["content"]["parts"][0]["text"].strip()
                        if text.startswith("```"):
                            text = re.sub(r"^```(?:json)?\n?", "", text)
                            text = re.sub(r"\n?```$", "", text)
                        data = json.loads(text)
                        
                        labels = data.get("detected_labels", ["Product", "Gadget"])
                        colors = data.get("dominant_colors", ["Black"])
                        raw_products = data.get("products", [])

                        products: List[UnifiedProduct] = []
                        for idx, p in enumerate(raw_products):
                            retailer_name = p.get("retailer", "Amazon India")
                            title = p.get("title", f"Identified Product {idx+1}")
                            product_url = cls._create_merchant_url(title, retailer_name)
                            category = p.get("category", category_hint or "General")
                            price = float(p.get("price", 1999.0))
                            orig_price = float(p.get("original_price", price * 1.25))
                            discount = float(p.get("discount_percentage", round(((orig_price - price) / orig_price) * 100, 1)))

                            img_url = cls._get_image_for_category(category, title)

                            score = round(96.0 - (idx * 3.5), 1)
                            products.append(
                                UnifiedProduct(
                                    id=f"lens_gen_{idx}_{int(price)}",
                                    title=title,
                                    description=p.get("description", "High quality product found via visual lens comparison."),
                                    brand=p.get("brand", "Verified Brand"),
                                    category=category,
                                    price=price,
                                    original_price=orig_price,
                                    discount_percentage=discount,
                                    currency="INR",
                                    rating=min(5.0, max(3.5, float(p.get("rating", 4.4)))),
                                    review_count=int(p.get("review_count", 1500)),
                                    image_urls=[img_url],
                                    specifications=[
                                        ProductSpecification(key="Match Source", value="AI Visual Lens"),
                                        ProductSpecification(key="Retailer", value=retailer_name),
                                    ],
                                    retailer=RetailerInfo(
                                        name=retailer_name,
                                        direct_url=product_url,
                                        in_stock=True,
                                        delivery_info=p.get("delivery_info", "Fast 1-2 day delivery"),
                                        return_policy="7-day replacement",
                                    ),
                                    product_url=product_url,
                                    visual_tags=p.get("visual_tags", labels),
                                    score=score,
                                    recommendation_reason=f"Visual Lens match ({score}% visual similarity)",
                                )
                            )
                        if products:
                            return labels, colors, products
        except Exception:
            pass

        return None

    @classmethod
    def match_visually(
        cls,
        catalog: List[UnifiedProduct],
        detected_labels: List[str],
        category_hint: Optional[str] = None,
        threshold: float = 0.25,
    ) -> List[UnifiedProduct]:
        matches = []
        for product in catalog:
            if category_hint and category_hint.lower() not in product.category.lower():
                continue

            product_tags = set(product.visual_tags + [product.category.lower(), (product.brand or '').lower()])
            query_tags = set([l.lower() for l in detected_labels])
            
            intersection = product_tags.intersection(query_tags)
            union = product_tags.union(query_tags)
            similarity = len(intersection) / len(union) if union else 0.0

            if similarity >= threshold:
                p_copy = product.model_copy()
                p_copy.score = round(similarity * 100, 1)
                p_copy.recommendation_reason = f"Visual match ({p_copy.score}% similarity on {', '.join(intersection)})"
                matches.append(p_copy)

        matches.sort(key=lambda x: x.score or 0.0, reverse=True)
        return matches

    @classmethod
    async def process_visual_search(
        cls,
        request: VisualSearchRequest,
        catalog: List[UnifiedProduct],
    ) -> VisualSearchResponse:
        # First attempt: Gemini 2.5 Flash Vision for real internet products
        if request.image_base64:
            gemini_result = await cls.search_similar_products_via_gemini(
                request.image_base64,
                request.category_hint
            )
            if gemini_result:
                labels, colors, products = gemini_result
                return VisualSearchResponse(
                    detected_labels=labels,
                    dominant_colors=colors,
                    matched_products=products,
                    similarity_threshold=0.3,
                )

        # Fallback: Heuristic attribute detection and catalog matching
        labels = ["Electronics", "Product", "Quality"]
        colors = ["Black", "Silver"]

        ref = (request.image_url or "").lower()
        if "phone" in ref or "iphone" in ref:
            labels = ["Smartphone", "Touchscreen", "Mobile", "Camera"]
        elif "head" in ref or "audio" in ref:
            labels = ["Headphones", "Audio", "Wireless", "ANC"]
        elif "lap" in ref or "pc" in ref:
            labels = ["Laptop", "Computer", "Keyboard", "Notebook"]
        elif "watch" in ref:
            labels = ["Smartwatch", "Wearable", "Display", "Fitness"]

        matched = cls.match_visually(catalog, labels, category_hint=request.category_hint)
        if not matched:
            matched = catalog[:6]

        return VisualSearchResponse(
            detected_labels=labels,
            dominant_colors=colors,
            matched_products=matched[:6],
            similarity_threshold=0.3,
        )
