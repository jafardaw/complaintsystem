abstract class ChekEmailState {}

class ChekEmailInitial extends ChekEmailState {}

class ChekEmailLoading extends ChekEmailState {}

class ChekEmailSuccess extends ChekEmailState {
  final String massege;
  ChekEmailSuccess(this.massege);
}

class ChekEmailFailure extends ChekEmailState {
  final String error;
  ChekEmailFailure(this.error);
}
