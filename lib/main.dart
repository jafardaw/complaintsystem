import 'package:compaintsystem/core/theme/app_theme.dart';
import 'package:compaintsystem/core/theme/manger/theme_cubit.dart';
import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/notification/presentation/manger/cubit/stor_fcm_cubit.dart';
import 'package:compaintsystem/featuer/notification/repo/notifacation_repo.dart';
import 'package:compaintsystem/featuer/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// لدعم اللغات والـ RTL
import 'package:flutter_localizations/flutter_localizations.dart';

// يمكنك إضافة Dio داخل ApiService لاحقًا إذا احتجت
final ApiService apiService = ApiService();
final NotificationRepo notificationRepo = NotificationRepo(apiService);
final NotificationCubit notificationCubit = NotificationCubit(notificationRepo);

void main() async {
  // في حال استخدام Firebase يجب تفعيل هذه الأسطر:
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await initializeLocalNotifications();

  // await setupNotifications(
  //   onTokenReceived: (fcmToken, deviceId) {
  //     notificationCubit.registerToken(
  //       fcmToken: fcmToken,
  //       deviceId: deviceId,
  //     );
  //   },
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            title: 'Complaint System',

            // اللغة الافتراضية العربية
            locale: const Locale('ar', 'SA'),

            // اللغات المدعومة
            supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],

            // دعم RTL وترجمة عناصر واجهة Flutter
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // يمكن لاحقاً وضع BlocProvider هنا إذا كنت تريد تمرير الـ Cubit
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
