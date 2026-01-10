// State
import 'package:compaintsystem/featuer/complaint/data/reversion_model.dart';

abstract class RevisionsState {}

class RevisionsInitial extends RevisionsState {}

class RevisionsLoading extends RevisionsState {}

class RevisionsSuccess extends RevisionsState {
  final ComplaintRevisionsResponse data;
  RevisionsSuccess(this.data);
}

class RevisionsError extends RevisionsState {
  final String message;
  RevisionsError(this.message);
}
