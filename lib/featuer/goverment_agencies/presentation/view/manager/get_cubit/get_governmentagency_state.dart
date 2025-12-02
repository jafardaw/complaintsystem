import 'package:compaintsystem/featuer/goverment_agencies/data/governmentagency_model.dart';

abstract class GovernmentAgenciesState {}

class GovernmentAgenciesInitial extends GovernmentAgenciesState {}

class GovernmentAgenciesLoading extends GovernmentAgenciesState {}

class GovernmentAgenciesSuccess extends GovernmentAgenciesState {
  final List<GovernmentAgency> agencies;
  final int currentPage;
  final int lastPage;

  GovernmentAgenciesSuccess({
    required this.agencies,
    required this.currentPage,
    required this.lastPage,
  });
}

class GovernmentAgenciesError extends GovernmentAgenciesState {
  final String error;
  GovernmentAgenciesError(this.error);
}
