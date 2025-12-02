// main.dart (التعديل المقترح)

import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/notification/presentation/manger/cubit/stor_fcm_cubit.dart';
import 'package:compaintsystem/featuer/notification/repo/notifacation_repo.dart';
import 'package:compaintsystem/featuer/splash_view.dart';
import 'package:compaintsystem/firebase_options.dart';
import 'package:compaintsystem/notifcation_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final ApiService apiService =
    ApiService(); // يجب تهيئتها بالطريقة الصحيحة (ربما تتطلب Dio)
final NotificationRepo notificationRepo = NotificationRepo(apiService);
final NotificationCubit notificationCubit = NotificationCubit(notificationRepo);

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await initializeLocalNotifications();

  // await setupNotifications(
  //   onTokenReceived: (fcmToken, deviceId) {
  //     notificationCubit.registerToken(fcmToken: fcmToken, deviceId: deviceId);
  //   },
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Complaint System',
      // 💡 ملاحظة: يجب توفير NotificationCubit هنا باستخدام BlocProvider إذا أردت متابعة حالته في الـ UI
      home: const SplashScreen(),
    );
  }
}
