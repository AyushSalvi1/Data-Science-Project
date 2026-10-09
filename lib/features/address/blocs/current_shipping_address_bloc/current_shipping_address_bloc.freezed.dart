// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'current_shipping_address_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CurrentShippingAddressEvent {
  Address get address => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Address address) initializeShippingAddress,
    required TResult Function(Address address) currentShipingAddress,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Address address)? initializeShippingAddress,
    TResult? Function(Address address)? currentShipingAddress,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Address address)? initializeShippingAddress,
    TResult Function(Address address)? currentShipingAddress,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitializeShippingAddress value)
        initializeShippingAddress,
    required TResult Function(_CurrentShipingAddress value)
        currentShipingAddress,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitializeShippingAddress value)?
        initializeShippingAddress,
    TResult? Function(_CurrentShipingAddress value)? currentShipingAddress,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitializeShippingAddress value)?
        initializeShippingAddress,
    TResult Function(_CurrentShipingAddress value)? currentShipingAddress,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of CurrentShippingAddressEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrentShippingAddressEventCopyWith<CurrentShippingAddressEvent>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentShippingAddressEventCopyWith<$Res> {
  factory $CurrentShippingAddressEventCopyWith(
          CurrentShippingAddressEvent value,
          $Res Function(CurrentShippingAddressEvent) then) =
      _$CurrentShippingAddressEventCopyWithImpl<$Res,
          CurrentShippingAddressEvent>;
  @useResult
  $Res call({Address address});

  $AddressCopyWith<$Res> get address;
}

/// @nodoc
class _$CurrentShippingAddressEventCopyWithImpl<$Res,
        $Val extends CurrentShippingAddressEvent>
    implements $CurrentShippingAddressEventCopyWith<$Res> {
  _$CurrentShippingAddressEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrentShippingAddressEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as Address,
    ) as $Val);
  }

  /// Create a copy of CurrentShippingAddressEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressCopyWith<$Res> get address {
    return $AddressCopyWith<$Res>(_value.address, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InitializeShippingAddressImplCopyWith<$Res>
    implements $CurrentShippingAddressEventCopyWith<$Res> {
  factory _$$InitializeShippingAddressImplCopyWith(
          _$InitializeShippingAddressImpl value,
          $Res Function(_$InitializeShippingAddressImpl) then) =
      __$$InitializeShippingAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Address address});

  @override
  $AddressCopyWith<$Res> get address;
}

/// @nodoc
class __$$InitializeShippingAddressImplCopyWithImpl<$Res>
    extends _$CurrentShippingAddressEventCopyWithImpl<$Res,
        _$InitializeShippingAddressImpl>
    implements _$$InitializeShippingAddressImplCopyWith<$Res> {
  __$$InitializeShippingAddressImplCopyWithImpl(
      _$InitializeShippingAddressImpl _value,
      $Res Function(_$InitializeShippingAddressImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrentShippingAddressEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
  }) {
    return _then(_$InitializeShippingAddressImpl(
      null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as Address,
    ));
  }
}

/// @nodoc

class _$InitializeShippingAddressImpl implements _InitializeShippingAddress {
  const _$InitializeShippingAddressImpl(this.address);

  @override
  final Address address;

  @override
  String toString() {
    return 'CurrentShippingAddressEvent.initializeShippingAddress(address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitializeShippingAddressImpl &&
            (identical(other.address, address) || other.address == address));
  }

  @override
  int get hashCode => Object.hash(runtimeType, address);

  /// Create a copy of CurrentShippingAddressEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitializeShippingAddressImplCopyWith<_$InitializeShippingAddressImpl>
      get copyWith => __$$InitializeShippingAddressImplCopyWithImpl<
          _$InitializeShippingAddressImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Address address) initializeShippingAddress,
    required TResult Function(Address address) currentShipingAddress,
  }) {
    return initializeShippingAddress(address);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Address address)? initializeShippingAddress,
    TResult? Function(Address address)? currentShipingAddress,
  }) {
    return initializeShippingAddress?.call(address);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Address address)? initializeShippingAddress,
    TResult Function(Address address)? currentShipingAddress,
    required TResult orElse(),
  }) {
    if (initializeShippingAddress != null) {
      return initializeShippingAddress(address);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitializeShippingAddress value)
        initializeShippingAddress,
    required TResult Function(_CurrentShipingAddress value)
        currentShipingAddress,
  }) {
    return initializeShippingAddress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitializeShippingAddress value)?
        initializeShippingAddress,
    TResult? Function(_CurrentShipingAddress value)? currentShipingAddress,
  }) {
    return initializeShippingAddress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitializeShippingAddress value)?
        initializeShippingAddress,
    TResult Function(_CurrentShipingAddress value)? currentShipingAddress,
    required TResult orElse(),
  }) {
    if (initializeShippingAddress != null) {
      return initializeShippingAddress(this);
    }
    return orElse();
  }
}

