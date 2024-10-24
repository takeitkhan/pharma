import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Auth/widgets/RoundButton.dart';
class LodgedOut extends StatelessWidget {
  const LodgedOut({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 250.h,
            child: ClipRRect(borderRadius: BorderRadius.circular(500) ,child: Image.asset("assets/profile.jpg")),
          ),
          SizedBox(height: 20.h),
          Text(
            "You are not logged in. To view profile, please log in.",
            textAlign: TextAlign.center,
            style: TextStyle(
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
            child: roundedButton("Sign in / Register"),
          ),
          /*GestureDetector(
            onTap: () {
              Provider.of<Authentication>(context, listen: false).signOut();
            },
            child: roundedButton("LogOut"),
          )*/
        ],
      ),
    );
  }
}
