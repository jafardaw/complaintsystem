import 'package:compaintsystem/featuer/users/data/user_admin_model.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersSuccess extends UsersState {
  final List<UserAdminModel> users;
  final bool hasMore; // هل توجد صفحات أخرى؟

  UsersSuccess(this.users, {this.hasMore = false});
}

class UsersError extends UsersState {
  final String message;
  UsersError(this.message);
}
