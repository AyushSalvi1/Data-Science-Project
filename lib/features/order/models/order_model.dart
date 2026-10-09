import 'package:flutter_ecommerce/features/address/models/address_model.dart';
import 'package:flutter_ecommerce/features/order/models/order_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    @JsonKey(name: 'total_price') required double totalPrice,
    required String status,
    @JsonKey(name: 'payment_status') required String paymentStatus,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'shipping_address') Address? shippingAddress,
    @JsonKey(name: 'created_at') required String createdAt,
   @Default([]) @JsonKey(name: 'order_items')  List<OrderItem>? orderItems,
  }) = _Order;
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
