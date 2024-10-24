import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../Utils/error_dialoge.dart';
import 'notification_helper.dart';

class NoticeProvider with ChangeNotifier {
  Future addNewNotice({
    required String postText,
    required String postTitle,
    required String dateTime,
    required String databaseName,
    required BuildContext context,
  }) async {
    try {
      await FirebaseFirestore.instance.collection(databaseName).doc().set(
        {
          "postText": postText,
          "postTitle": postTitle,
          "dateTime": dateTime,
          "ownerUid": FirebaseAuth.instance.currentUser!.uid,
        },
      );

      // Send notification to all users
      await sendNotificationToAll(postTitle, postText);
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future<void> sendNotificationToAll(String title, String body) async {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    for (var userDoc in usersSnapshot.docs) {
      String deviceToken = userDoc['token'];
      try {
        await NotificationService.sendNotification(deviceToken, title, body);
      } catch (e) {
        print("Error sending notification to $deviceToken: $e");
      }
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
