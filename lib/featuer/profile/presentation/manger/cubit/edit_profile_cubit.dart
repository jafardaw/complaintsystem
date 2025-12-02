// lib/features/profile/logic/profile_state.dart

import 'package:compaintsystem/featuer/profile/data/model/update_profile_model.dart';

abstract class ProfileUpdatState {}

class ProfileUpdateInitial extends ProfileUpdatState {}

class UpdateProfileLoading extends ProfileUpdatState {}

class UpdateProfileSuccess extends ProfileUpdatState {
  final ProfileUpdateResponseModel responseModel;

  UpdateProfileSuccess(this.responseModel);
}

class UpdateProfileFailure extends ProfileUpdatState {
  final String error;

  UpdateProfileFailure(this.error);
}
