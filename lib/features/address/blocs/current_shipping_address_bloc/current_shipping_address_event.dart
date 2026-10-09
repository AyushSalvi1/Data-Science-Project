part of 'current_shipping_address_bloc.dart';

@freezed
class CurrentShippingAddressEvent with _$CurrentShippingAddressEvent {
  const factory CurrentShippingAddressEvent.initializeShippingAddress(Address address) = _InitializeShippingAddress;
  const factory CurrentShippingAddressEvent.currentShipingAddress(Address address) = _CurrentShipingAddress;
}