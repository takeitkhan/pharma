import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure you have this import
import 'package:pharma/View/Auth/Signin.dart';
import 'package:pharma/View/Profile/ProfileWidget/ProfileImage.dart';
import 'package:pharma/View/Profile/ProfileWidget/ProfileList.dart';
import 'package:pharma/View/Profile/SubPage/AdminPanel.dart';
import 'package:pharma/View/Profile/SubPage/EditProfile.dart';
import 'package:pharma/View/Profile/SubPage/ProfileDetail.dart';
import 'package:provider/provider.dart';
import '../../Provider/authentication.dart';
import '../../Provider/profile_provider.dart';
import '../Pharmacy/AddNewPharmacy.dart';
import '../Pharmacy/Pharmacy.dart';

class LodgedInProfile extends StatelessWidget {
  const LodgedInProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Container(
                  height: size.height * 0.21,
                  color: Colors.white,
                ),
                Container(
                  height: size.height - size.height * 0.21,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ],
            ),
            topWidget(size, pro, context)
          ],
        ),
      ),
    );
  }
}

Widget topWidget(Size size, ProfileProvider pro, BuildContext context) {
  final List<String> listName = [
    "Edit Profile",
    "Create Pharmacy",
    "My Pharmacy",
    "Admin Panel",
    pro.isProfileComplete ? "Profile Detail" : "Complete Your Profile",
    "Log out"
  ];

  final List<IconData> listIcons = [
    Icons.person_outline,
    Icons.local_pharmacy_rounded,
    Icons.local_pharmacy_outlined,
    Icons.security,
    Icons.format_align_center,
    Icons.login_outlined,
  ];

  return SingleChildScrollView(
    child: SizedBox(
      height: 800.h,
      width: 360.w,
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.12,
          ),
          const ProfileImage(),
          Consumer<ProfileProvider>(builder: (_, __, ___) {
            return Text(
              pro.profileName.isEmpty ? "Unknown Name" : pro.profileName,
              style: GoogleFonts.lato(
                fontSize: 23.sp,
                fontWeight: FontWeight.bold,
              ),
            );
          }),

          const SizedBox(height: 10),
          Text(
            pro.email.isEmpty ? "Unknown Email" : pro.email,
            style: GoogleFonts.lato(fontSize: 13.sp, color: Colors.grey),
          ),

          Consumer<ProfileProvider>(builder: (_, __, ___) {
            return Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (index == 0) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditProfile()));
                      } else if (index == 1) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddNewPharmacy()));
                      } else if (index == 2) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Pharmacy(
                              isMyPharmacyPage: true,
                            )));
                      } else if (index == 3) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AdminPanel()));
                      } else if (index == 4) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfileDetails()));
                      } else if (index == 5) {
                        Provider.of<Authentication>(context, listen: false)
                            .signOut();
                        pro.profileName = '';
                        pro.role = '';

                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SignIn()));
                      }
                    },
                    child: pro.role == "admin" || pro.role == "contractor"
                        ? pro.role == "contractor" && index == 3
                        ? const SizedBox()
                        : profileList(
                      listName[index],
                      listIcons[index],
                    )
                        : index == 1 || index == 2 || index == 3
                        ? const SizedBox()
                        : profileList(
                      listName[index],
                      listIcons[index],
                    ),
                  );
                },
                itemCount: listIcons.length,
              ),
            );
          }),

          //const SizedBox(height: 55),
        ],
      ),
    ),
  );
}
