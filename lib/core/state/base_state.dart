import 'package:flutter_ecommerce/core/failure/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_state.freezed.dart';

@freezed
class BaseState<T> with _$BaseState<T> {
  const factory BaseState.initial() = _Initial<T>;
  const factory BaseState.loading() = _Loading<T>;
  const factory BaseState.loaded(T data) = _Loaded<T>;
  const factory BaseState.failure(Failure failure) = _Failure<T>;
}
