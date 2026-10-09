part of 'user_bloc.dart';

@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.getCurrentUserData() = _GetCurrentUserData;
  const factory UserEvent.getUserDataById({required String uid}) =
      _GetUserDataById;
}
