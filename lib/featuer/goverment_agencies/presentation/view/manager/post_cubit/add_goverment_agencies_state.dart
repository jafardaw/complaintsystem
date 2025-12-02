abstract class CreateGovernmentAgencyState {}

class CreateGovernmentAgencyInitial extends CreateGovernmentAgencyState {}

class CreateGovernmentAgencyLoading extends CreateGovernmentAgencyState {}

class CreateGovernmentAgencySuccess extends CreateGovernmentAgencyState {
  final String message;
  CreateGovernmentAgencySuccess(this.message);
}

class CreateGovernmentAgencyError extends CreateGovernmentAgencyState {
  final String error;
  CreateGovernmentAgencyError(this.error);
}

class UpdatementAgencyInitial extends CreateGovernmentAgencyState {}

class UpdatGovernmentAgencyLoading extends CreateGovernmentAgencyState {}

class UpdatGovernmentAgencySuccess extends CreateGovernmentAgencyState {
  final String message;
  UpdatGovernmentAgencySuccess(this.message);
}

class UpdatGovernmentAgencyError extends CreateGovernmentAgencyState {
  final String error;
  UpdatGovernmentAgencyError(this.error);
}
