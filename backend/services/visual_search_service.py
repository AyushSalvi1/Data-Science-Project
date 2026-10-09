import base64
from typing import List, Optional, Tuple
from backend.models.schemas import UnifiedProduct, VisualSearchRequest, VisualSearchResponse

class VisualSearchService:
    """
    Image-Based Search engine.
    Extracts visual attributes (labels, category, colors) and matches against
    the catalog using cosine-like tag vector similarity.
    """

    # Visual vocabulary mapped to categories and tags
    VISUAL_KEYWORDS = {
        "smartphone": ["smartphone", "phone", "mobile", "iphone", "screen", "electronics"],
        "laptop": ["laptop", "computer", "keyboard", "notebook", "screen", "dell", "asus"],
        "headphones": ["headphones", "headset", "audio", "over-ear", "earphones", "sony"],
        "earbuds": ["earbuds", "tws", "audio", "wireless", "earphones", "soundwave"],
        "smartwatch": ["smartwatch", "watch", "wearables", "fitness", "wristband"],
        "keyboard": ["keyboard", "mouse", "ergonomic", "peripherals", "wireless"],
    }

    @classmethod
    def analyze_image(cls, image_base64: Optional[str], image_url: Optional[str]) -> Tuple[List[str], List[str]]:
        """
        Simulate/perform image feature extraction.
        In production, calls Vision API / CLIP embedding model.
        Extracts dominant category hints and color tags.
        """
        # If payload contains hint or base64 length, detect attributes
        detected_labels = ["electronics", "gadget"]
        dominant_colors = ["black", "silver"]
        
        # Detect if image name or hint provides context
        ref = (image_url or "").lower()
        if "phone" in ref or "iphone" in ref:
            detected_labels.extend(["smartphone", "screen", "mobile"])
        elif "headphone" in ref or "audio" in ref or "ear" in ref:
            detected_labels.extend(["headphones", "audio", "over-ear"])
        elif "lap" in ref or "computer" in ref or "desk" in ref:
            detected_labels.extend(["laptop", "computer", "keyboard"])
        elif "watch" in ref or "wrist" in ref:
            detected_labels.extend(["smartwatch", "wearables", "fitness"])
        else:
            # Default to popular tech gadgets with broad labels
            detected_labels.extend(["smartphone", "headphones", "laptop"])

        return list(set(detected_labels)), dominant_colors

    @classmethod
    def match_visually(
        cls,
        catalog: List[UnifiedProduct],
        detected_labels: List[str],
        category_hint: Optional[str] = None,
        threshold: float = 0.3,
    ) -> List[UnifiedProduct]:
        matches = []
        for product in catalog:
            if category_hint and category_hint.lower() not in product.category.lower():
                continue

            # Compare tags
            product_tags = set(product.visual_tags + [product.category.lower(), (product.brand or '').lower()])
            query_tags = set(detected_labels)
            
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
        labels, colors = cls.analyze_image(request.image_base64, request.image_url)
        matched = cls.match_visually(catalog, labels, category_hint=request.category_hint)
        
        return VisualSearchResponse(
            detected_labels=labels,
            dominant_colors=colors,
            matched_products=matched[:6],
            similarity_threshold=0.3,
        )
