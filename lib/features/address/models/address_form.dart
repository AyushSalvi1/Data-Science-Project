import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_form.freezed.dart';
part 'address_form.g.dart';

@freezed
class AddressForm with _$AddressForm {
  const factory AddressForm({
    required String address,
    required String city,
    required String state,
    @JsonKey(name: 'zip_code') String? zipCode,
  }) = _AddressForm;

  factory AddressForm.fromJson(Map<String, dynamic> json) =>
      _$AddressFormFromJson(json);
}
