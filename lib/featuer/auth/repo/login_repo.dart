import 'package:compaintsystem/core/error/eror_handel.dart';
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/auth/data/model/login_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepo {
  final ApiService _apiService;

  LoginRepo(this._apiService);

  Future<LoginResponseModel> login({
    required String usernameOrPhone,
    required String password,
  }) async {
    try {
      final response = await _apiService.post('auth/login', {
        "login": usernameOrPhone,
        "password": password,
      });

      final data = response.data;

      // **تم إزالة التحقق من data['status'] == "success"**
      // بما أن الاستجابة الناجحة هي دائماً 200 وتأتي بهذا التنسيق

      // 1. تحويل الـ JSON إلى النموذج الجديد
      final responseModel = LoginResponseModel.fromJson(data);

      // 2. حفظ التوكن (الآن هو حقل إلزامي)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseModel.token);

      // **يمكنك هنا أيضاً حفظ بيانات المستخدم (user) إذا لزم الأمر**
      await prefs.setInt('user_id', responseModel.user.id);

      // 3. إرجاع النموذج الذي يحتوي على الرسالة و بيانات المستخدم (user)
      return responseModel;
    } on DioException catch (e) {
      // ...
      if (kDebugMode) {
        print('DioException caught: ${e.message}');
      }
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      // ...
      if (kDebugMode) {
        print('General Exception caught: $e');
      }
      rethrow;
    }
  }

  Future<int> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post('auth/register', {
        "name": fullName,
        "email": email,
        "password": password,
      });

      final data = response.data;

      // **التعديل هنا:** التأكد من وجود user_id وكونه من نوع int
      // if (data != null && data.containsKey('id') && data['user_id'] is int) {
      //   // يمكنك طباعة رسالة النجاح في وضع التطوير للمراجعة
      //   if (kDebugMode) {
      //     print('Registration successful. Message: ${data['message']}');
      //   }
      //   // إرجاع user_id بدلاً من الرسالة
      return data['user_id'];
      // }

      // في حال كانت الاستجابة 200 لكن بدون user_id
      // throw Exception('فشل في العثور على User ID في استجابة التسجيل.');
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

  Future<LoginResponseModel> verifyEmail({
    required int userId,
    required String verificationCode,
  }) async {
    try {
      final response = await _apiService.post('auth/verify-otp', {
        "user_id": userId,
        "code": verificationCode,
      });

      final data = response.data;

      // if (data['data'] != null && data['data']['token'] != null) {
      //   final token = data['data']['token'];
      //   final prefs = await SharedPreferences.getInstance();
      //   await prefs.setString('token', token);
      // }
      final responseModel = LoginResponseModel.fromJson(data);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseModel.token);
      return responseModel;
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

  Future<String> resendCode({required int userId}) async {
    try {
      final response = await _apiService.post('auth/resend-otp-code', {
        "user_id": userId,
      });

      final data = response.data;

      if (data['status'] == "success") {
        return data['message'];
      } else {
        throw Exception(data['message'] ?? 'فشل في إعادة إرسال كود التحقق.');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught in ResendCodeRepo: ${e.message}');
      }
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught in ResendCodeRepo: $e');
      }
      rethrow;
    }
  }

  Future<String> logout() async {
    // 🔑 الخطوة الأولى والأهم: حذف التوكن محلياً على الفور
    // هذا يضمن خروج المستخدم فوراً من التطبيق حتى لو فشل طلب الـ API
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // إزالة أي بيانات مستخدم مخزنة أخرى إذا لزم الأمر
    // await prefs.remove('user_data');

    // إعداد رسالة افتراضية
    String resultMessage = 'تم تسجيل الخروج بنجاح.';

    try {
      // 2. محاولة إخبار الخادم بإنهاء الجلسة (لإبطال التوكن في قاعدة البيانات)
      final response = await _apiService.postwithOutData(
        'auth/logout',
      ); // استخدام دالة postwithOutData

      final data = response.data;

      // تحقق من الرد القياسي (إذا كان الخادم يرجع رسالة نجاح)
      if (data['status'] == "success" || data['message'] != null) {
        resultMessage = data['message'] ?? 'تم تسجيل الخروج من الخادم بنجاح.';
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught during logout: ${e.message}');
      }
      // لا نحتاج لرفع خطأ هنا! الأهم هو أننا حذفنا التوكن محلياً.
      // الـ 401 الذي أرسلته (غير مصرح بالدخول) يعني أن المستخدم غير مسجل، أو أن التوكن تم حذفه مسبقاً،
      // لذا لا يؤثر على نجاح عملية تسجيل الخروج من ناحية المستخدم.
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught during logout: $e');
      }
    }

    return resultMessage;
  }
}
