import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/search_bar.dart';
import 'UserList.dart';

class AdminPanel extends StatefulWidget {
  AdminPanel({Key? key, this.isAdminPanel}) : super(key: key);
  final bool? isAdminPanel;

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isAdminPanel != null ? "Users" : "Admin Panel",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.only(left: 10.w),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        width: 414.w,
        height: 837.h,
        child: Column(
          children: [
            SizedBox(height: 25.h),
            Row(
              children: [
                Text(
                  "Name",
                  style: GoogleFonts.inter(
                    fontSize: 17.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 130.w,
                  child: Center(
                    child: Text(
                      "Role",
                      style: GoogleFonts.inter(
                        fontSize: 17.sp,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            const Divider(
              thickness: 1,
              height: 0,
            ),
            SizedBox(height: 12.h),
            buildSearch(context, "user"), // Implement the search bar widget
            SizedBox(height: 12.h),
            Expanded(
              child: UserList(isAdminPanel: widget.isAdminPanel),
            )
          ],
        ),
      ),
    );
  }
}
