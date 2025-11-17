import 'package:aqaviatec/core/error/eror_handel.dart';
import 'package:aqaviatec/core/util/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ChangPasswordRepo {
  final ApiService _apiService;

  ChangPasswordRepo(this._apiService);

  Future<String> chekEmail({required String usernameOrPhone}) async {
    try {
      final response = await _apiService.post('checkEmail', {
        "email": usernameOrPhone,
      });

      final data = response.data;

      // تحقق من حالة الرد قبل التعامل مع البيانات
      if (data['status'] == "success") {
        // if (data['data']['token'] != null) {
        //   final prefs = await SharedPreferences.getInstance();
        //   await prefs.setString('token', data['data']['token']);
        // }
        return data['message'];
      } else {
        throw Exception(data['message'] ?? 'Failed to chek in.');
      }
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
    required String password,
    required String passwordConfirmation,
    required String code,
  }) async {
    try {
      final response = await _apiService.post('changePassword', {
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "code": code,
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
