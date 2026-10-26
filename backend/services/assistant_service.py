import json
import re
import urllib.parse
from typing import List, Optional, Tuple
import httpx
from backend.config import settings
from backend.models.schemas import (
    AIAssistantRequest,
    AIAssistantResponse,
    UnifiedProduct,
    RetailerInfo,
    ProductSpecification,
)
from backend.services.recommendation_service import HybridRecommendationEngine

class AIShoppingAssistant:
    """
    Understands natural-language shopping requests across all product categories,
    extracts budgets, preferences, and key specifications, then curates recommendations with explanations.
    """

    DEFAULT_FALLBACK_IMAGES = {
        "footwear": "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600",
        "shoes": "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600",
        "smartphone": "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=600",
        "headphones": "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600",
        "laptop": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600",
        "watch": "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600",
        "fashion": "https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600",
        "camera": "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=600",
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
    def extract_budget(cls, message: str) -> Optional[float]:
        """Extract budget constraints like 'under 50k', 'below 30000', 'budget ₹70,000'."""
        text = message.lower().replace(",", "")
        
        # Matches: under 50k, below 50k, under 50 k
        match_k = re.search(r'(?:under|below|budget|around|within|upto|up to)\s*(?:rs\.?|inr|₹)?\s*(\d+(?:\.\d+)?)\s*k\b', text)
        if match_k:
            return float(match_k.group(1)) * 1000

        # Matches: under 50000, below 50000, ₹50000
        match_num = re.search(r'(?:under|below|budget|around|within|upto|up to|worth)\s*(?:rs\.?|inr|₹)?\s*(\d{3,7})\b', text)
        if match_num:
            return float(match_num.group(1))

        # Direct currency pattern: ₹50000 or Rs. 50000
        match_curr = re.search(r'(?:rs\.?|inr|₹)\s*(\d{3,7})\b', text)
        if match_curr:
            return float(match_curr.group(1))

        return None

    @classmethod
    def extract_category_and_features(cls, message: str) -> Tuple[Optional[str], List[str]]:
        text = message.lower()
        category = None
        features = []

        # Category detection
        if any(w in text for w in ["phone", "smartphone", "iphone", "galaxy", "mobile", "android"]):
            category = "Electronics"
        elif any(w in text for w in ["shoe", "sneaker", "boot", "footwear", "running"]):
            category = "Footwear"
        elif any(w in text for w in ["shirt", "pant", "saree", "dress", "tshirt", "jeans", "cloth", "fashion"]):
            category = "Fashion"
        elif any(w in text for w in ["laptop", "computer", "macbook", "notebook", "pc", "keyboard", "mouse"]):
            category = "Computers"
        elif any(w in text for w in ["headphone", "earbud", "audio", "music", "earphones", "sound", "speaker"]):
            category = "Audio"
        elif any(w in text for w in ["watch", "fitness", "smartwatch", "band"]):
            category = "Wearables"

        # Feature detection
        feature_keywords = {
            "noise cancelling": "Active Noise Cancellation (ANC)",
            "battery": "Long Battery Life",
            "camera": "High-Resolution Camera",
            "gaming": "High Performance Gaming",
            "ram": "High RAM Configuration",
            "display": "AMOLED/Retina Display",
            "water": "Water/Sweat Resistance",
            "calling": "Bluetooth Calling",
            "light": "Lightweight & Portable",
            "running": "Ergonomic Cushioning for Running",
            "wireless": "Wireless Bluetooth Connectivity",
        }
        for kw, desc in feature_keywords.items():
            if kw in text:
                features.append(desc)

        return category, features

    @classmethod
    async def query_gemini_smart_recommendations(
        cls,
        user_message: str,
        budget: Optional[float],
        category: Optional[str],
        features: List[str],
    ) -> Optional[Tuple[str, str, List[UnifiedProduct]]]:
        if not settings.gemini_api_key:
            return None

        prompt = (
            f"You are ShopWave's AI shopping assistant. A user from India asks: \"{user_message}\".\n"
            f"Budget constraint: ₹{budget:,.0f} (if specified).\n"
            f"Category: {category or 'General'}.\n\n"
            f"Recommend 3 to 4 REAL products that directly match the user's specific request "
            f"(DO NOT recommend iPhones or phones if the user asked for shoes, laptops, audio, clothes, or other products!).\n"
            f"Ensure recommendations fit within the budget if specified.\n"
            f"Return ONLY valid JSON in this exact structure without markdown backticks:\n"
            f"{{\n"
            f'  "reply": "Friendly 1-2 sentence response directly answering the shopper",\n'
            f'  "explanation": "1-sentence analytical reasoning highlighting savings and product value",\n'
            f'  "products": [\n'
            f"    {{\n"
            f'      "title": "Exact Product Name with Brand and Key Spec",\n'
            f'      "brand": "Brand",\n'
            f'      "category": "Category name",\n'
            f'      "description": "Short 1-sentence product summary",\n'
            f'      "price": 2499.0,\n'
            f'      "original_price": 3999.0,\n'
            f'      "discount_percentage": 37.0,\n'
            f'      "rating": 4.5,\n'
            f'      "review_count": 2800,\n'
            f'      "retailer": "Amazon India or Flipkart or Croma",\n'
            f'      "delivery_info": "Prime 1-day delivery",\n'
            f'      "recommendation_reason": "Why this fits their search perfectly"\n'
            f"    }}\n"
            f"  ]\n"
            f"}}\n"
        )

        try:
            url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={settings.gemini_api_key}"
            payload = {
                "contents": [{"parts": [{"text": prompt}]}],
                "generationConfig": {"temperature": 0.2}
            }
            async with httpx.AsyncClient(timeout=10.0) as client:
                resp = await client.post(url, json=payload)
                if resp.status_code == 200:
                    candidates = resp.json().get("candidates", [])
                    if candidates:
                        raw_text = candidates[0]["content"]["parts"][0]["text"].strip()
                        if raw_text.startswith("```"):
                            raw_text = re.sub(r"^```(?:json)?\n?", "", raw_text)
                            raw_text = re.sub(r"\n?```$", "", raw_text)
                        data = json.loads(raw_text)

                        reply = data.get("reply", "Here are the top-rated recommendations matching your search:")
                        explanation = data.get("explanation", "Curated via AI based on verified ratings, pricing, and partner availability.")
                        raw_prods = data.get("products", [])

                        products: List[UnifiedProduct] = []
                        for idx, p in enumerate(raw_prods):
                            retailer_name = p.get("retailer", "Amazon India")
                            title = p.get("title", f"Recommended Offer {idx+1}")
                            product_url = cls._create_merchant_url(title, retailer_name)
                            p_category = p.get("category", category or "General")
                            price = float(p.get("price", 1999.0))
                            orig_price = float(p.get("original_price", price * 1.2))
                            discount = float(p.get("discount_percentage", round(((orig_price - price) / orig_price) * 100, 1)))

                            img_url = cls._get_image_for_category(p_category, title)

                            products.append(
                                UnifiedProduct(
                                    id=f"ai_gen_{idx}_{int(price)}",
                                    title=title,
                                    description=p.get("description", "Top-rated product recommended for your query."),
                                    brand=p.get("brand", "Verified Brand"),
                                    category=p_category,
                                    price=price,
                                    original_price=orig_price,
                                    discount_percentage=discount,
                                    currency="INR",
                                    rating=min(5.0, max(3.5, float(p.get("rating", 4.5)))),
                                    review_count=int(p.get("review_count", 2100)),
                                    image_urls=[img_url],
                                    specifications=[
                                        ProductSpecification(key="Retailer", value=retailer_name),
                                        ProductSpecification(key="Curated For", value=user_message),
                                    ],
                                    retailer=RetailerInfo(
                                        name=retailer_name,
                                        direct_url=product_url,
                                        in_stock=True,
                                        delivery_info=p.get("delivery_info", "Fast 1-2 day delivery"),
                                        return_policy="7-day replacement",
                                    ),
                                    product_url=product_url,
                                    visual_tags=[p_category.lower(), p.get("brand", "").lower()],
                                    score=round(97.0 - (idx * 3.0), 1),
                                    recommendation_reason=p.get("recommendation_reason", f"Best value on {retailer_name}"),
                                )
                            )
                        if products:
                            return reply, explanation, products
        except Exception:
            pass

        return None

    @classmethod
    def generate_explanation(
        cls,
        product: UnifiedProduct,
        user_message: str,
        budget: Optional[float],
        features: List[str]
    ) -> str:
        reasons = []
        if budget and product.price <= budget:
            savings = int(budget - product.price)
            if savings > 0:
                reasons.append(f"Fits within your budget of ₹{int(budget):,} (saves you ₹{savings:,})")
            else:
                reasons.append(f"Meets your exact budget limit of ₹{int(budget):,}")

        if product.rating >= 4.4:
            reasons.append(f"Highly praised by users with a {product.rating}★ rating ({product.review_count:,} reviews)")

        if product.discount_percentage and product.discount_percentage > 10:
            reasons.append(f"Currently on sale with {product.discount_percentage:.0f}% off on {product.retailer.name}")

        for feat in features:
            if feat.lower() in product.description.lower() or any(feat.lower() in str(s.value).lower() for s in product.specifications):
                reasons.append(f"Includes requested feature: {feat}")

        if not reasons:
            reasons.append(f"Top trending choice on {product.retailer.name} for your search")

        return " • ".join(reasons)

    @classmethod
    async def process_request(
        cls,
        request: AIAssistantRequest,
        catalog: List[UnifiedProduct],
    ) -> AIAssistantResponse:
        detected_budget = request.budget or cls.extract_budget(request.message)
        detected_category, detected_features = cls.extract_category_and_features(request.message)
        category = request.category_preference or detected_category

        # Check if catalog has direct matches for this query
        query_words = [w.lower() for w in request.message.split() if len(w) > 2]
        catalog_matches = [
            p for p in catalog
            if any(w in p.title.lower() or w in p.category.lower() or (p.brand and w in p.brand.lower()) for w in query_words)
        ]

        # If catalog has strong matches, use HybridRecommendationEngine
        if catalog_matches:
            ranked = HybridRecommendationEngine.rank_products(
                products=catalog_matches,
                query=request.message,
                budget=detected_budget,
                preferred_category=category,
                user_history=request.user_history,
                limit=4,
            )
            for p in ranked:
                p.recommendation_reason = cls.generate_explanation(
                    p, request.message, detected_budget, detected_features
                )
            
            budget_str = f" under ₹{int(detected_budget):,}" if detected_budget else ""
            return AIAssistantResponse(
                reply=f"I found the best verified options{budget_str} tailored to your search across our partner stores:",
                detected_budget=detected_budget,
                detected_category=category,
                detected_features=detected_features,
                recommendations=ranked,
                explanation=f"Ranked by price-to-performance, customer satisfaction, and {len(ranked)} merchant offers analyzed.",
            )

        # If catalog does not match the user's specific request (e.g. shoes, clothing, laptops),
        # use Gemini 2.5 Flash to generate accurate, query-specific recommendations
        gemini_res = await cls.query_gemini_smart_recommendations(
            user_message=request.message,
            budget=detected_budget,
            category=category,
            features=detected_features,
        )

        if gemini_res:
            reply, explanation, products = gemini_res
            return AIAssistantResponse(
                reply=reply,
                detected_budget=detected_budget,
                detected_category=category,
                detected_features=detected_features,
                recommendations=products,
                explanation=explanation,
            )

        # Fallback if offline: Rank general catalog but do not force iPhones if another category was requested
        ranked = HybridRecommendationEngine.rank_products(
            products=catalog,
            query=request.message,
            budget=detected_budget,
            preferred_category=category,
            user_history=request.user_history,
            limit=4,
        )
        for p in ranked:
            p.recommendation_reason = cls.generate_explanation(
                p, request.message, detected_budget, detected_features
            )

        return AIAssistantResponse(
            reply=f"Here are the top verified options tailored to your request:",
            detected_budget=detected_budget,
            detected_category=category,
            detected_features=detected_features,
            recommendations=ranked,
            explanation="Showing top trending products based on positive user reviews and value.",
        )

