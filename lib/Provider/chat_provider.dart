import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pharma/Provider/profile_provider.dart';

var encryptionKey = 'sdkgh48598ysjhgs98g734kdhf';

class ChatProvider with ChangeNotifier {
  String chatId = "";

  /// Encryption And Decryption Start ##############################

  static String encrypt(String data) {
    var charCount = data.length;
    var encrypted = [];
    var kp = 0;
    var kl = encryptionKey.length - 1;

    for (var i = 0; i < charCount; i++) {
      var other = data[i].codeUnits[0] ^ encryptionKey[kp].codeUnits[0];
      encrypted.insert(i, other);
      kp = (kp < kl) ? (++kp) : (0);
    }
    return dataToString(encrypted);
  }

  static String decrypt(data) {
    return encrypt(data);
  }

  static String dataToString(data) {
    var s = "";
    for (var i = 0; i < data.length; i++) {
      s += String.fromCharCode(data[i]);
    }
    return s;
  }

  /// Encryption And Decryption END ##############################

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  createChatRoom(String uid1, String uid2, String url1, String url2,
      String name1, String name2) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(getChatRoomIdByUsernames(uid1, uid2))
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      chatId = getChatRoomIdByUsernames(uid1, uid2);
      notifyListeners();
      return true;
    } else {
      final snapShot = await FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(getChatRoomIdByUsernames(uid2, uid1))
          .get();

      if (snapShot.exists) {
        // chatroom already exists
        chatId = getChatRoomIdByUsernames(uid2, uid1);
        notifyListeners();
        return true;
      }
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(getChatRoomIdByUsernames(uid1, uid2))
          .set(
        {
          "lastMessage": "",
          "user1": uid1,
          "url1": url1,
          "name1": name1,
          "user2": uid2,
          "url2": url2,
          "name2": name2,
        },
      ).then((value) => {
                chatId = getChatRoomIdByUsernames(uid1, uid2),
                notifyListeners(),
              });
    }
  }

  Future addMessage({
    required String message,
    required String senderName,
    required String myUid,
    required String token,
    required String receiverUid,
  }) async {
    await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatId)
        .collection("chats")
        .doc()
        .set(
      {
        "message": encrypt(message),
        "sendBy": myUid,
        "ts": DateTime.now().toString(),
      },
    );

    try {
      print(myUid);
      print(senderName);
      print("myUid----------------------------------------");
      var client = http.Client();
      var a =
          await client.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              body: jsonEncode({
                'to': token,
                "priority": "high",
                'notification': {'title': senderName, 'body': message},
                'data': {'message': message, 'uid': myUid}
              }),
              headers: {
            'Content-Type': 'application/json',
            // Example header
            'Authorization':
                'key=AAAA11afjE8:APA91bHvhOsfthYzR0RRlZ2pwdRwwvBeS0FOvpaI5_sdU8X5TYFwVpGoRr39WrZf9N5OTysmzc8ltc-hmpNnNAwiwmvdqgJAxK0mPRiEyn4OzmWM4muCvfW0mi7SWHrCUTFvo7eA7DdO',
            // Example header for authentication
          });
      print(a);
      print(a.body);
      print("-------------------------------------------------ii");
    } catch (e) {
      print("ererrrrrrrrrrrrrrrrrrrrrr");
      print(e);
    }

    FirebaseFirestore.instance.collection("chatRooms").doc(chatId).update(
      {
        "lastMessage": encrypt(message),
      },
    );
  }
}
