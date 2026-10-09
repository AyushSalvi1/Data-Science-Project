class ProductSearchParams {
  final String? query;
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final bool? hasDiscount;

  const ProductSearchParams({
    this.query,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.hasDiscount,
  });
}
