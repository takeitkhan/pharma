import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // request notification permission
  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // get the device fcm token
    try {
      final token = await _firebaseMessaging.getToken();
      print("Device token: $token");
    } catch (e) {
      print("Error retrieving token: $e");
    }
  }

  static Future localNotiInit() async {
    const String channelId =
        'high_priority_notifications'; // Use a consistent channel ID
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize the local notifications plugin
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) => null,
      ),
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);

    // Create a notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      'High Priority Notifications',
      description: 'Channel for high priority notifications',
      importance: Importance.max,
    );

    // Create the notification channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // on tap local notification in foreground
  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState!
        .pushNamed("/message", arguments: notificationResponse);
  }

  // show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'high_priority_notifications', // Use the same channel ID here
      'High Priority Notifications', // User-visible channel name
      channelDescription: 'Channel for high priority notifications',
      // Use a relevant description
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
