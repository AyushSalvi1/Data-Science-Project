import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/core/repositories/user_local_data_repository.dart';
import 'package:flutter_ecommerce/features/user/model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_local_data_event.dart';
part 'user_local_data_state.dart';
part 'user_local_data_bloc.freezed.dart';

class UserLocalDataBloc extends Bloc<UserLocalDataEvent, UserLocalDataState> {
  final UserLocalDataRepository _repo;

  UserLocalDataBloc({required UserLocalDataRepository repo})
      : _repo = repo,
        super(UserLocalDataState.initial()) {
    on<UserLocalDataEvent>((event, emit) async {
      await event.map(get: (_Get event) async {
        emit(UserLocalDataState.loading());
        final failureOrData = await _repo.getData();

        failureOrData.fold(
            (failure) => emit(UserLocalDataState.failure(failure)),
            (data) => emit(UserLocalDataState.loaded(data)));
      });
    });
  }
}
