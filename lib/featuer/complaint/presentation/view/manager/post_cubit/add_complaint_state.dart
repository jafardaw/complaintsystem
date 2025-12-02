abstract class NewComplaintState {}

class NewComplaintInitial extends NewComplaintState {}

class NewComplaintLoading extends NewComplaintState {}

class NewComplaintSuccess extends NewComplaintState {
  final String message;
  NewComplaintSuccess(this.message);
}

class NewComplaintError extends NewComplaintState {
  final String error;
  NewComplaintError(this.error);
}
