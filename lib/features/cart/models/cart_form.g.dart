// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartFormImpl _$$CartFormImplFromJson(Map<String, dynamic> json) =>
    _$CartFormImpl(
      productId: json['product_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$$CartFormImplToJson(_$CartFormImpl instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'quantity': instance.quantity,
    };
