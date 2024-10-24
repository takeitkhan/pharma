import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/View/Profile/SubPage/AdminPanel.dart';
import 'package:provider/provider.dart';
import '../../../Provider/profile_provider.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);

    return AppBar(
      title: Text(
        "Messages",
        style: GoogleFonts.lato( // Changed to Lato font
          color: Colors.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        // Admin icon on the right (shown only if the user is an admin)
        if (pro.role == "admin")
          IconButton(
            icon: Icon(FontAwesomeIcons.users, size: 22.sp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminPanel(isAdminPanel: false),
                ),
              );
            },
          ),
      ],
    );
  }
}
