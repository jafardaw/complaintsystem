import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleLoginService {
  // يتم تهيئة GoogleSignIn مرة واحدة
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '640287297005-14kngatt2qt4c9ujod1lkhsgqtinacrf.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  // 💡 تم إزالة googleSignIn.signOut() من بداية الدالة،
  // لأن استخدامها يجعل المستخدم يرى شاشة اختيار الحساب في كل مرة،
  // وهذا غير مثالي لتجربة المستخدم.

  Future<Map<String, dynamic>?> loginWithGoogle() async {
    try {
      final ApiService apiService = ApiService();

      // 1. **التعديل الهام:** محاولة تسجيل الدخول الصامت أولاً (Silent Sign-In).
      // هذا هو الأسلوب الموصى به على الويب لتجنب التحذير وتحسين الأداء.
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();

      // 2. إذا لم يكن مسجلاً (لأنه يسجل لأول مرة أو انتهت الجلسة)، نطلب التسجيل بشكل صريح.
      googleUser ??= await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw Exception('فشل الحصول على رمز الهوية (ID token) من Google.');
      }

      // 3. إرسال الرمز للباك إند
      final response = await apiService.loginWithGoogle(googleAuth.idToken!);

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['data']['token']);

        // 4. إرجاع بيانات المستخدم
        return {
          'success': true,
          'token': response.data['data']['token'],
          'user': googleUser,
        };
      } else {
        throw Exception(
          'فشل تسجيل الدخول من الخادم (Backend): ${response.data['message']}',
        );
      }
    } catch (e) {
      // 💡 رسائل خطأ باللغة العربية
      String errorMessage = e.toString().contains('canceled')
          ? 'تم إلغاء عملية تسجيل الدخول من قِبَل المستخدم.'
          : 'حدث خطأ غير متوقع: يرجى المحاولة مرة أخرى.';

      return {'success': false, 'error': errorMessage};
    }
  }
}
