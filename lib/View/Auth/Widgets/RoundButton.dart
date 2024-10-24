import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

Widget roundedButton(String text) {
  return Container(
    margin: EdgeInsets.only(right: 2.w),
    height: 50.sp,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Color(0xff48CCB5),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
        child: Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,

      ),
    )),
  );
}
