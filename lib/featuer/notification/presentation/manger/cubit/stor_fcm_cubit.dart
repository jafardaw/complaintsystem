// lib/features/notifications/logic/notification_state.dart

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class RegisterTokenLoading extends NotificationState {}

class RegisterTokenSuccess extends NotificationState {
  final String message; // رسالة النجاح من الخادم

  RegisterTokenSuccess(this.message);
}

class RegisterTokenFailure extends NotificationState {
  final String error;

  RegisterTokenFailure(this.error);
}
