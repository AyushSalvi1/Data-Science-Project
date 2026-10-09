// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AddressForm _$AddressFormFromJson(Map<String, dynamic> json) {
  return _AddressForm.fromJson(json);
}

/// @nodoc
mixin _$AddressForm {
  String get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  @JsonKey(name: 'zip_code')
  String? get zipCode => throw _privateConstructorUsedError;

  /// Serializes this AddressForm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddressForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressFormCopyWith<AddressForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressFormCopyWith<$Res> {
  factory $AddressFormCopyWith(
          AddressForm value, $Res Function(AddressForm) then) =
      _$AddressFormCopyWithImpl<$Res, AddressForm>;
  @useResult
  $Res call(
      {String address,
      String city,
      String state,
      @JsonKey(name: 'zip_code') String? zipCode});
}

/// @nodoc
class _$AddressFormCopyWithImpl<$Res, $Val extends AddressForm>
    implements $AddressFormCopyWith<$Res> {
  _$AddressFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? city = null,
    Object? state = null,
    Object? zipCode = freezed,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: freezed == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddressFormImplCopyWith<$Res>
    implements $AddressFormCopyWith<$Res> {
  factory _$$AddressFormImplCopyWith(
          _$AddressFormImpl value, $Res Function(_$AddressFormImpl) then) =
      __$$AddressFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String address,
      String city,
      String state,
      @JsonKey(name: 'zip_code') String? zipCode});
}

/// @nodoc
class __$$AddressFormImplCopyWithImpl<$Res>
    extends _$AddressFormCopyWithImpl<$Res, _$AddressFormImpl>
    implements _$$AddressFormImplCopyWith<$Res> {
  __$$AddressFormImplCopyWithImpl(
      _$AddressFormImpl _value, $Res Function(_$AddressFormImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddressForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? city = null,
    Object? state = null,
    Object? zipCode = freezed,
  }) {
    return _then(_$AddressFormImpl(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: freezed == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressFormImpl implements _AddressForm {
  const _$AddressFormImpl(
      {required this.address,
      required this.city,
      required this.state,
      @JsonKey(name: 'zip_code') this.zipCode});

  factory _$AddressFormImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressFormImplFromJson(json);

  @override
  final String address;
  @override
  final String city;
  @override
  final String state;
  @override
  @JsonKey(name: 'zip_code')
  final String? zipCode;

  @override
  String toString() {
    return 'AddressForm(address: $address, city: $city, state: $state, zipCode: $zipCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressFormImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, address, city, state, zipCode);

  /// Create a copy of AddressForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressFormImplCopyWith<_$AddressFormImpl> get copyWith =>
      __$$AddressFormImplCopyWithImpl<_$AddressFormImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressFormImplToJson(
      this,
    );
  }
}

abstract class _AddressForm implements AddressForm {
  const factory _AddressForm(
      {required final String address,
      required final String city,
      required final String state,
      @JsonKey(name: 'zip_code') final String? zipCode}) = _$AddressFormImpl;

  factory _AddressForm.fromJson(Map<String, dynamic> json) =
      _$AddressFormImpl.fromJson;

  @override
  String get address;
  @override
  String get city;
  @override
  String get state;
  @override
  @JsonKey(name: 'zip_code')
  String? get zipCode;

  /// Create a copy of AddressForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressFormImplCopyWith<_$AddressFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
