import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Auth/widgets/RoundButton.dart';

class LoggedOutNotice extends StatefulWidget {
  const LoggedOutNotice({super.key});

  @override
  State<LoggedOutNotice> createState() => _LoggedOutNoticeState();
}

class _LoggedOutNoticeState extends State<LoggedOutNotice> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200.h,
            child: Image.asset("assets/notice.jpg"),
          ),
          SizedBox(height: 20.h),
          Text(
            "You are not logged in. To view notices, please log in.",
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
        ],
      ),
    );
  }
}
