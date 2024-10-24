import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoggedInProfile.dart';
import 'LoggedOutProfile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      body: isLodgedIn ? const LodgedInProfile() : const LodgedOut(),
    );
  }
}
