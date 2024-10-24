import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/View/Pharmacy/PharmacistList.dart';
import '../../Utils/app_colors.dart';

class PharmacyDetail extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? data;

  PharmacyDetail({Key? key, this.data}) : super(key: key);

  @override
  State<PharmacyDetail> createState() => _PharmacyDetailState();
}

class _PharmacyDetailState extends State<PharmacyDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.data?["pharmacyName"] ?? "Pharmacy",
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPharmacyInfoCard(),
              SizedBox(height: 16.h),
              _buildWorkersSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPharmacyInfoCard() {
    return Card(
      color: offWhite, // Set your desired background color here
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.description, "Pharmacy Details", widget.data?["description"]),
            SizedBox(height: 12.h),
            _buildInfoRow(Icons.location_on, "Pharmacy Address", widget.data?["address"]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String? content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: ashColor, size: 24.sp),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                content ?? "N/A",
                style: GoogleFonts.lato(
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 1000.h,
          child: Card(
            color: offWhite, // Set your desired background color here
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: PharmasistList(
                pharmacyId: widget.data?.id ?? "",
                creatorId: widget.data?["ownerUid"],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
