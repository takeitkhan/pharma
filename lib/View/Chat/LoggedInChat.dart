import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/Utils/app_colors.dart';
import 'package:pharma/View/Chat/widgets/IndividualChatInfo.dart';
import 'package:pharma/View/Profile/SubPage/AdminPanel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../Provider/profile_provider.dart';
import '../../Utils/custom_loading.dart';

class LodgedInChat extends StatefulWidget {
  const LodgedInChat({Key? key}) : super(key: key);

  @override
  State<LodgedInChat> createState() => _LodgedInChatState();
}

class _LodgedInChatState extends State<LodgedInChat> {
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Messages",
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: null,
        actions: [
          // Admin icon on the right (shown only if the user is an admin)
          if (pro.role == "admin")
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: IconButton(
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
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20.h), // Reduced height
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("chatRooms")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildLoadingWidget();
                  }

                  final data = snapshot.data;

                  // Check if the snapshot data is available and if the size is 0
                  if (data == null || data.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "There are no messages available yet",
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: ashColor,
                        ),
                      ),
                    );
                  }

                  // Check if there are any messages for the logged-in user
                  bool hasMessages = data.docs.any((doc) =>
                    doc["user1"] == pro.currentUserUid || doc["user2"] == pro.currentUserUid
                  );

                  if (!hasMessages) {
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child:  Text(
                          "There are no messages available yet",
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: ashColor,
                          ),
                      ),
                    );
                  }

                  return buildListOfChat(data);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  ListView buildListOfChat(QuerySnapshot<Object?> data) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        String uid = "";
        bool show = false;
        if (data.docs[index]["user1"] == pro.currentUserUid) {
          uid = data.docs[index]["user2"];
          show = true;
        } else if (data.docs[index]["user2"] == pro.currentUserUid) {
          uid = data.docs[index]["user1"];
          show = true;
        }

        return show && data.docs[index].data() is Map<String, dynamic> &&
            (data.docs[index].data() as Map<String, dynamic>).containsKey("lastMessage") &&
            (data.docs[index].data() as Map<String, dynamic>)["lastMessage"] != ""
            ? Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              child: IndividualChatInfo(
                lastMs: (data.docs[index].data() as Map<String, dynamic>)["lastMessage"],
                uid: uid,
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey[300],
              indent: 20.w,
              endIndent: 20.w,
            ),
          ],
        )
            : const SizedBox();


      },
      itemCount: data.size, // Use data.size directly
    );
  }
}
