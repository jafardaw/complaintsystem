// lib/features/notifications/data/repo/notification_repo.dart

import 'dart:io';
import 'package:compaintsystem/core/error/eror_handel.dart';
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/notification/data/model/notifications_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NotificationRepo {
  final ApiService _apiService;

  NotificationRepo(this._apiService);

  // ليس من الضروري إنشاء نموذج استجابة كامل، يمكن الاكتفاء بتحويل الـ JSON مباشرة إذا كان النموذج بسيطاً
  Future<String> registerFcmToken({
    required String fcmToken,
    required String deviceId,
  }) async {
    // تحديد نوع الجهاز تلقائياً
    final String deviceType = Platform.isAndroid ? 'android' : 'ios';

    try {
      final response = await _apiService.post('notifications/fcm-token', {
        "fcm_token": fcmToken,
        "device_type": deviceType,
        "device_id": deviceId,
      });

      // إرجاع رسالة النجاح
      return response.data['message'] as String;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught: ${e.message}');
      }
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught: $e');
      }
      rethrow;
    }
  }

  Future<NotificationsResponseModel> getNotifications({
    int page = 1, // افتراضياً الصفحة الأولى
  }) async {
    try {
      final response = await _apiService.get(
        'notifications',
        queryParameters: {'page': page}, // إرسال رقم الصفحة
      );

      final data = response.data;

      final responseModel = NotificationsResponseModel.fromJson(data);

      return responseModel;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught: ${e.message}');
      }
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught: $e');
      }
      rethrow;
    }
  }
}
