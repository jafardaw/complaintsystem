import 'package:compaintsystem/core/error/eror_handel.dart';

import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/auth/data/model/login_model.dart';
import 'package:compaintsystem/featuer/profile/data/model/update_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ProfileRepo {
  final ApiService _apiService;

  ProfileRepo(this._apiService);

  // جلب بيانات البروفايل
  Future<UserModel> getProfileData() async {
    try {
      // إرسال طلب GET لـ /api/auth/profile
      final response = await _apiService.get('auth/profile');

      final data = response.data['user'];

      final userModel = UserModel.fromJson(data);

      return userModel;
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  Future<ProfileUpdateResponseModel> updateProfile({
    required String name,
    required String phone,
  }) async {
    try {
      final response = await _apiService.update(
        'auth/profile',
        data: {"name": name, "phone": phone},
      );

      final data = response.data;

      // تحويل الرد إلى نموذج الاستجابة
      final responseModel = ProfileUpdateResponseModel.fromJson(data);

      // هنا يمكنك تحديث بيانات المستخدم المخزنة محلياً إذا لزم الأمر

      return responseModel;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught: ${e.message}');
      }
      // استخدام نفس معالج الأخطاء المتبع لديك
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught: $e');
      }
      rethrow;
    }
  }
}
