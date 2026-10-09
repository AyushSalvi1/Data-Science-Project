import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/features/auth/repositories/auth_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;
  AuthBloc({required AuthRepository repo})
      : _repo = repo,
        super(AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.when(
        signUp: (name, email, password) async {
          emit(AuthState.loading());
          final failureOrSuccess =
              await _repo.signUp(name: name, password: password, email: email);
          failureOrSuccess.fold((failure) => emit(AuthState.failure(failure)),
              (success) => emit(AuthState.loaded(success)));
        },
        signIn: (email, password) async {
          emit(AuthState.loading());
          final failureOrSuccess =
              await _repo.signIn(email: email, password: password);
          failureOrSuccess.fold((failure) => emit(AuthState.failure(failure)),
              (success) => emit(AuthState.loaded(success)));
        },
        signOut: () async {
          emit(AuthState.loading());
          final failureOrSuccess = await _repo.signOut();
          failureOrSuccess.fold((failure) => emit(AuthState.failure(failure)),
              (success) => emit(AuthState.loaded(success)));
        },
      );
    });
  }
}
