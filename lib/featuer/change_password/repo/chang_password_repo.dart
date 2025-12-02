import 'package:compaintsystem/core/error/eror_handel.dart';
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ChangPasswordRepo {
  final ApiService _apiService;

  ChangPasswordRepo(this._apiService);

  Future<int> chekEmail({required String usernameOrPhone}) async {
    try {
      final response = await _apiService.post('password/forgot', {
        "login": usernameOrPhone,
      });

      final data = response.data;

      return data['user_id'];
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught: ${e.message}');
      }
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught: $e');
      }
      rethrow; // إلقاء الخطأ مرة أخرى ليتم التعامل معه في Cubit
    }
  }

  Future<String> resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiService.post('auth/reset-password', {
        "contact": email,
        "code": code,
        "password": password,
        "password_confirmation": passwordConfirmation,
      });

      final data = response.data;

      if (data['status'] == "success") {
        return data['message'];
      } else {
        throw Exception(data['message'] ?? 'فشل في عملية التسجيل.');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught in RegisterRepo: ${e.message}');
      }
      throw ErrorHandler.handleDioError(e); // التعامل مع أخطاء Dio
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught in RegisterRepo: $e');
      }
      rethrow;
    }
  }
}
