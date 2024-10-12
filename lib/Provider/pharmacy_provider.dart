import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../Utils/error_dialoge.dart';

class PharmacyProvider with ChangeNotifier {
  Future addNewPharmacy({
    required String pharmacyName,
    required String address,
    required String description,
    required String dateTime,
    required BuildContext context,
  }) async {
    try {
      await FirebaseFirestore.instance.collection("pharmacy").doc().set(
        {
          "pharmacyName": pharmacyName,
          "address": address,
          "description": description,
          "dateTime": dateTime,
          "ownerUid": FirebaseAuth.instance.currentUser!.uid,
        },
      );
      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
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

  Future updatePharmacy({
    required String pharmacyName,
    required String address,
    required String description,
    required String id,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore.instance.collection("pharmacy").doc(id).update(
        {
          "pharmacyName": pharmacyName,
          "address": address,
          "description": description,
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

  Future<void> deletePharmacy(String id) async {
    try {
      await FirebaseFirestore.instance.collection("pharmacy").doc(id).delete();
      notifyListeners(); // Notify listeners to update the UI
    } catch (e) {
      print("Error deleting pharmacy: $e"); // Debugging line
      // Optionally, handle errors here (e.g., show a message to the user)
    }
  }

  Future deletePharmacists(String docId, String pharmacyId) async {
    print(docId);
    print("------------------------1");
    await FirebaseFirestore.instance
        .collection("pharmacy")
        .doc(pharmacyId)
        .collection("pharmacies")
        .doc(docId)
        .delete();
    print("------------------------2");
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
