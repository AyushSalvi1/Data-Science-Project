// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_ecommerce/features/cart/models/cart.dart';
import 'package:flutter_ecommerce/features/product/models/product.dart';

abstract class BaseOrderModel {
  final double totalAmount;
  final String? shippingAddressId;

  const BaseOrderModel({
    required this.totalAmount,
    this.shippingAddressId,
  });
}

class BuyNowOrderModel extends BaseOrderModel {
  final Product product;
  final int quantity;

  BuyNowOrderModel({
    required this.product,
    required this.quantity,
    required super.totalAmount,
    super.shippingAddressId,
  });

  BuyNowOrderModel copyWith(
      {Product? product, int? quantity, String? shippingAddressId}) {
    return BuyNowOrderModel(
      shippingAddressId: shippingAddressId ?? this.shippingAddressId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      totalAmount: totalAmount,
    );
  }
}

class CartOrderModel extends BaseOrderModel {
  final List<Cart> carts;

  CartOrderModel({
    required this.carts,
    required super.totalAmount,
    super.shippingAddressId,
  });

  CartOrderModel copyWith({List<Cart>? carts, String? shippingAddressId}) {
    return CartOrderModel(
        carts: carts ?? this.carts,
        totalAmount: totalAmount,
        shippingAddressId: shippingAddressId ?? this.shippingAddressId);
  }
}
