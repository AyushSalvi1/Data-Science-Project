import 'package:flutter_ecommerce/features/product/models/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

@freezed
class Cart with _$Cart {
  const Cart._();
  const factory Cart({
    required String id,
    required Product product,
    required int quantity,
    @Default(false)
    bool
        isSelected, //we typically use this property to select processing product from cart page
  }) = _Cart;
  double get subTotal => quantity * (product.discountPrice ?? product.price);
  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}
