import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Provider/pharmacy_provider.dart';
import '../../Provider/profile_provider.dart';
import 'package:shimmer/shimmer.dart';

class SingleUser extends StatefulWidget {
  const SingleUser({
    Key? key,
    required this.uid,
    required this.pharmacyId,
    required this.ownerId,
    required this.docId,
  }) : super(key: key);

  final String uid;
  final String pharmacyId;
  final String ownerId;
  final String docId;

  @override
  _SingleUserState createState() => _SingleUserState();
}

class _SingleUserState extends State<SingleUser> {
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

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    print( pro.currentUserUid);
    print( widget.ownerId);
    try{
      data["name"];
    }catch(e){
      return SizedBox();
    }
    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.grey,
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.grey, radius: 20.sp),
                SizedBox(width: 15.w),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("User name", style: TextStyle(fontSize: 14)),
                    Text("...h", style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          )
        : Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 21,
                backgroundImage: AssetImage("assets/profile.jpg"),
              ),
              SizedBox(width: 12.w),
              Text(
                data["name"].length > 13
                    ? '${data["name"].substring(0, 13)}...'
                    : data["name"],
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              pro.currentUserUid == widget.ownerId
                  ? InkWell(
                      onTap: () {
                        _showMyDialog(context, widget.pharmacyId, widget.docId);
                      },
                      child: Text(
                        "Remove",
                        style: GoogleFonts.inter(
                          color: Colors.red,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(width: 40.w),
            ],
          );
  }

  GestureDetector buildNameText(double size) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        "By: ${data["name"]}",
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
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

Future<void> _showMyDialog(
    BuildContext context, String pharmacyId, String docId) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Remove Pharmacists'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Do you want to remove the pharmacists from this pharmacy?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Provider.of<PharmacyProvider>(context, listen: false)
                  .deletePharmacists(docId, pharmacyId);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
