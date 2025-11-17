// lib/features/login/data/models/login_response_model.dart

class LoginResponseModel {
  final String message;
  final bool hasProfile;
  final String?
  token; // (اختياري) يمكن إرجاع التوكن أو التعامل معه مباشرة في الريبو

  LoginResponseModel({
    required this.message,
    required this.hasProfile,
    this.token,
  });

  // Factory constructor لتحويل JSON إلى نموذج Dart
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    // التأكد من أن حقل "data" موجود للوصول إلى محتوياته
    final data = json['data'] as Map<String, dynamic>?;

    // استخدام 'message' مباشرة من الجذر (Root)
    final message = json['message'] as String? ?? 'تم تسجيل الدخول بنجاح.';

    // استخراج 'has_profile' و 'token' من حقل 'data'
    final hasProfile = data?['has_profile'] as bool? ?? false;
    final token = data?['token'] as String?;

    return LoginResponseModel(
      message: message,
      hasProfile: hasProfile,
      token: token,
    );
  }
}
