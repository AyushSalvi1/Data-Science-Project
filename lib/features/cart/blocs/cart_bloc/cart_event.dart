part of 'cart_bloc.dart';

@freezed
class CartEvent with _$CartEvent {
  const factory CartEvent.add(CartForm cart) = _Add;
  const factory CartEvent.update(
      {required String id, required int updatedTotalQuantity}) = _Update;
  const factory CartEvent.deleteCarts(List<Cart> carts) = _DeleteCarts;
}
