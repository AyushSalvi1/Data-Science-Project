import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/features/cart/blocs/get_cart_bloc/get_cart_bloc.dart';
import 'package:flutter_ecommerce/features/cart/models/cart.dart';
import 'package:flutter_ecommerce/features/cart/models/cart_form.dart';
import 'package:flutter_ecommerce/features/cart/repositories/cart_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_event.dart';
part 'cart_state.dart';
part 'cart_bloc.freezed.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repo;
  final GetCartBloc _getCartBloc;
  CartBloc({required CartRepository repo, required GetCartBloc getCartBloc})
      : _repo = repo,
        _getCartBloc = getCartBloc,
        super(CartState.initial()) {
    on<CartEvent>((event, emit) async {
      await event.when(add: (cart) async {
        emit(CartState.loading());
        final failureOrSuccess = await _repo.addCart(cart);
        failureOrSuccess.fold((failure) => emit(CartState.failure(failure)),
            (success) {
          emit(CartState.loaded(success));
          _getCartBloc.add(GetCartEvent.get());
        });
      }, update: (id, updatedTotalQuantity) async {
        emit(CartState.loading());

        final failureOrSuccess = await _repo.updateCart(
            id: id, updatedTotalQuantity: updatedTotalQuantity);
        failureOrSuccess.fold((failure) => emit(CartState.failure(failure)),
            (success) {
          emit(CartState.loaded(success));
          _getCartBloc.add(
              GetCartEvent.updateCartQuantityLocally(id, updatedTotalQuantity));
        });
      }, deleteCarts: (List<Cart> carts) async {
        emit(CartState.loading());
        final failureOrSuccess = await _repo.deleteCarts(carts);
        failureOrSuccess.fold((failure) => emit(CartState.failure(failure)),
            (success) {
          emit(CartState.loaded(success));
          _getCartBloc.add(GetCartEvent.get());
        });
        
      });
    });
  }
}
