import 'package:compaintsystem/featuer/auth/data/model/login_model.dart';

abstract class VerifyEmailState {}

class VerifyEmailInitial extends VerifyEmailState {}

class VerifyEmailLoading extends VerifyEmailState {}

class VerifyEmailSuccess extends VerifyEmailState {
  final LoginResponseModel responseModel;
  VerifyEmailSuccess(this.responseModel);
}

class VerifyEmailFailure extends VerifyEmailState {
  final String error;
  VerifyEmailFailure(this.error);
}
