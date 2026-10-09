import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/features/cart/models/cart.dart';
import 'package:flutter_ecommerce/features/cart/repositories/cart_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_cart_event.dart';
part 'get_cart_state.dart';
part 'get_cart_bloc.freezed.dart';

class GetCartBloc extends Bloc<GetCartEvent, GetCartState> {
  final CartRepository _repo;
  List<Cart> _carts = [];

  GetCartBloc({required CartRepository repo})
      : _repo = repo,
        super(GetCartState.initial()) {
    on<GetCartEvent>((event, emit) async {
      await event.when(
        get: () async {
          emit(GetCartState.loading());
          final failureOrCarts = await _repo.getCart();
          failureOrCarts.fold(
            (failure) => emit(GetCartState.failure(failure)),
            (carts) {
              _carts = carts;
              _callLoadedState(emit, _carts);
            },
          );
        },
        updateCartQuantityLocally: (id, updatedQuantity) async =>
            _quantityCounterFunction(
          emit,
          id,
          updatedQuantity,
        ),
        changeSelection: (Cart currentCart) async {
          final List<Cart> carts = List.from(_carts);
          _carts = carts.map((cart) {
            if (cart.id == currentCart.id) {
              return currentCart.copyWith(isSelected: !currentCart.isSelected);
            }
            return cart;
          }).toList();
          _callLoadedState(emit, _carts);
        },
        selectAllCarts: () {
          final List<Cart> carts = List.from(_carts);
          _carts = carts.map((cart) {
            return cart.copyWith(isSelected: !_isSelectedAllCart());
          }).toList();
          _callLoadedState(emit, _carts);
        },
      );
    });
  }

  void _quantityCounterFunction(
      Emitter<GetCartState> emit, String id, int updatedQuantity) {
    final List<Cart> carts = List.from(_carts);
    _carts = carts.map((cart) {
      if (cart.id == id) {
        return cart.copyWith(quantity: updatedQuantity);
      }
      return cart;
    }).toList();
    _callLoadedState(emit, _carts);
  }

  List<Cart> _filterSelectedCartsForProcessing() {
    return _carts.where((cart) => cart.isSelected).toList();
  }

  bool _isSelectedAllCart() {
    return _carts.every((cart) => cart.isSelected);
  }

  double _getSubTotal() {
    double subTotal = 0;
    for (var cart in _carts) {
      if (cart.isSelected) {
        double currentPrice = cart.product.discountPrice ?? cart.product.price;
        subTotal += cart.quantity * currentPrice;
      }
    }
    return subTotal;
  }


  void _callLoadedState(Emitter<GetCartState> emit, List<Cart> carts) {
    emit(GetCartState.loaded(GetCartModel(
        subTotal: _getSubTotal(),
        carts: _carts,
        selectedCarts: _filterSelectedCartsForProcessing(),
        isAllCartSelected: _isSelectedAllCart())));
  }
}
