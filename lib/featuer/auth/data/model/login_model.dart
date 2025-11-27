// lib/features/login/data/models/login_response_model.dart

import 'package:compaintsystem/featuer/auth/data/model/user_model.dart';

class LoginResponseModel {
  final String message;
  final String token; // التوكن أصبح إلزامياً وموجود في الجذر
  final UserModel user; // **جديد:** بيانات المستخدم كاملة

  LoginResponseModel({
    required this.message,
    required this.token,
    required this.user,
  });

  // Factory constructor لتحويل JSON إلى نموذج Dart
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    // الاستجابة الجديدة تضع كل شيء في الجذر
    return LoginResponseModel(
      message: json['message'] as String? ?? 'تم تسجيل الدخول بنجاح.',
      token: json['token'] as String,
      // تحويل خريطة المستخدم إلى نموذج UserModel
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
