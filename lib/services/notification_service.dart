import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'main_channel',
    'Main Channel',
    description: 'Main notifications from Eazybot',
    importance: Importance.high,
  );

  static Future<void> init() async {
    if (Platform.isWindows) return;

    /// Ask permission (Android 13+)
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    /// Android init
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    /// ✅ IMPORTANT: Use NAMED parameter
    await _local.initialize(settings: initSettings);

    /// Create channel
    final androidPlugin = _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(_channel);

    /// Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    /// Print token (for testing)
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN: $token");
  }

  static Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          channelDescription: 'Main notifications from Eazybot',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    /// ✅ IMPORTANT: Use NAMED parameters
    await _local.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: message.notification?.title ?? 'Eazybot',
      body: message.notification?.body ?? 'You have a new message',
      notificationDetails: details,
      payload: 'default',
    );
  }
}
