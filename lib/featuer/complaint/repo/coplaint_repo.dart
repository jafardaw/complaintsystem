import 'package:compaintsystem/core/error/eror_handel.dart';
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/complaint/data/complaint_model.dart';
import 'package:compaintsystem/featuer/complaint/data/reversion_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ComplaintsRepo {
  final ApiService _apiService;

  ComplaintsRepo(this._apiService);

  Future<ComplaintRevisionsResponse> getRevisions(int complaintId) async {
    final response = await _apiService.get(
      'agency/complaints/$complaintId/revisions',
    );
    return ComplaintRevisionsResponse.fromJson(response.data);
  }

  // 💡 جلب قائمة الشكاوى مع دعم الترقيم
  Future<ComplaintsResponse> fetchComplaints({
    int page = 1,
    required int agencyid,
  }) async {
    try {
      // ⚠️ استخدام endpoint 'complaints' وإرسال رقم الصفحة كـ query parameter
      final response = await _apiService.get(
        'admin/agencies/$agencyid/complaints',
        queryParameters: {'page': page},
      );

      // التأكد من أن الرد يحتوي على حقل 'data'
      if (response.statusCode == 200 && response.data != null) {
        return ComplaintsResponse.fromJson(response.data);
      } else {
        throw Exception('فشل في جلب البيانات: حالة الرد غير متوقعة');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching complaints: $e');
      }
      // رمي الخطأ المُعالَج من الـ ApiService
      rethrow;
    }
  }

  // 💡 إرسال بيانات الشكوى الجديدة إلى API
  Future<Map<String, dynamic>> submitComplaint({
    required int agencyId,
    required String type,
    required String title,
    required String description,
    required String locationText,
    required String priority,
  }) async {
    final Map<String, dynamic> body = {
      "agency_id": agencyId,
      "type": type,
      "title": title,
      "description": description,
      "location_text": locationText,
      "priority": priority,
    };

    try {
      // ⚠️ استخدام endpoint 'complaints/new' لإنشاء شكوى
      final response = await _apiService.post('complaints', body);

      // التأكد من نجاح العملية (غالباً 201 Created)
      if (response.statusCode == 201) {
        // إرجاع البيانات المستلمة (غالباً ما تحتوي على reference_code)
        return response.data;
      } else {
        // رمي استثناء إذا كان هناك خطأ في التحقق من الصحة أو خطأ آخر
        String errorMessage =
            response.data['message'] ??
            'فشل الإرسال برمز: ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught in : ${e.message}');
      }
      throw ErrorHandler.handleDioError(e); // التعامل مع أخطاء Dio
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught in : $e');
      }
      rethrow;
    }
  }
}
