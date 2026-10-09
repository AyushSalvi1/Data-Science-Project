part of 'get_cart_bloc.dart';

@freezed
class GetCartEvent with _$GetCartEvent {
  const factory GetCartEvent.get() = _Get;
  const factory GetCartEvent.changeSelection(Cart cart) = _ChangeSelection;
  const factory GetCartEvent.selectAllCarts() = _SelectAllCarts;

  const factory GetCartEvent.updateCartQuantityLocally(
      String id, int updatedQuantity) = _UpdateCartQuantityLocally;
}
