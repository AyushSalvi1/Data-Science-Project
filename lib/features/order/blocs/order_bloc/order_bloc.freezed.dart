// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OrderEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CartOrderModel order) placeCartOrder,
    required TResult Function(BuyNowOrderModel order) buyNowOrder,
    required TResult Function(String orderId, String status) updateOrderStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CartOrderModel order)? placeCartOrder,
    TResult? Function(BuyNowOrderModel order)? buyNowOrder,
    TResult? Function(String orderId, String status)? updateOrderStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CartOrderModel order)? placeCartOrder,
    TResult Function(BuyNowOrderModel order)? buyNowOrder,
    TResult Function(String orderId, String status)? updateOrderStatus,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PlaceCartOrder value) placeCartOrder,
    required TResult Function(_BuyNowOrder value) buyNowOrder,
    required TResult Function(_UpdateOrderStatus value) updateOrderStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PlaceCartOrder value)? placeCartOrder,
    TResult? Function(_BuyNowOrder value)? buyNowOrder,
    TResult? Function(_UpdateOrderStatus value)? updateOrderStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PlaceCartOrder value)? placeCartOrder,
    TResult Function(_BuyNowOrder value)? buyNowOrder,
    TResult Function(_UpdateOrderStatus value)? updateOrderStatus,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderEventCopyWith<$Res> {
  factory $OrderEventCopyWith(
          OrderEvent value, $Res Function(OrderEvent) then) =
      _$OrderEventCopyWithImpl<$Res, OrderEvent>;
}

/// @nodoc
class _$OrderEventCopyWithImpl<$Res, $Val extends OrderEvent>
    implements $OrderEventCopyWith<$Res> {
  _$OrderEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PlaceCartOrderImplCopyWith<$Res> {
  factory _$$PlaceCartOrderImplCopyWith(_$PlaceCartOrderImpl value,
          $Res Function(_$PlaceCartOrderImpl) then) =
      __$$PlaceCartOrderImplCopyWithImpl<$Res>;
  @useResult
  $Res call({CartOrderModel order});
}

/// @nodoc
class __$$PlaceCartOrderImplCopyWithImpl<$Res>
    extends _$OrderEventCopyWithImpl<$Res, _$PlaceCartOrderImpl>
    implements _$$PlaceCartOrderImplCopyWith<$Res> {
  __$$PlaceCartOrderImplCopyWithImpl(
      _$PlaceCartOrderImpl _value, $Res Function(_$PlaceCartOrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = null,
  }) {
    return _then(_$PlaceCartOrderImpl(
      null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as CartOrderModel,
    ));
  }
}

/// @nodoc

class _$PlaceCartOrderImpl implements _PlaceCartOrder {
  const _$PlaceCartOrderImpl(this.order);

  @override
  final CartOrderModel order;

  @override
  String toString() {
    return 'OrderEvent.placeCartOrder(order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceCartOrderImpl &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode => Object.hash(runtimeType, order);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceCartOrderImplCopyWith<_$PlaceCartOrderImpl> get copyWith =>
      __$$PlaceCartOrderImplCopyWithImpl<_$PlaceCartOrderImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CartOrderModel order) placeCartOrder,
    required TResult Function(BuyNowOrderModel order) buyNowOrder,
    required TResult Function(String orderId, String status) updateOrderStatus,
  }) {
    return placeCartOrder(order);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CartOrderModel order)? placeCartOrder,
    TResult? Function(BuyNowOrderModel order)? buyNowOrder,
    TResult? Function(String orderId, String status)? updateOrderStatus,
  }) {
    return placeCartOrder?.call(order);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CartOrderModel order)? placeCartOrder,
    TResult Function(BuyNowOrderModel order)? buyNowOrder,
    TResult Function(String orderId, String status)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (placeCartOrder != null) {
      return placeCartOrder(order);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PlaceCartOrder value) placeCartOrder,
    required TResult Function(_BuyNowOrder value) buyNowOrder,
    required TResult Function(_UpdateOrderStatus value) updateOrderStatus,
  }) {
    return placeCartOrder(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PlaceCartOrder value)? placeCartOrder,
    TResult? Function(_BuyNowOrder value)? buyNowOrder,
    TResult? Function(_UpdateOrderStatus value)? updateOrderStatus,
  }) {
    return placeCartOrder?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PlaceCartOrder value)? placeCartOrder,
    TResult Function(_BuyNowOrder value)? buyNowOrder,
    TResult Function(_UpdateOrderStatus value)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (placeCartOrder != null) {
      return placeCartOrder(this);
    }
    return orElse();
  }
}

abstract class _PlaceCartOrder implements OrderEvent {
  const factory _PlaceCartOrder(final CartOrderModel order) =
      _$PlaceCartOrderImpl;

  CartOrderModel get order;

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaceCartOrderImplCopyWith<_$PlaceCartOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BuyNowOrderImplCopyWith<$Res> {
  factory _$$BuyNowOrderImplCopyWith(
          _$BuyNowOrderImpl value, $Res Function(_$BuyNowOrderImpl) then) =
      __$$BuyNowOrderImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BuyNowOrderModel order});
}

/// @nodoc
class __$$BuyNowOrderImplCopyWithImpl<$Res>
    extends _$OrderEventCopyWithImpl<$Res, _$BuyNowOrderImpl>
    implements _$$BuyNowOrderImplCopyWith<$Res> {
  __$$BuyNowOrderImplCopyWithImpl(
      _$BuyNowOrderImpl _value, $Res Function(_$BuyNowOrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = null,
  }) {
    return _then(_$BuyNowOrderImpl(
      null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as BuyNowOrderModel,
    ));
  }
}

