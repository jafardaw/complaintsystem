abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message; // لحمل رسالة النجاح
  final int userId; // لحمل معرف المستخدم

  RegisterSuccess(this.message, this.userId);
}

class RegisterFailure extends RegisterState {
  final String error; // لحمل رسالة الخطأ
  RegisterFailure(this.error);
}
