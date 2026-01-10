// lib/repositories/stats_repository.dart

import 'package:compaintsystem/core/error/eror_handel.dart';
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/Report/data/statistics_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class StatsRepository {
  final ApiService apiserve;

  StatsRepository(this.apiserve);

  Future<ComplaintStats> fetchComplaintStats() async {
    try {
      // تأكد من تعديل المسار ليناسب endpoint الخاص بك
      final response = await apiserve.get('statistics/overall');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return ComplaintStats.fromJson(data['data']);
        }
      }
      throw Exception('Failed to fetch complaint stats');
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught in VerifyEmailRepo: ${e.message}');
      }
      throw ErrorHandler.handleDioError(e); // التعامل مع أخطاء Dio
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught in VerifyEmailRepo: $e');
      }
      rethrow;
    }
  }
}
