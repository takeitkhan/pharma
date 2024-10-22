import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharma/View/Notices/LoggedInNotice.dart';
import 'package:pharma/View/Notices/LoggedOutNotice.dart';

class NoticeMiddlePage extends StatefulWidget {
  const NoticeMiddlePage({super.key});

  @override
  State<NoticeMiddlePage> createState() => _NoticeMiddlePageState();
}

class _NoticeMiddlePageState extends State<NoticeMiddlePage> {
  bool isLodgedIn = false;

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      isLodgedIn = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLodgedIn ? const LoggedInNotice() : const LoggedOutNotice(),
    );
  }
}
