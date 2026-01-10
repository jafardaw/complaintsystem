import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/users/data/user_admin_model.dart';

class UsersRepository {
  final ApiService _apiService;
  UsersRepository(this._apiService);

  Future<UserPaginationModel> getAllUsers({int page = 1}) async {
    // نرسل رقم الصفحة في الـ query parameters
    final response = await _apiService.get(
      'admin/users',
      queryParameters: {'page': page},
    );
    return UserPaginationModel.fromJson(response.data);
  }

  // داخل ملف user_repo.dart
  Future<void> updateUser(int id, Map<String, dynamic> userData) async {
    // المسار: admin/users/{id}
    await _apiService.update('admin/users/$id', data: userData);
  }

  Future<void> addUser({
    required int agencyId,
    required Map<String, dynamic> userData,
  }) async {
    // استخدام الـ post الموجود في الـ ApiService الخاص بك
    await _apiService.post('agencies/$agencyId/users', userData);
  }
}
