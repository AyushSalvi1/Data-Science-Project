import 'package:flutter_ecommerce/features/product/models/product.dart';

class WishlistItem {
  final String id;
  final String userId;
  final String productId;
  final Product? product;
  final DateTime createdAt;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.productId,
    this.product,
    required this.createdAt,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      product: json['product'] != null
          ? Product.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
