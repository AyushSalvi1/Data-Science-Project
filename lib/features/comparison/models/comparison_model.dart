import 'package:flutter_ecommerce/features/multi_retailer/models/retailer_product.dart';

class ComparisonMatrixItemModel {
  final String retailer;
  final String title;
  final double price;
  final double? originalPrice;
  final double savings;
  final double rating;
  final int reviewCount;
  final String availability;
  final String productUrl;
  final List<String> keyHighlights;
  final bool isBestPrice;
  final bool isHighestRated;
  final bool isBestValue;

  ComparisonMatrixItemModel({
    required this.retailer,
    required this.title,
    required this.price,
    this.originalPrice,
    required this.savings,
    required this.rating,
    required this.reviewCount,
    required this.availability,
    required this.productUrl,
    required this.keyHighlights,
    required this.isBestPrice,
    required this.isHighestRated,
    required this.isBestValue,
  });

  factory ComparisonMatrixItemModel.fromJson(Map<String, dynamic> json) {
    return ComparisonMatrixItemModel(
      retailer: json['retailer'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      savings: (json['savings'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      availability: json['availability'] as String? ?? 'In Stock',
      productUrl: json['product_url'] as String? ?? '',
      keyHighlights: (json['key_highlights'] as List?)?.map((e) => e.toString()).toList() ?? [],
      isBestPrice: json['is_best_price'] as bool? ?? false,
      isHighestRated: json['is_highest_rated'] as bool? ?? false,
      isBestValue: json['is_best_value'] as bool? ?? false,
    );
  }
}

class ProductComparisonModel {
  final String productTitle;
  final List<RetailerProductModel> top3Overall;
  final List<ComparisonMatrixItemModel> bestOffersByRetailer;
  final String verdict;

  ProductComparisonModel({
    required this.productTitle,
    required this.top3Overall,
    required this.bestOffersByRetailer,
    required this.verdict,
  });

  factory ProductComparisonModel.fromJson(Map<String, dynamic> json) {
    return ProductComparisonModel(
      productTitle: json['product_title'] as String? ?? 'Comparison',
      top3Overall: (json['top_3_overall'] as List?)
              ?.map((e) => RetailerProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      bestOffersByRetailer: (json['best_offers_by_retailer'] as List?)
              ?.map((e) => ComparisonMatrixItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      verdict: json['verdict'] as String? ?? '',
    );
  }
}
