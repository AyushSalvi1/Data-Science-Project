import math
from typing import List, Optional, Dict
from backend.models.schemas import UnifiedProduct

class HybridRecommendationEngine:
    """
    Hybrid recommendation algorithm combining:
    1. Hard constraints (budget, category, stock availability)
    2. Relevance scoring (intent, keyword overlap, brand match)
    3. Price & Discount factor (value-for-money metric)
    4. Review Confidence (Bayesian weighted rating)
    5. User Personalization (preferences, previous interactions, wishlist)
    """

    # Bayesian rating prior constants
    DEFAULT_PRIOR_RATING = 4.0
    MIN_CONFIDENCE_VOTES = 50

    @classmethod
    def calculate_bayesian_rating(cls, rating: float, review_count: int) -> float:
        """
        Bayesian formula: (v * R + m * C) / (v + m)
        Avoids overweighting 5-star products with only 1 review.
        """
        v = review_count
        m = cls.MIN_CONFIDENCE_VOTES
        r = rating
        c = cls.DEFAULT_PRIOR_RATING
        return (v * r + m * c) / (v + m)

    @classmethod
    def score_product(
        cls,
        product: UnifiedProduct,
        query_terms: List[str],
        budget: Optional[float] = None,
        preferred_category: Optional[str] = None,
        preferred_retailers: Optional[List[str]] = None,
        user_history: Optional[List[str]] = None,
    ) -> float:
        score = 0.0

        # 1. Hard Constraints
        if budget is not None and product.price > budget * 1.15:
            return -100.0  # severely penalize over-budget products

        if preferred_category and preferred_category.lower() not in product.category.lower():
            # Soft penalty for mismatched category if query is open
            score -= 20.0

        # 2. Relevance Scoring (0 to 40 pts)
        text_corpus = f"{product.title} {product.description} {product.brand or ''} {' '.join(product.visual_tags)}".lower()
        if query_terms:
            matched_terms = sum(1 for term in query_terms if term in text_corpus)
            term_ratio = matched_terms / len(query_terms)
            score += term_ratio * 40.0
        else:
            score += 25.0  # default baseline relevance

        # 3. Review Confidence (0 to 25 pts)
        bayesian_rating = cls.calculate_bayesian_rating(product.rating, product.review_count)
        # Scale 1-5 rating to 0-25 points
        score += (bayesian_rating / 5.0) * 25.0

        # 4. Price & Discount / Value Score (0 to 20 pts)
        if product.discount_percentage:
            discount_pts = min(product.discount_percentage / 5.0, 10.0)
            score += discount_pts
        if budget is not None and product.price <= budget:
            # Good budget utilization score
            budget_proximity = (budget - product.price) / budget
            if budget_proximity >= 0 and budget_proximity <= 0.4:
                score += 10.0  # within 40% sweet spot
            elif budget_proximity > 0.4:
                score += 6.0   # highly economical

        # 5. User Personalization Match (0 to 15 pts)
        if preferred_retailers and product.retailer.name in preferred_retailers:
            score += 5.0
        if user_history:
            for past_term in user_history:
                if past_term.lower() in text_corpus:
                    score += 5.0
                    break

        return score

    @classmethod
    def rank_products(
        cls,
        products: List[UnifiedProduct],
        query: str = "",
        budget: Optional[float] = None,
        preferred_category: Optional[str] = None,
        preferred_retailers: Optional[List[str]] = None,
        user_history: Optional[List[str]] = None,
        limit: int = 10,
    ) -> List[UnifiedProduct]:
        query_terms = [t.lower() for t in query.split() if len(t) > 2]
        
        scored_products = []
        for p in products:
            product_score = cls.score_product(
                p,
                query_terms=query_terms,
                budget=budget,
                preferred_category=preferred_category,
                preferred_retailers=preferred_retailers,
                user_history=user_history,
            )
            if product_score > -50.0:
                p_copy = p.model_copy()
                p_copy.score = round(product_score, 2)
                scored_products.append(p_copy)

        scored_products.sort(key=lambda x: x.score or 0.0, reverse=True)
        return scored_products[:limit]
