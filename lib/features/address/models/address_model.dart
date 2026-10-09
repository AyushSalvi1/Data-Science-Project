import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
class Address with _$Address {
  const Address._();
  const factory Address({
    required String id,
    required String address,
    required String city,
    required String state,
    @JsonKey(name: 'zip_code') required String? zipCode,
  }) = _Address;
  String get fullAddress => "$address, $city, $state, ${zipCode ?? ''}";
  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}