/// @nodoc

class _$BuyNowOrderImpl implements _BuyNowOrder {
  const _$BuyNowOrderImpl(this.order);

  @override
  final BuyNowOrderModel order;

  @override
  String toString() {
    return 'OrderEvent.buyNowOrder(order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuyNowOrderImpl &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode => Object.hash(runtimeType, order);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BuyNowOrderImplCopyWith<_$BuyNowOrderImpl> get copyWith =>
      __$$BuyNowOrderImplCopyWithImpl<_$BuyNowOrderImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CartOrderModel order) placeCartOrder,
    required TResult Function(BuyNowOrderModel order) buyNowOrder,
    required TResult Function(String orderId, String status) updateOrderStatus,
  }) {
    return buyNowOrder(order);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CartOrderModel order)? placeCartOrder,
    TResult? Function(BuyNowOrderModel order)? buyNowOrder,
    TResult? Function(String orderId, String status)? updateOrderStatus,
  }) {
    return buyNowOrder?.call(order);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CartOrderModel order)? placeCartOrder,
    TResult Function(BuyNowOrderModel order)? buyNowOrder,
    TResult Function(String orderId, String status)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (buyNowOrder != null) {
      return buyNowOrder(order);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PlaceCartOrder value) placeCartOrder,
    required TResult Function(_BuyNowOrder value) buyNowOrder,
    required TResult Function(_UpdateOrderStatus value) updateOrderStatus,
  }) {
    return buyNowOrder(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PlaceCartOrder value)? placeCartOrder,
    TResult? Function(_BuyNowOrder value)? buyNowOrder,
    TResult? Function(_UpdateOrderStatus value)? updateOrderStatus,
  }) {
    return buyNowOrder?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PlaceCartOrder value)? placeCartOrder,
    TResult Function(_BuyNowOrder value)? buyNowOrder,
    TResult Function(_UpdateOrderStatus value)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (buyNowOrder != null) {
      return buyNowOrder(this);
    }
    return orElse();
  }
}

abstract class _BuyNowOrder implements OrderEvent {
  const factory _BuyNowOrder(final BuyNowOrderModel order) = _$BuyNowOrderImpl;

  BuyNowOrderModel get order;

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BuyNowOrderImplCopyWith<_$BuyNowOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateOrderStatusImplCopyWith<$Res> {
  factory _$$UpdateOrderStatusImplCopyWith(_$UpdateOrderStatusImpl value,
          $Res Function(_$UpdateOrderStatusImpl) then) =
      __$$UpdateOrderStatusImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String orderId, String status});
}

/// @nodoc
class __$$UpdateOrderStatusImplCopyWithImpl<$Res>
    extends _$OrderEventCopyWithImpl<$Res, _$UpdateOrderStatusImpl>
    implements _$$UpdateOrderStatusImplCopyWith<$Res> {
  __$$UpdateOrderStatusImplCopyWithImpl(_$UpdateOrderStatusImpl _value,
      $Res Function(_$UpdateOrderStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? status = null,
  }) {
    return _then(_$UpdateOrderStatusImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UpdateOrderStatusImpl implements _UpdateOrderStatus {
  const _$UpdateOrderStatusImpl({required this.orderId, required this.status});

  @override
  final String orderId;
  @override
  final String status;

  @override
  String toString() {
    return 'OrderEvent.updateOrderStatus(orderId: $orderId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateOrderStatusImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orderId, status);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateOrderStatusImplCopyWith<_$UpdateOrderStatusImpl> get copyWith =>
      __$$UpdateOrderStatusImplCopyWithImpl<_$UpdateOrderStatusImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CartOrderModel order) placeCartOrder,
    required TResult Function(BuyNowOrderModel order) buyNowOrder,
    required TResult Function(String orderId, String status) updateOrderStatus,
  }) {
    return updateOrderStatus(orderId, status);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CartOrderModel order)? placeCartOrder,
    TResult? Function(BuyNowOrderModel order)? buyNowOrder,
    TResult? Function(String orderId, String status)? updateOrderStatus,
  }) {
    return updateOrderStatus?.call(orderId, status);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CartOrderModel order)? placeCartOrder,
    TResult Function(BuyNowOrderModel order)? buyNowOrder,
    TResult Function(String orderId, String status)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (updateOrderStatus != null) {
      return updateOrderStatus(orderId, status);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PlaceCartOrder value) placeCartOrder,
    required TResult Function(_BuyNowOrder value) buyNowOrder,
    required TResult Function(_UpdateOrderStatus value) updateOrderStatus,
  }) {
    return updateOrderStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PlaceCartOrder value)? placeCartOrder,
    TResult? Function(_BuyNowOrder value)? buyNowOrder,
    TResult? Function(_UpdateOrderStatus value)? updateOrderStatus,
  }) {
    return updateOrderStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PlaceCartOrder value)? placeCartOrder,
    TResult Function(_BuyNowOrder value)? buyNowOrder,
    TResult Function(_UpdateOrderStatus value)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (updateOrderStatus != null) {
      return updateOrderStatus(this);
    }
    return orElse();
  }
}

abstract class _UpdateOrderStatus implements OrderEvent {
  const factory _UpdateOrderStatus(
      {required final String orderId,
      required final String status}) = _$UpdateOrderStatusImpl;

  String get orderId;
  String get status;

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateOrderStatusImplCopyWith<_$UpdateOrderStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
