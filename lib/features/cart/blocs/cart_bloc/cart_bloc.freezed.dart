// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CartEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CartForm cart) add,
    required TResult Function(String id, int updatedTotalQuantity) update,
    required TResult Function(List<Cart> carts) deleteCarts,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CartForm cart)? add,
    TResult? Function(String id, int updatedTotalQuantity)? update,
    TResult? Function(List<Cart> carts)? deleteCarts,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CartForm cart)? add,
    TResult Function(String id, int updatedTotalQuantity)? update,
    TResult Function(List<Cart> carts)? deleteCarts,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Add value) add,
    required TResult Function(_Update value) update,
    required TResult Function(_DeleteCarts value) deleteCarts,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Add value)? add,
    TResult? Function(_Update value)? update,
    TResult? Function(_DeleteCarts value)? deleteCarts,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Add value)? add,
    TResult Function(_Update value)? update,
    TResult Function(_DeleteCarts value)? deleteCarts,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartEventCopyWith<$Res> {
  factory $CartEventCopyWith(CartEvent value, $Res Function(CartEvent) then) =
      _$CartEventCopyWithImpl<$Res, CartEvent>;
}

/// @nodoc
class _$CartEventCopyWithImpl<$Res, $Val extends CartEvent>
    implements $CartEventCopyWith<$Res> {
  _$CartEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AddImplCopyWith<$Res> {
  factory _$$AddImplCopyWith(_$AddImpl value, $Res Function(_$AddImpl) then) =
      __$$AddImplCopyWithImpl<$Res>;
  @useResult
  $Res call({CartForm cart});

  $CartFormCopyWith<$Res> get cart;
}

/// @nodoc
class __$$AddImplCopyWithImpl<$Res>
    extends _$CartEventCopyWithImpl<$Res, _$AddImpl>
    implements _$$AddImplCopyWith<$Res> {
  __$$AddImplCopyWithImpl(_$AddImpl _value, $Res Function(_$AddImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cart = null,
  }) {
    return _then(_$AddImpl(
      null == cart
          ? _value.cart
          : cart // ignore: cast_nullable_to_non_nullable
              as CartForm,
    ));
  }

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartFormCopyWith<$Res> get cart {
    return $CartFormCopyWith<$Res>(_value.cart, (value) {
      return _then(_value.copyWith(cart: value));
    });
  }
}

/// @nodoc

class _$AddImpl implements _Add {
  const _$AddImpl(this.cart);

  @override
  final CartForm cart;

  @override
  String toString() {
    return 'CartEvent.add(cart: $cart)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddImpl &&
            (identical(other.cart, cart) || other.cart == cart));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cart);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddImplCopyWith<_$AddImpl> get copyWith =>
      __$$AddImplCopyWithImpl<_$AddImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CartForm cart) add,
    required TResult Function(String id, int updatedTotalQuantity) update,
    required TResult Function(List<Cart> carts) deleteCarts,
  }) {
    return add(cart);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CartForm cart)? add,
    TResult? Function(String id, int updatedTotalQuantity)? update,
    TResult? Function(List<Cart> carts)? deleteCarts,
  }) {
    return add?.call(cart);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CartForm cart)? add,
    TResult Function(String id, int updatedTotalQuantity)? update,
    TResult Function(List<Cart> carts)? deleteCarts,
    required TResult orElse(),
  }) {
    if (add != null) {
      return add(cart);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Add value) add,
    required TResult Function(_Update value) update,
    required TResult Function(_DeleteCarts value) deleteCarts,
  }) {
    return add(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Add value)? add,
    TResult? Function(_Update value)? update,
    TResult? Function(_DeleteCarts value)? deleteCarts,
  }) {
    return add?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Add value)? add,
    TResult Function(_Update value)? update,
    TResult Function(_DeleteCarts value)? deleteCarts,
    required TResult orElse(),
  }) {
    if (add != null) {
      return add(this);
    }
    return orElse();
  }
}

abstract class _Add implements CartEvent {
  const factory _Add(final CartForm cart) = _$AddImpl;

  CartForm get cart;

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddImplCopyWith<_$AddImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateImplCopyWith<$Res> {
  factory _$$UpdateImplCopyWith(
          _$UpdateImpl value, $Res Function(_$UpdateImpl) then) =
      __$$UpdateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id, int updatedTotalQuantity});
}

