from typing import List, Dict
from backend.models.schemas import (
    UnifiedProduct,
    ProductComparisonResponse,
    ComparisonMatrixItem,
)
from backend.services.recommendation_service import HybridRecommendationEngine

class ProductComparisonService:
    """
    Compares prices, ratings, review counts, specifications, discounts,
    and availability. Produces:
    1. Top 3 products overall
    2. Best offer from each supported website (Amazon India, Flipkart, Croma)
    3. Clear verdict and value highlights
    """

    @classmethod
    def compare_products(
        cls,
        products: List[UnifiedProduct],
        target_title: str = "Product Comparison",
    ) -> ProductComparisonResponse:
        if not products:
            return ProductComparisonResponse(
                product_title=target_title,
                top_3_overall=[],
                best_offers_by_retailer=[],
                verdict="No products available for comparison.",
            )

        # 1. Calculate Top 3 Overall using Bayesian Rating & Value scoring
        scored = HybridRecommendationEngine.rank_products(
            products=products,
            limit=3,
        )

        # 2. Find best offer per retailer
        retailer_groups: Dict[str, List[UnifiedProduct]] = {}
        for p in products:
            r_name = p.retailer.name
            retailer_groups.setdefault(r_name, []).append(p)

        best_offers: List[ComparisonMatrixItem] = []
        all_prices = [p.price for p in products]
        min_price = min(all_prices) if all_prices else 0.0
        max_rating = max(p.rating for p in products) if products else 0.0

        for r_name, group in retailer_groups.items():
            # Best offer in this retailer: lowest price with highest rating
            best_prod = min(group, key=lambda x: (x.price, -x.rating))
            savings = (best_prod.original_price - best_prod.price) if best_prod.original_price else 0.0
            
            highlights = []
            if best_prod.price == min_price:
                highlights.append("Lowest Price Overall")
            if best_prod.rating == max_rating:
                highlights.append("Top Customer Rating")
            if best_prod.discount_percentage and best_prod.discount_percentage >= 15:
                highlights.append(f"{best_prod.discount_percentage:.0f}% Steep Discount")
            if best_prod.retailer.delivery_info:
                highlights.append(best_prod.retailer.delivery_info)

            best_offers.append(
                ComparisonMatrixItem(
                    retailer=r_name,
                    title=best_prod.title,
                    price=best_prod.price,
                    original_price=best_prod.original_price,
                    savings=savings,
                    rating=best_prod.rating,
                    review_count=best_prod.review_count,
                    availability="In Stock" if best_prod.retailer.in_stock else "Out of Stock",
                    product_url=best_prod.product_url,
                    key_highlights=highlights,
                    is_best_price=(best_prod.price == min_price),
                    is_highest_rated=(best_prod.rating == max_rating),
                    is_best_value=(best_prod.price == min_price and best_prod.rating >= 4.4),
                )
            )

        # Sort best offers by price ascending
        best_offers.sort(key=lambda x: x.price)

        # 3. Formulate analytical verdict
        cheapest_offer = best_offers[0] if best_offers else None
        if cheapest_offer:
            verdict = (
                f"Best deal is on {cheapest_offer.retailer} at ₹{cheapest_offer.price:,.0f} "
                f"with a {cheapest_offer.rating}★ rating ({cheapest_offer.review_count:,} reviews). "
            )
            if len(best_offers) > 1:
                price_diff = best_offers[-1].price - cheapest_offer.price
                if price_diff > 0:
                    verdict += f"You save up to ₹{price_diff:,.0f} compared to {best_offers[-1].retailer}."
        else:
            verdict = "Multiple competitive offers found across partner stores."

        return ProductComparisonResponse(
            product_title=target_title,
            top_3_overall=scored,
            best_offers_by_retailer=best_offers,
            verdict=verdict,
        )
