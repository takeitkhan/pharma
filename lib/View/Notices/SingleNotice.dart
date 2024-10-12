import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleNotice extends StatefulWidget {
  const SingleNotice({super.key});

  @override
  State<SingleNotice> createState() => _SingleNoticeState();
}

class _SingleNoticeState extends State<SingleNotice> {
  Map payload = {};

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
    if (data is RemoteMessage) {
      payload = data.data;
    }
    if (data is NotificationResponse) {
      payload = jsonDecode(data.payload!);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Notice Detail",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: 350.w,
        height: 200.h,
        margin: EdgeInsets.fromLTRB(32.w, 10.h, 32.w, 10.h),
        padding: EdgeInsets.fromLTRB(20.w, 21.h, 5, 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xffE3E3E3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Title : ${payload['title']}",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  payload['description'],
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15.sp, height: 1.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
