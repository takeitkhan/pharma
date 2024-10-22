import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Provider/notice_provider.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/custom_loading.dart';
import '../../Utils/error_dialoge.dart';

class AddNotice extends StatefulWidget {
  AddNotice({Key? key, this.documentSnapshot}) : super(key: key);
  DocumentSnapshot? documentSnapshot;

  @override
  _AddNoticeState createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  late TextEditingController postController;
  late TextEditingController titleController;
  String selectedAudience = "All Users"; // Track selected audience
  String databaseName = "notice";

  @override
  void initState() {
    super.initState();
    if (widget.documentSnapshot != null) {
      postController =
          TextEditingController(text: widget.documentSnapshot!["postText"]);
      titleController =
          TextEditingController(text: widget.documentSnapshot!["postTitle"]);
    } else {
      postController = TextEditingController();
      titleController = TextEditingController();
    }
  }

  Future uploadNotice() async {
    try {
      buildLoadingIndicator(context);
      await Provider.of<NoticeProvider>(context, listen: false).addNewNotice(
        postText: postController.text,
        postTitle: titleController.text,
        databaseName: databaseName,
        dateTime: DateTime.now().toString(),
        context: context,
      );
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future updateNotice() async {
    try {
      buildLoadingIndicator(context);
      await Provider.of<NoticeProvider>(context, listen: false).updateNotice(
        postText: postController.text,
        id: widget.documentSnapshot!.id,
        postTitle: titleController.text,
        databaseName: databaseName,
        context: context,
      );
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          widget.documentSnapshot == null ? 'Add Notice' : 'Update Notice',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black, size: 30.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Radio buttons for audience selection
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    value: "All Users",
                    groupValue: selectedAudience,
                    onChanged: (value) {
                      setState(() {
                        selectedAudience = value as String;
                        databaseName = "notice";
                      });
                    },
                  ),
                  Text("To all users",
                      style: GoogleFonts.lato(fontSize: 16.sp)),
                  SizedBox(width: 20.w),
                  Radio(
                    value: "Contractor",
                    groupValue: selectedAudience,
                    onChanged: (value) {
                      setState(() {
                        selectedAudience = value as String;
                        databaseName = "contractorNotice";
                      });
                    },
                  ),
                  Text("To all contractors",
                      style: GoogleFonts.lato(fontSize: 16.sp)),
                ],
              ),
              SizedBox(height: 20.h),
              buildTextField(titleController, "Title"),
              SizedBox(height: 10.h),
              buildTextField(postController, "Description", maxLine: 6),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  if (widget.documentSnapshot == null) {
                    uploadNotice();
                  } else {
                    updateNotice();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                  EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.black.withOpacity(0.7),
                ),
                child: Text(
                  widget.documentSnapshot == null
                      ? "Post Notice"
                      : "Update Notice",
                  style: GoogleFonts.lato(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTextField(TextEditingController controller, String labelText,
      {int maxLine = 1}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: TextField(
        maxLines: maxLine,
        controller: controller,
        decoration: InputDecoration(
          fillColor: Color(0xffC4C4C4).withOpacity(0.2),
          filled: true,
          hintText: labelText,
          hintStyle: GoogleFonts.lato(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}