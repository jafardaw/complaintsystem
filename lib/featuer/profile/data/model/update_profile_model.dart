import 'package:compaintsystem/featuer/auth/data/model/login_model.dart';

class ProfileUpdateResponseModel {
  final String message;
  final UserModel user;

  ProfileUpdateResponseModel({required this.message, required this.user});

  factory ProfileUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResponseModel(
      message: json['message'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
