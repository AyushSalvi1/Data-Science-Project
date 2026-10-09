// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getCurrentUserData,
    required TResult Function(String uid) getUserDataById,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getCurrentUserData,
    TResult? Function(String uid)? getUserDataById,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getCurrentUserData,
    TResult Function(String uid)? getUserDataById,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetCurrentUserData value) getCurrentUserData,
    required TResult Function(_GetUserDataById value) getUserDataById,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetCurrentUserData value)? getCurrentUserData,
    TResult? Function(_GetUserDataById value)? getUserDataById,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetCurrentUserData value)? getCurrentUserData,
    TResult Function(_GetUserDataById value)? getUserDataById,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserEventCopyWith<$Res> {
  factory $UserEventCopyWith(UserEvent value, $Res Function(UserEvent) then) =
      _$UserEventCopyWithImpl<$Res, UserEvent>;
}

/// @nodoc
class _$UserEventCopyWithImpl<$Res, $Val extends UserEvent>
    implements $UserEventCopyWith<$Res> {
  _$UserEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GetCurrentUserDataImplCopyWith<$Res> {
  factory _$$GetCurrentUserDataImplCopyWith(_$GetCurrentUserDataImpl value,
          $Res Function(_$GetCurrentUserDataImpl) then) =
      __$$GetCurrentUserDataImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GetCurrentUserDataImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$GetCurrentUserDataImpl>
    implements _$$GetCurrentUserDataImplCopyWith<$Res> {
  __$$GetCurrentUserDataImplCopyWithImpl(_$GetCurrentUserDataImpl _value,
      $Res Function(_$GetCurrentUserDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GetCurrentUserDataImpl implements _GetCurrentUserData {
  const _$GetCurrentUserDataImpl();

  @override
  String toString() {
    return 'UserEvent.getCurrentUserData()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GetCurrentUserDataImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getCurrentUserData,
    required TResult Function(String uid) getUserDataById,
  }) {
    return getCurrentUserData();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getCurrentUserData,
    TResult? Function(String uid)? getUserDataById,
  }) {
    return getCurrentUserData?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getCurrentUserData,
    TResult Function(String uid)? getUserDataById,
    required TResult orElse(),
  }) {
    if (getCurrentUserData != null) {
      return getCurrentUserData();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetCurrentUserData value) getCurrentUserData,
    required TResult Function(_GetUserDataById value) getUserDataById,
  }) {
    return getCurrentUserData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetCurrentUserData value)? getCurrentUserData,
    TResult? Function(_GetUserDataById value)? getUserDataById,
  }) {
    return getCurrentUserData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetCurrentUserData value)? getCurrentUserData,
    TResult Function(_GetUserDataById value)? getUserDataById,
    required TResult orElse(),
  }) {
    if (getCurrentUserData != null) {
      return getCurrentUserData(this);
    }
    return orElse();
  }
}

abstract class _GetCurrentUserData implements UserEvent {
  const factory _GetCurrentUserData() = _$GetCurrentUserDataImpl;
}

/// @nodoc
abstract class _$$GetUserDataByIdImplCopyWith<$Res> {
  factory _$$GetUserDataByIdImplCopyWith(_$GetUserDataByIdImpl value,
          $Res Function(_$GetUserDataByIdImpl) then) =
      __$$GetUserDataByIdImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String uid});
}

/// @nodoc
class __$$GetUserDataByIdImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$GetUserDataByIdImpl>
    implements _$$GetUserDataByIdImplCopyWith<$Res> {
  __$$GetUserDataByIdImplCopyWithImpl(
      _$GetUserDataByIdImpl _value, $Res Function(_$GetUserDataByIdImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
  }) {
    return _then(_$GetUserDataByIdImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GetUserDataByIdImpl implements _GetUserDataById {
  const _$GetUserDataByIdImpl({required this.uid});

  @override
  final String uid;

  @override
  String toString() {
    return 'UserEvent.getUserDataById(uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserDataByIdImpl &&
            (identical(other.uid, uid) || other.uid == uid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uid);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserDataByIdImplCopyWith<_$GetUserDataByIdImpl> get copyWith =>
      __$$GetUserDataByIdImplCopyWithImpl<_$GetUserDataByIdImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getCurrentUserData,
    required TResult Function(String uid) getUserDataById,
  }) {
    return getUserDataById(uid);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getCurrentUserData,
    TResult? Function(String uid)? getUserDataById,
  }) {
    return getUserDataById?.call(uid);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getCurrentUserData,
    TResult Function(String uid)? getUserDataById,
    required TResult orElse(),
  }) {
    if (getUserDataById != null) {
      return getUserDataById(uid);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetCurrentUserData value) getCurrentUserData,
    required TResult Function(_GetUserDataById value) getUserDataById,
  }) {
    return getUserDataById(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetCurrentUserData value)? getCurrentUserData,
    TResult? Function(_GetUserDataById value)? getUserDataById,
  }) {
    return getUserDataById?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetCurrentUserData value)? getCurrentUserData,
    TResult Function(_GetUserDataById value)? getUserDataById,
    required TResult orElse(),
  }) {
    if (getUserDataById != null) {
      return getUserDataById(this);
    }
    return orElse();
  }
}

abstract class _GetUserDataById implements UserEvent {
  const factory _GetUserDataById({required final String uid}) =
      _$GetUserDataByIdImpl;

  String get uid;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetUserDataByIdImplCopyWith<_$GetUserDataByIdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