/// @nodoc
class __$$UpdateImplCopyWithImpl<$Res>
    extends _$CartEventCopyWithImpl<$Res, _$UpdateImpl>
    implements _$$UpdateImplCopyWith<$Res> {
  __$$UpdateImplCopyWithImpl(
      _$UpdateImpl _value, $Res Function(_$UpdateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? updatedTotalQuantity = null,
  }) {
    return _then(_$UpdateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      updatedTotalQuantity: null == updatedTotalQuantity
          ? _value.updatedTotalQuantity
          : updatedTotalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$UpdateImpl implements _Update {
  const _$UpdateImpl({required this.id, required this.updatedTotalQuantity});

  @override
  final String id;
  @override
  final int updatedTotalQuantity;

  @override
  String toString() {
    return 'CartEvent.update(id: $id, updatedTotalQuantity: $updatedTotalQuantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.updatedTotalQuantity, updatedTotalQuantity) ||
                other.updatedTotalQuantity == updatedTotalQuantity));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, updatedTotalQuantity);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateImplCopyWith<_$UpdateImpl> get copyWith =>
      __$$UpdateImplCopyWithImpl<_$UpdateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CartForm cart) add,
    required TResult Function(String id, int updatedTotalQuantity) update,
    required TResult Function(List<Cart> carts) deleteCarts,
  }) {
    return update(id, updatedTotalQuantity);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CartForm cart)? add,
    TResult? Function(String id, int updatedTotalQuantity)? update,
    TResult? Function(List<Cart> carts)? deleteCarts,
  }) {
    return update?.call(id, updatedTotalQuantity);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CartForm cart)? add,
    TResult Function(String id, int updatedTotalQuantity)? update,
    TResult Function(List<Cart> carts)? deleteCarts,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(id, updatedTotalQuantity);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Add value) add,
    required TResult Function(_Update value) update,
    required TResult Function(_DeleteCarts value) deleteCarts,
  }) {
    return update(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Add value)? add,
    TResult? Function(_Update value)? update,
    TResult? Function(_DeleteCarts value)? deleteCarts,
  }) {
    return update?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Add value)? add,
    TResult Function(_Update value)? update,
    TResult Function(_DeleteCarts value)? deleteCarts,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(this);
    }
    return orElse();
  }
}

abstract class _Update implements CartEvent {
  const factory _Update(
      {required final String id,
      required final int updatedTotalQuantity}) = _$UpdateImpl;

  String get id;
  int get updatedTotalQuantity;

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateImplCopyWith<_$UpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteCartsImplCopyWith<$Res> {
  factory _$$DeleteCartsImplCopyWith(
          _$DeleteCartsImpl value, $Res Function(_$DeleteCartsImpl) then) =
      __$$DeleteCartsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Cart> carts});
}

/// @nodoc
class __$$DeleteCartsImplCopyWithImpl<$Res>
    extends _$CartEventCopyWithImpl<$Res, _$DeleteCartsImpl>
    implements _$$DeleteCartsImplCopyWith<$Res> {
  __$$DeleteCartsImplCopyWithImpl(
      _$DeleteCartsImpl _value, $Res Function(_$DeleteCartsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? carts = null,
  }) {
    return _then(_$DeleteCartsImpl(
      null == carts
          ? _value._carts
          : carts // ignore: cast_nullable_to_non_nullable
              as List<Cart>,
    ));
  }
}

/// @nodoc

class _$DeleteCartsImpl implements _DeleteCarts {
  const _$DeleteCartsImpl(final List<Cart> carts) : _carts = carts;

  final List<Cart> _carts;
  @override
  List<Cart> get carts {
    if (_carts is EqualUnmodifiableListView) return _carts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_carts);
  }

  @override
  String toString() {
    return 'CartEvent.deleteCarts(carts: $carts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteCartsImpl &&
            const DeepCollectionEquality().equals(other._carts, _carts));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_carts));

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteCartsImplCopyWith<_$DeleteCartsImpl> get copyWith =>
      __$$DeleteCartsImplCopyWithImpl<_$DeleteCartsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CartForm cart) add,
    required TResult Function(String id, int updatedTotalQuantity) update,
    required TResult Function(List<Cart> carts) deleteCarts,
  }) {
    return deleteCarts(carts);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CartForm cart)? add,
    TResult? Function(String id, int updatedTotalQuantity)? update,
    TResult? Function(List<Cart> carts)? deleteCarts,
  }) {
    return deleteCarts?.call(carts);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CartForm cart)? add,
    TResult Function(String id, int updatedTotalQuantity)? update,
    TResult Function(List<Cart> carts)? deleteCarts,
    required TResult orElse(),
  }) {
    if (deleteCarts != null) {
      return deleteCarts(carts);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Add value) add,
    required TResult Function(_Update value) update,
    required TResult Function(_DeleteCarts value) deleteCarts,
  }) {
    return deleteCarts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Add value)? add,
    TResult? Function(_Update value)? update,
    TResult? Function(_DeleteCarts value)? deleteCarts,
  }) {
    return deleteCarts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Add value)? add,
    TResult Function(_Update value)? update,
    TResult Function(_DeleteCarts value)? deleteCarts,
    required TResult orElse(),
  }) {
    if (deleteCarts != null) {
      return deleteCarts(this);
    }
    return orElse();
  }
}

abstract class _DeleteCarts implements CartEvent {
  const factory _DeleteCarts(final List<Cart> carts) = _$DeleteCartsImpl;

  List<Cart> get carts;

  /// Create a copy of CartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteCartsImplCopyWith<_$DeleteCartsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
