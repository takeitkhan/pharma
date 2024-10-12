import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pharma/initial.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Provider/profile_provider.dart';
import '../../Utils/custom_loading.dart';
import 'Chat.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package

class HoldingPage extends StatefulWidget {
  const HoldingPage({super.key});

  @override
  State<HoldingPage> createState() => _HoldingPageState();
}

class _HoldingPageState extends State<HoldingPage> {
  Map payload = {};
  late DocumentSnapshot data;

  getInfo(String uid) async {
    try {
      data = await Provider.of<ProfileProvider>(context, listen: false)
          .getProfileInfoByUID(uid);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
              name: data["name"],
              url: data["url"],
              uid: data.id,
              token: data["token"],
              isFromNotification: true,
            ),
          ),
        );
      }
    } catch (err) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MiddleOfHomeAndSignIn(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
    if (data is RemoteMessage) {
      payload = data.data;
    }
    if (data is NotificationResponse) {
      payload = jsonDecode(data.payload!);
    }
    getInfo(payload["uid"]);
    return Scaffold(
      body: Center(
        child: Text(
          'Loading...', // Optional loading text
          style: GoogleFonts.lato(fontSize: 20), // Use Lato font
        ),
      ),
    );
  }
}
