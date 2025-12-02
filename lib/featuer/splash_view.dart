import 'dart:async';
import 'package:compaintsystem/core/utils/assetimage.dart';
import 'package:compaintsystem/featuer/auth/presentation/view/login_view.dart';
import 'package:compaintsystem/featuer/auth/presentation/view/register_view.dart';
import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// شاشة البداية المعدلة (SplashScreen)
// -----------------------------------------------------------------------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    // 1. بدء تأثير التلاشي للوغو فوراً بعد بناء الإطار
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });

    // 2. تعيين مؤقت للانتقال إلى الشاشة الرئيسية بعد 3 ثوانٍ
    _navigationTimer = Timer(const Duration(seconds: 3), _navigateToNextScreen);
  }

  void _navigateToNextScreen() {
    // 💡 قم باستبدال هذا الجزء بمنطق التحقق من حالة المستخدم والانتقال الصحيح
    // (مثلاً: التحقق من تسجيل الدخول والانتقال إما للصفحة الرئيسية أو شاشة الدخول)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  @override
  void dispose() {
    // ⚠️ إلغاء المؤقت لمنع أي تسريبات في الذاكرة
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // استخدام صورة خلفية ثابتة
          image: DecorationImage(
            // افتراض وجود الصورة، يرجى التأكد من إضافة المسار الصحيح
            image: AssetImage(Assets.assetsImagesPhoto20250924164616),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // اللوغو مع AnimatedOpacity
              AnimatedOpacity(
                curve: Curves.easeIn,
                opacity: _opacity,
                duration: const Duration(seconds: 1),
                child: Image.asset(
                  // افتراض وجود الصورة، يرجى التأكد من إضافة المسار الصحيح
                  Assets.assetsImagesPhoto20250924144805RemovebgPreview,
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                  // لون احتياطي في حال عدم تحميل الصورة
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.error_outline,
                    size: 250,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'نظام الشكاوى',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
