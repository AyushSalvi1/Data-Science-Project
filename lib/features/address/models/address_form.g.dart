// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressFormImpl _$$AddressFormImplFromJson(Map<String, dynamic> json) =>
    _$AddressFormImpl(
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zip_code'] as String?,
    );

Map<String, dynamic> _$$AddressFormImplToJson(_$AddressFormImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'zip_code': instance.zipCode,
    };
