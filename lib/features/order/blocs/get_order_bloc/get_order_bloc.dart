import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/features/order/models/order_model.dart';
import 'package:flutter_ecommerce/features/order/repositories/order_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_order_event.dart';
part 'get_order_state.dart';
part 'get_order_bloc.freezed.dart';

class GetOrderBloc extends Bloc<GetOrderEvent, GetOrderState> {
  final OrderRepository _orderRepository;

  GetOrderBloc({required OrderRepository repo})
      : _orderRepository = repo,
        super(GetOrderState.initial()) {
    on<GetOrderEvent>((event, emit) async {
      await event.when(get: () async {
        emit(GetOrderState.loading());
        final failureOrOrders = await _orderRepository.getUserOrders();
        emit(failureOrOrders.fold(
          (failure) => GetOrderState.failure(failure),
          (orders) => GetOrderState.loaded(orders),
        ));
      });
    });
  }
}
