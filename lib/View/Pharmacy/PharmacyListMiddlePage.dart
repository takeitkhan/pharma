import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharma/View/Pharmacy/Pharmacy.dart'; // Replace with your actual path
import 'package:pharma/View/Pharmacy/LoggedOutPharmacyList.dart'; // Import the logged-out pharmacy widget

class PharmacyListPage extends StatefulWidget {
  const PharmacyListPage({super.key});

  @override
  State<PharmacyListPage> createState() => _PharmacyListPageState();
}

class _PharmacyListPageState extends State<PharmacyListPage> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      isLoggedIn = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoggedIn
          ? Pharmacy() // Show the pharmacy list if logged in
          : const LoggedOutPharmacyList(), // Show the logged-out message otherwise
    );
  }
}
