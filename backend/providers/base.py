from abc import ABC, abstractmethod
from typing import List, Optional
from backend.models.schemas import UnifiedProduct

class ProductSourceProvider(ABC):
    """
    Abstract interface for e-commerce product sources.
    Each provider connects to authorized APIs or official catalog feeds.
    Never fabricates live prices, ratings, reviews, or product availability.
    """
    
    @property
    @abstractmethod
    def name(self) -> str:
        """Name of the provider, e.g. 'Amazon India', 'Flipkart', 'Croma'."""
        pass

    @abstractmethod
    async def search(
        self,
        query: str,
        category: Optional[str] = None,
        min_price: Optional[float] = None,
        max_price: Optional[float] = None,
        limit: int = 10,
    ) -> List[UnifiedProduct]:
        """Search products using official API or permitted feed."""
        pass

    @abstractmethod
    async def get_by_id(self, product_id: str) -> Optional[UnifiedProduct]:
        """Fetch product details by ID."""
        pass
