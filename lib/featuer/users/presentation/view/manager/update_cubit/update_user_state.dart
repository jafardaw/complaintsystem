// update_user_state.dart
abstract class UpdateUserState {}

class UpdateUserInitial extends UpdateUserState {}

class UpdateUserLoading extends UpdateUserState {}

class UpdateUserSuccess extends UpdateUserState {
  final String message;
  UpdateUserSuccess(this.message);
}

class UpdateUserError extends UpdateUserState {
  final String message;
  UpdateUserError(this.message);
}
