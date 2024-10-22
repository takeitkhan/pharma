import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:pharma/View/Pharmacy/SingleUser.dart';

import '../../../Utils/app_colors.dart';

class SinglePharmasist extends StatefulWidget {
  SinglePharmasist({Key? key, required this.pharmacyId, required this.creatorId})
      : super(key: key);
  final String pharmacyId;
  final String creatorId;

  @override
  State<SinglePharmasist> createState() => _SinglePharmasistState();
}

class _SinglePharmasistState extends State<SinglePharmasist> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("pharmacy")
          .doc(widget.pharmacyId)
          .collection("pharmacies")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Something went wrong",
              style: GoogleFonts.lato(), // Use Lato font
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data;
        return ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                // Padding to create space between the items
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h), // Vertical spacing
                  child: SingleUser(
                    uid: data?.docs[index]["pharmaciesId"],
                    docId: data!.docs[index].id,
                    pharmacyId: widget.pharmacyId,
                    ownerId: widget.creatorId,
                  ),
                ),
                // Divider to create a bottom border
                Divider(
                  thickness: 1, // Adjust thickness as per your design
                  color: ashColor, // ashColor for the bottom border
                ),
              ],
            );
          },
          itemCount: data?.size,
        );
      },
    );
  }
}
