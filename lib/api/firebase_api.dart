import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseApi {
  static Future<String?> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return await messaging.getToken();
    } else {
      return null; // Explicitly return null when not authorized
    }
  }

  // Updated method to send notification to a topic
  static Future<void> sendPushNotificationToTopic(String topic, String title, String message) async {
    try {
      final url = 'https://fcm.googleapis.com/fcm/send';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAA11afjE8:APA91bHvhOsfthYzR0RRlZ2pwdRwwvBeS0FOvpaI5_sdU8X5TYFwVpGoRr39WrZf9N5OTysmzc8ltc-hmpNnNAwiwmvdqgJAxK0mPRiEyn4OzmWM4muCvfW0mi7SWHrCUTFvo7eA7DdO', // Replace with your server key
        },
        body: jsonEncode({
          'to': '/topics/$topic', // Targeting the topic
          'notification': {
            'title': title,
            'body': message,
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully to topic: $topic');
      } else {
        print('Error sending notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }
}
