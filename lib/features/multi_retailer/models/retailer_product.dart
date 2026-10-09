class RetailerInfoModel {
  final String name;
  final String? logoUrl;
  final String directUrl;
  final bool inStock;
  final String deliveryInfo;
  final String returnPolicy;

  RetailerInfoModel({
    required this.name,
    this.logoUrl,
    required this.directUrl,
    this.inStock = true,
    this.deliveryInfo = 'Standard delivery in 2-4 days',
    this.returnPolicy = '7-day replacement',
  });

  factory RetailerInfoModel.fromJson(Map<String, dynamic> json) {
    return RetailerInfoModel(
      name: json['name'] as String? ?? 'ShopWave',
      logoUrl: json['logo_url'] as String?,
      directUrl: json['direct_url'] as String? ?? '',
      inStock: json['in_stock'] as bool? ?? true,
      deliveryInfo: json['delivery_info'] as String? ?? 'Standard delivery in 2-4 days',
      returnPolicy: json['return_policy'] as String? ?? '7-day replacement',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo_url': logoUrl,
      'direct_url': directUrl,
      'in_stock': inStock,
      'delivery_info': deliveryInfo,
      'return_policy': returnPolicy,
    };
  }
}

class RetailerProductModel {
  final String id;
  final String title;
  final String description;
  final String brand;
  final String category;
  final double price;
  final double? originalPrice;
  final double? discountPercentage;
  final double rating;
  final int reviewCount;
  final List<String> imageUrls;
  final RetailerInfoModel retailer;
  final String productUrl;
  final List<String> visualTags;
  final double? score;
  final String? recommendationReason;

  RetailerProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.brand,
    required this.category,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    required this.rating,
    required this.reviewCount,
    required this.imageUrls,
    required this.retailer,
    required this.productUrl,
    this.visualTags = const [],
    this.score,
    this.recommendationReason,
  });

  factory RetailerProductModel.fromJson(Map<String, dynamic> json) {
    final retailerJson = json['retailer'] as Map<String, dynamic>? ?? {};
    return RetailerProductModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      brand: json['brand'] as String? ?? 'Generic',
      category: json['category'] as String? ?? 'General',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      discountPercentage: (json['discount_percentage'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 4.0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      imageUrls: (json['image_urls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      retailer: RetailerInfoModel.fromJson(retailerJson),
      productUrl: json['product_url'] as String? ?? '',
      visualTags: (json['visual_tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      score: (json['score'] as num?)?.toDouble(),
      recommendationReason: json['recommendation_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'brand': brand,
      'category': category,
      'price': price,
      'original_price': originalPrice,
      'discount_percentage': discountPercentage,
      'rating': rating,
      'review_count': reviewCount,
      'image_urls': imageUrls,
      'retailer': retailer.toJson(),
      'product_url': productUrl,
      'visual_tags': visualTags,
      'score': score,
      'recommendation_reason': recommendationReason,
    };
  }
}
