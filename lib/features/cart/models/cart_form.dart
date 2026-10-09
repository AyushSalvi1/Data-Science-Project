import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_form.freezed.dart';
part 'cart_form.g.dart';

@freezed
class CartForm with _$CartForm {
  const factory CartForm({
    @JsonKey(name: "product_id") required String productId,
    required int quantity,
  }) = _CartForm;

  factory CartForm.fromJson(Map<String, dynamic> json) =>
      _$CartFormFromJson(json);
}
