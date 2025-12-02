// lib/features/profile/logic/profile_state.dart

import 'package:compaintsystem/featuer/auth/data/model/login_model.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

// لتمرير بيانات المستخدم
class ProfileSuccess extends ProfileState {
  final UserModel userModel;

  ProfileSuccess(this.userModel);
}

class ProfileFailure extends ProfileState {
  final String error;

  ProfileFailure(this.error);
}
