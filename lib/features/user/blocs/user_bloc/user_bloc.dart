import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/features/user/model/user.dart';
import 'package:flutter_ecommerce/features/user/repositories/user_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_bloc.freezed.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepo;
  UserModel? _currentUser;
  final List<UserModel> _fetchedUsers = [];

  UserBloc({required UserRepository userRepo})
      : _userRepo = userRepo,
        super(UserState.initial()) {
    on<UserEvent>(_onUserEvent);
  }

  Future<void> _onUserEvent(UserEvent event, Emitter<UserState> emit) async {
    await event.map(
      getCurrentUserData: (event) => _handleGetCurrentUserData(event, emit),
      getUserDataById: (event) => _handleGetUserDataById(event, emit),
    );
  }

  Future<void> _handleGetCurrentUserData(
    _GetCurrentUserData event,
    Emitter<UserState> emit,
  ) async {
    if (_currentUser != null) emit(UserState.loaded(_currentUser!));
    emit(UserState.loading());

    final failureOrUser = await _userRepo.getUserById();
    failureOrUser.fold(
      (failure) => emit(UserState.failure(failure)),
      (user) {
        _currentUser = user;
        emit(UserState.loaded(user));
      },
    );
  }

  Future<void> _handleGetUserDataById(
    _GetUserDataById event,
    Emitter<UserState> emit,
  ) async {
    final user =
        _fetchedUsers.firstWhereOrNull((element) => element.id == event.uid);
    if (user != null) emit(UserState.loaded(user));

    emit(UserState.loading());
    final failureOrUser = await _userRepo.getUserById(userId: event.uid);
    failureOrUser.fold(
      (failure) => emit(UserState.failure(failure)),
      (user) {
        _fetchedUsers.add(user);
        emit(UserState.loaded(user));
      },
    );
  }
}