abstract class _InitializeShippingAddress
    implements CurrentShippingAddressEvent {
  const factory _InitializeShippingAddress(final Address address) =
      _$InitializeShippingAddressImpl;

  @override
  Address get address;

  /// Create a copy of CurrentShippingAddressEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitializeShippingAddressImplCopyWith<_$InitializeShippingAddressImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CurrentShipingAddressImplCopyWith<$Res>
    implements $CurrentShippingAddressEventCopyWith<$Res> {
  factory _$$CurrentShipingAddressImplCopyWith(
          _$CurrentShipingAddressImpl value,
          $Res Function(_$CurrentShipingAddressImpl) then) =
      __$$CurrentShipingAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Address address});

  @override
  $AddressCopyWith<$Res> get address;
}

/// @nodoc
class __$$CurrentShipingAddressImplCopyWithImpl<$Res>
    extends _$CurrentShippingAddressEventCopyWithImpl<$Res,
        _$CurrentShipingAddressImpl>
    implements _$$CurrentShipingAddressImplCopyWith<$Res> {
  __$$CurrentShipingAddressImplCopyWithImpl(_$CurrentShipingAddressImpl _value,
      $Res Function(_$CurrentShipingAddressImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrentShippingAddressEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
  }) {
    return _then(_$CurrentShipingAddressImpl(
      null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as Address,
    ));
  }
}

/// @nodoc

class _$CurrentShipingAddressImpl implements _CurrentShipingAddress {
  const _$CurrentShipingAddressImpl(this.address);

  @override
  final Address address;

  @override
  String toString() {
    return 'CurrentShippingAddressEvent.currentShipingAddress(address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentShipingAddressImpl &&
            (identical(other.address, address) || other.address == address));
  }

  @override
  int get hashCode => Object.hash(runtimeType, address);

  /// Create a copy of CurrentShippingAddressEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentShipingAddressImplCopyWith<_$CurrentShipingAddressImpl>
      get copyWith => __$$CurrentShipingAddressImplCopyWithImpl<
          _$CurrentShipingAddressImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Address address) initializeShippingAddress,
    required TResult Function(Address address) currentShipingAddress,
  }) {
    return currentShipingAddress(address);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Address address)? initializeShippingAddress,
    TResult? Function(Address address)? currentShipingAddress,
  }) {
    return currentShipingAddress?.call(address);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Address address)? initializeShippingAddress,
    TResult Function(Address address)? currentShipingAddress,
    required TResult orElse(),
  }) {
    if (currentShipingAddress != null) {
      return currentShipingAddress(address);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitializeShippingAddress value)
        initializeShippingAddress,
    required TResult Function(_CurrentShipingAddress value)
        currentShipingAddress,
  }) {
    return currentShipingAddress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitializeShippingAddress value)?
        initializeShippingAddress,
    TResult? Function(_CurrentShipingAddress value)? currentShipingAddress,
  }) {
    return currentShipingAddress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitializeShippingAddress value)?
        initializeShippingAddress,
    TResult Function(_CurrentShipingAddress value)? currentShipingAddress,
    required TResult orElse(),
  }) {
    if (currentShipingAddress != null) {
      return currentShipingAddress(this);
    }
    return orElse();
  }
}

abstract class _CurrentShipingAddress implements CurrentShippingAddressEvent {
  const factory _CurrentShipingAddress(final Address address) =
      _$CurrentShipingAddressImpl;

  @override
  Address get address;

  /// Create a copy of CurrentShippingAddressEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrentShipingAddressImplCopyWith<_$CurrentShipingAddressImpl>
      get copyWith => throw _privateConstructorUsedError;
}
