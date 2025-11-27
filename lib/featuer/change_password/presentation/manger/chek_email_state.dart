abstract class ChekEmailState {}

class ChekEmailInitial extends ChekEmailState {}

class ChekEmailLoading extends ChekEmailState {}

class ChekEmailSuccess extends ChekEmailState {
  final int userId;
  ChekEmailSuccess(this.userId);
}

class ChekEmailFailure extends ChekEmailState {
  final String error;
  ChekEmailFailure(this.error);
}
