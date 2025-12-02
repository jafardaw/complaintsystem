import 'package:compaintsystem/core/error/eror_handel.dart';
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/goverment_agencies/data/governmentagency_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class GovernmentAgenciesRepo {
  final ApiService _apiService;

  GovernmentAgenciesRepo(this._apiService);

  // 💡 الوظيفة الرئيسية لجلب الوكالات مع ترقيم الصفحات
  Future<AgenciesPaginationModel> getAgencies({int page = 1}) async {
    try {
      final response = await _apiService.get(
        'agencies',
        queryParameters: {'page': page}, // إرسال رقم الصفحة
      );

      return AgenciesPaginationModel.fromJson(response.data);
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

  Future<Response> createAgency(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('agencies', data);

      print("✅ Agency created successfully!");
      print("✅ Status Code: ${response.statusCode}");
      print("✅ Response Data: ${response.data}");

      return response; // إرجاع الـ Response
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException in createAgency: ${e.message}');
        print('❌ Status Code: ${e.response?.statusCode}');
        print('❌ Response Data: ${e.response?.data}');
      }
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('❌ General Exception in createAgency: $e');
      }
      rethrow;
    }
  }

  Future<Response> UpdateAgency(Map<String, dynamic> data, int id) async {
    try {
      final response = await _apiService.update('agencies/$id', data: data);

      print("✅ Agency created successfully!");
      print("✅ Status Code: ${response.statusCode}");
      print("✅ Response Data: ${response.data}");

      return response; // إرجاع الـ Response
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException in createAgency: ${e.message}');
      }
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('❌ General Exception in createAgency: $e');
      }
      rethrow;
    }
  }
}
