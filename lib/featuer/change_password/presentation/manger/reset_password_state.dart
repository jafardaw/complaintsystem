abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final String message; // لحمل رسالة النجاح
  ResetPasswordSuccess(this.message);
}

class ResetPasswordFailure extends ResetPasswordState {
  final String error; // لحمل رسالة الخطأ
  ResetPasswordFailure(this.error);
}
