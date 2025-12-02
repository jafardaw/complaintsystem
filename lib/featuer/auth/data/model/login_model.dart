// lib/features/login/data/models/login_response_model.dart

class LoginResponseModel {
  final String message;
  final String token;
  final UserModel user;

  LoginResponseModel({
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'] as String? ?? 'Login successful.',
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'token': token, 'user': user.toJson()};
  }
}

class UserModel {
  final int id;
  final String name; // تغيير من fullName إلى name
  final String email;
  final String? phone; // جعله nullable
  final String password; // إضافة الحقل المفقود
  final String type; // إضافة الحقل المفقود
  final bool isActive; // تغيير من int إلى bool
  final String lastLoginAt; // إضافة الحقل المفقود
  final int failedLoginAttempts; // إضافة الحقل المفقود
  final String? lockedUntil; // إضافة الحقل المفقود
  final String createdAt; // إضافة الحقل المفقود
  final String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.password,
    required this.type,
    required this.isActive,
    required this.lastLoginAt,
    required this.failedLoginAttempts,
    this.lockedUntil,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String, // تغيير من full_name إلى name
      email: json['email'] as String,
      phone: json['phone'] as String?,
      password: json['password'] as String,
      type: json['type'] as String,
      isActive: json['is_active'] as bool, // تغيير من int إلى bool
      lastLoginAt: json['last_login_at'] as String,
      failedLoginAttempts: json['failed_login_attempts'] as int,
      lockedUntil: json['locked_until'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'type': type,
      'is_active': isActive,
      'last_login_at': lastLoginAt,
      'failed_login_attempts': failedLoginAttempts,
      'locked_until': lockedUntil,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
