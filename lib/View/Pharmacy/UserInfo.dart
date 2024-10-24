import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pharma/Utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../Provider/profile_provider.dart';
import 'package:shimmer/shimmer.dart';

class UserInfoOfAPost extends StatefulWidget {
  const UserInfoOfAPost(
      {Key? key,
      required this.uid,
      required this.time,
      this.postId,
      required this.address})
      : super(key: key);

  final String uid;
  final String time;
  final String address;
  final String? postId;

  @override
  _UserInfoOfAPostState createState() => _UserInfoOfAPostState();
}

class _UserInfoOfAPostState extends State<UserInfoOfAPost> {
  late DocumentSnapshot data;
  bool isLoading = true;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  getInfo() async {
    data = await Provider.of<ProfileProvider>(context, listen: false)
        .getProfileInfoByUID(widget.uid);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day, from.hour, from.minute);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute);
    if (to.difference(from).inHours > 24) {
      return (to.difference(from).inHours / 24).round().toString() + " day";
    } else if (to.difference(from).inMinutes < 60) {
      return to.difference(from).inMinutes.toString() + " min";
    } else {
      return to.difference(from).inHours.toString() + " hour";
    }
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.grey,
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.grey, radius: 20.sp),
                SizedBox(width: 15.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("User name", style: TextStyle(fontSize: 14)),
                    Text("...h", style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  pro.profileName.isEmpty ? SizedBox() : buildNameText(14),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      "Address: ${widget.address}",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        // Changed to Lato
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: semiBlack,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  buildTimeText(),
                ],
              ),
            ],
          );
  }

  GestureDetector buildNameText(double size) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        "Manager: ${data["name"]}",
        style: GoogleFonts.lato(
          // Changed to Lato
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: semiBlack,
        ),
      ),
    );
  }

  Text buildTimeText() {
    return Text(
      //'Created: ${daysBetween(DateTime.parse(widget.time), DateTime.now())} ago',
      'Created: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.time))}',
      style: GoogleFonts.lato(
        // Changed to Lato
        color: semiBlack,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

Widget returnImage(DocumentSnapshot data) {
  return data["url"] != ""
      ? CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 21.sp,
          backgroundImage: NetworkImage(
            data["url"],
          ),
        )
      : CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 21.sp,
          backgroundImage: const AssetImage("assets/profile.jpg"),
        );
}
