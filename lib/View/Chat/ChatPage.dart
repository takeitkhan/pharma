import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharma/View/Chat/LoggedInChat.dart';
import 'package:pharma/View/Chat/LoggedOutChat.dart';
import '../Auth/widgets/RoundButton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool isLodgedIn = false;

  @override
  void initState() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      isLodgedIn = true;
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLodgedIn ? const LodgedInChat() : const LodgedOutChat(),
    );
  }
}
