import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/features/address/blocs/current_shipping_address_bloc/current_shipping_address_bloc.dart';
import 'package:flutter_ecommerce/features/order/models/buy_now_and_cart_order_models.dart';
import 'package:flutter_ecommerce/features/order/repositories/order_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepo;
  final CurrentShippingAddressBloc _bloc;
  OrderBloc(
      {required OrderRepository repo, required CurrentShippingAddressBloc bloc})
      : _orderRepo = repo,
        _bloc = bloc,
        super(OrderState.initial()) {
    on<OrderEvent>((event, emit) async {
      await event.when(
        placeCartOrder: (order) => _placeCartOrder(order, emit),
        buyNowOrder: (order) => _buyNowOrder(order, emit),
        updateOrderStatus: (orderId, status) =>
            _updateOrderStatus(orderId, status, emit),
      );
    });
  }

  Future<void> _buyNowOrder(
      BuyNowOrderModel order, Emitter<OrderState> emit) async {
    emit(OrderState.loading());
    final failureOrOrder = await _orderRepo.createBuyNowOrder(
        order.copyWith(shippingAddressId: getShipingAddressId()));
    failureOrOrder.fold(
      (failure) => emit(OrderState.failure(failure)),
      (order) => emit(OrderState.loaded(order)),
    );
  }

  Future<void> _placeCartOrder(
      CartOrderModel order, Emitter<OrderState> emit) async {
    emit(OrderState.loading());
    final failureOrOrder = await _orderRepo.createCartOrder(
        order..copyWith(shippingAddressId: getShipingAddressId()));
    failureOrOrder.fold(
      (failure) => emit(OrderState.failure(failure)),
      (order) => emit(OrderState.loaded(order)),
    );
  }

  Future<void> _updateOrderStatus(
      String orderId, String status, Emitter<OrderState> emit) async {
    emit(OrderState.loading());
    final failureOrOrder =
        await _orderRepo.updateOrderStatus(orderId: orderId, status: status);
    failureOrOrder.fold(
      (failure) => emit(OrderState.failure(failure)),
      (_) => emit(OrderState.loaded("Order status updated successfully")),
    );
  }

  String getShipingAddressId() {
    return _bloc.state.maybeWhen(
        loaded: (address) => address.id,
        orElse: () {
          Logger().d("Shipping address not working orderlboc");
          throw "";
        });
  }
}
