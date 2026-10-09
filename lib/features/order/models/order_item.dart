import 'package:flutter_ecommerce/features/product/models/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';
@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    @JsonKey(name: 'order_item_id') required String orderItemId,
    required int quantity,
    required Product product,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

