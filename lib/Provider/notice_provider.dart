import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Utils/error_dialoge.dart';

class NoticeProvider with ChangeNotifier {
  final String serverToken =
      'AAAA11afjE8:APA91bHvhOsfthYzR0RRlZ2pwdRwwvBeS0FOvpaI5_sdU8X5TYFwVpGoRr39WrZf9N5OTysmzc8ltc-hmpNnNAwiwmvdqgJAxK0mPRiEyn4OzmWM4muCvfW0mi7SWHrCUTFvo7eA7DdO'; // Replace with your server key

  Future addNewNotice({
    required String postText,
    required String postTitle,
    required String dateTime,
    required String databaseName,
    required BuildContext context,
  }) async {
    try {
      // Add notice to Firestore
      await FirebaseFirestore.instance.collection(databaseName).doc().set(
        {
          "postText": postText,
          "postTitle": postTitle,
          "dateTime": dateTime,
          "ownerUid": FirebaseAuth.instance.currentUser!.uid,
        },
      );

      // Send notification
      await _sendNotification(postTitle, postText, databaseName);

      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future<void> _sendNotification(
      String title, String body, String databaseName) async {
    var client = http.Client();
    try {
      final response = await client.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode({
          'to': '/topics/$databaseName',
          "priority": "high",
          'notification': {
            'title': title.isEmpty ? 'Community Pharma Connect' : title,
            'body': body.isEmpty ? 'You have a new notice' : body,
          },
          'data': {
            'title': title,
            'description': body,
          },
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print("Failed to send notification: $e");
    } finally {
      client.close();
    }
  }


  Future addPost({
    required String postText,
    required String imageUrl,
    required String dateTime,
    required String name,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore.instance.collection(name + "Post").doc().set(
        {
          "postText": postText,
          "imageUrl": imageUrl,
          "dateTime": dateTime,
          "ownerUid": FirebaseAuth.instance.currentUser!.uid,
        },
      );
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future updatePost({
    required String postText,
    required String imageUrl,
    required String name,
    required String id,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore.instance.collection(name + "Post").doc(id).update(
        {
          "postText": postText,
          "imageUrl": imageUrl,
          "ownerUid": FirebaseAuth.instance.currentUser!.uid,
        },
      );
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future updateNotice({
    required String postText,
    required String id,
    required String postTitle,
    required String databaseName,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore.instance.collection(databaseName).doc(id).update(
        {
          "postText": postText,
          "postTitle": postTitle,
        },
      );
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future addEvent({
    required String title,
    required String schedule,
    required String place,
    required String description,
    required String url,
    required String name,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore.instance.collection(name + "Event").doc().set(
        {
          "title": title,
          "schedule": schedule,
          "place": place,
          "description": description,
          "url": url,
          "ownerUid": FirebaseAuth.instance.currentUser!.uid,
          "dateTime": DateTime.now(),
        },
      );
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future updateEvent({
    required String title,
    required String schedule,
    required String id,
    required String place,
    required String description,
    required String url,
    required String name,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore.instance.collection(name + "Event").doc(id).update(
        {
          "title": title,
          "schedule": schedule,
          "place": place,
          "description": description,
          "url": url,
        },
      );
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future deleteNotice(String id) async {
    await FirebaseFirestore.instance.collection("notice").doc(id).delete();
    notifyListeners();
  }

  Future deleteEvent(String id, String postFrom) async {
    await FirebaseFirestore.instance.collection(postFrom).doc(id).delete();
    notifyListeners();
  }

  Future deletePost(String id, String postFrom) async {
    await FirebaseFirestore.instance.collection(postFrom).doc(id).delete();
    notifyListeners();
  }
}
