// lib/core/notifications/fcm_service.dart (ملف مقترح)

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart'; // تمت الإضافة

// تعريف وإعداد مكتبة الإشعارات المحلية
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// -------------------------------------------------------------------
// 1. معالج رسائل الخلفية (Background Handler)
// -------------------------------------------------------------------

// يجب أن تكون هذه الدالة (Top-level function) خارج أي فئة
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // يجب تهيئة Firebase هنا مجدداً لمعالجة رسائل الخلفية المعزولة
  await Firebase.initializeApp();
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
  // يمكن هنا تنفيذ منطق معقد مثل حفظ بيانات الإشعار في قاعدة البيانات المحلية
}

// -------------------------------------------------------------------
// 2. إعداد الإشعارات المحلية (Local Notifications Setup)
// -------------------------------------------------------------------

Future<void> initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // يجب تحديد delegate لـ onDidReceiveNotificationResponse للتعامل مع الضغط على الإشعار
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // يمكن إضافة منطق معالجة الضغط على الإشعار هنا
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (kDebugMode) {
        print('Notification payload: ${response.payload}');
      }
      // مثال: Navigator.pushNamed(context, response.payload);
    },
  );
}

// -------------------------------------------------------------------
// 3. عرض الإشعار المحلي (Show Local Notification)
// ---------------------------------------------------

void showLocalNotification(RemoteMessage message) async {
  // استخدام بيانات الإشعار
  final String? title = message.notification?.title;
  final String? body = message.notification?.body;

  if (title == null || body == null) return;

  final NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'high_importance_channel', // يجب أن يتطابق مع إعدادات الـ Android
      'الإشعارات الهامة', // اسم القناة بالعربية
      channelDescription: 'قناة الإشعارات الهامة للتطبيق',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    ),
  );

  await flutterLocalNotificationsPlugin.show(
    message.hashCode, // معرف فريد للإشعار
    title,
    body,
    notificationDetails,
    // تمرير البيانات الإضافية في الـ payload
    payload: message.data['route'] ?? '',
  );
}

// -------------------------------------------------------------------
// 4. الحصول على Device ID (للتسجيل في الخادم)
// -------------------------------------------------------------------

Future<String> getDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  } else if (Platform.isIOS) {
    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor ?? 'ios_device_id';
  }
  return 'unknown_device_id';
}

// -------------------------------------------------------------------
// 5. دالة حفظ الـ Token
// -------------------------------------------------------------------

void saveTokenToDatabase(String? token) async {
  if (token != null) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
    if (kDebugMode) {
      print("FCM Token saved to SharedPreferences: $token");
    }
  }
}

// -------------------------------------------------------------------
// 6. دالة إعداد الإشعارات الرئيسية (التعديل للربط بـ Cubit)
// -------------------------------------------------------------------

// يجب تمرير الـ Cubit أو دالة callback للتعامل مع إرسال التوكن إلى الخادم
Future<void> setupNotifications({
  required Function(String fcmToken, String deviceId) onTokenReceived,
}) async {
  // طلب الأذونات
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // ربط معالج رسائل الخلفية
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // التعامل مع الإشعارات أثناء وجود التطبيق في المقدمة (Foreground)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
    }
    if (message.notification != null) {
      showLocalNotification(message); // عرض الإشعار محلياً
    }
  });

  // التعامل مع الضغط على الإشعار عندما يكون التطبيق في الخلفية أو مغلقاً
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('A message opened the app: ${message.data}');
    }
    // هنا يتم تنفيذ منطق التوجيه (Navigation) بناءً على بيانات الإشعار
  });

  // جلب التوكن وتسجيله
  String? token = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print("FCM Token: $token");
  }

  if (token != null) {
    saveTokenToDatabase(token); // حفظ محلي

    // إرسال التوكن إلى الخادم عبر الدالة الممررة (مثل Cubit)
    final deviceId = await getDeviceId();
    onTokenReceived(token, deviceId);
  }
}
