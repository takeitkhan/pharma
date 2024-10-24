import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/View/Profile/SubPage/AdminPanel.dart';
import 'package:provider/provider.dart';
import '../../../Provider/profile_provider.dart';

Padding chatTop(BuildContext context) {
  var pro = Provider.of<ProfileProvider>(context, listen: false);

  return Padding(
    padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 15.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Icon on the left
        IconButton(
          icon: Icon(Icons.arrow_back, size: 22.sp),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),

        // Title in the center
        Text(
          "Messages",
          style: GoogleFonts.lato( // Changed to Lato font
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Admin icon on the right (shown only if the user is an admin)
        pro.role == "admin"
            ? IconButton(
          icon: Icon(FontAwesomeIcons.users, size: 22.sp),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminPanel(isAdminPanel: false),
              ),
            );
          },
        )
            : SizedBox(width: 48.sp), // Placeholder for alignment when not admin
      ],
    ),
  );
}
