import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/features/order/models/order_model.dart';
import 'package:flutter_ecommerce/features/order/repositories/order_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_vendor_order_event.dart';
part 'get_vendor_order_state.dart';
part 'get_vendor_order_bloc.freezed.dart';

class GetVendorOrderBloc
    extends Bloc<GetVendorOrderEvent, GetVendorOrderState> {
  final OrderRepository _orderRepository;
  GetVendorOrderBloc({required OrderRepository repo})
      : _orderRepository = repo,
        super(const GetVendorOrderState.initial()) {
    on<GetVendorOrderEvent>((event, emit) async {
      await event.map(
        get: (event) async {
          emit(const GetVendorOrderState.loading());
          final result = await _orderRepository.getVendorOrders();
          emit(result.fold(
            (failure) => GetVendorOrderState.failure(failure),
            (orders) => GetVendorOrderState.loaded(orders),
          ));
        },
      );
    });
  }
}
