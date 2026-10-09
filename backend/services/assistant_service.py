import re
from typing import List, Optional, Tuple
from backend.models.schemas import AIAssistantRequest, AIAssistantResponse, UnifiedProduct
from backend.services.recommendation_service import HybridRecommendationEngine

class AIShoppingAssistant:
    """
    Understands natural-language shopping requests, extracts budgets,
    preferences, and key specifications, then curates recommendations with explanations.
    """

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
        elif any(w in text for w in ["laptop", "computer", "macbook", "notebook", "pc"]):
            category = "Computers"
        elif any(w in text for w in ["headphone", "earbud", "audio", "music", "earphones", "sound"]):
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
        }
        for kw, desc in feature_keywords.items():
            if kw in text:
                features.append(desc)

        return category, features

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

        # Rank products using Hybrid Engine
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

        # Conversational reply synthesis
        budget_str = f" under ₹{int(detected_budget):,}" if detected_budget else ""
        category_str = f" {category.lower()}" if category else " products"
        
        if ranked:
            reply = f"I found the best{category_str}{budget_str} tailored to your needs. Here are the top verified options across our partner stores:"
            explanation = f"Recommended based on verified ratings, pricing constraints, and {len(ranked)} merchant offers analyzed."
        else:
            reply = f"I couldn't find an exact match for '{request.message}'. Here are some popular alternative choices:"
            explanation = "Showing general best-sellers based on positive buyer sentiment."

        return AIAssistantResponse(
            reply=reply,
            detected_budget=detected_budget,
            detected_category=category,
            detected_features=detected_features,
            recommendations=ranked,
            explanation=explanation,
        )
