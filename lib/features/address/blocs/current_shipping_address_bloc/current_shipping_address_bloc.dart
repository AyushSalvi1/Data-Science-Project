import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/features/address/models/address_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_shipping_address_event.dart';
part 'current_shipping_address_state.dart';
part 'current_shipping_address_bloc.freezed.dart';

class CurrentShippingAddressBloc
    extends Bloc<CurrentShippingAddressEvent, CurrentShippingAddressState> {
  Address? _address;
  CurrentShippingAddressBloc() : super(CurrentShippingAddressState.initial()) {
    on<CurrentShippingAddressEvent>((event, emit) {
      event.when(
        initializeShippingAddress: (address) {
          if (_address == null) {
            _address = address;
            emit(CurrentShippingAddressState.loaded(address));
          }
        },
        currentShipingAddress: (address) {
          _address = address;
          emit(CurrentShippingAddressState.loaded(address));
        },
      );
    });
  }
}
