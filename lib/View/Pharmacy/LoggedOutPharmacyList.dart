import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package
import '../Auth/widgets/RoundButton.dart';

class LoggedOutPharmacyList extends StatefulWidget {
  const LoggedOutPharmacyList({super.key});

  @override
  State<LoggedOutPharmacyList> createState() => _LoggedOutPharmacyListState();
}

class _LoggedOutPharmacyListState extends State<LoggedOutPharmacyList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200.h,
            child: Image.asset("assets/pharmacy.png"), // Update the image path as needed
          ),
          SizedBox(height: 20.h),
          Text(
            "You are not logged in. To view the pharmacy list, please log in.",
            textAlign: TextAlign.center,
            style: GoogleFonts.lato( // Ensure Lato font is used
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed("SignIn");
            },
            child: roundedButton("Sign in / Register"), // Ensure button uses Lato font in its implementation
          ),
        ],
      ),
    );
  }
}
