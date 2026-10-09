import 'package:flutter_ecommerce/features/product/models/product_image.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const Product._();
  const factory Product({
    required String id,
    required String name,
    required String description,
    required double price,
    @JsonKey(name: "discount_price") required double? discountPrice,
    required List<ProductImage> images,
    @JsonKey(name: "quantity") required int stockQuantity,
  }) = _Product;
  double get currentAmount => discountPrice ?? price;

  double? get discountPercentage =>
      discountPrice == null ? null : (price - discountPrice!) / price * 100;
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

