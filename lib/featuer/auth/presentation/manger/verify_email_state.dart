abstract class VerifyEmailState {}

class VerifyEmailInitial extends VerifyEmailState {}

class VerifyEmailLoading extends VerifyEmailState {}

class VerifyEmailSuccess extends VerifyEmailState {
  final String message;
  VerifyEmailSuccess(this.message);
}

class VerifyEmailFailure extends VerifyEmailState {
  final String error;
  VerifyEmailFailure(this.error);
}
