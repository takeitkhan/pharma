import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Utils/app_colors.dart'; // Ensure you import your color utilities

class UpdateNoticePage extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> notice;

  const UpdateNoticePage({Key? key, required this.notice}) : super(key: key);

  @override
  State<UpdateNoticePage> createState() => _UpdateNoticePageState();
}

class _UpdateNoticePageState extends State<UpdateNoticePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.notice["postTitle"];
    _textController.text = widget.notice["postText"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Update Notice',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              buildTextField(_titleController, "Notice Title"),
              SizedBox(height: 10.h),
              buildTextField(_textController, "Notice Details", maxLine: 6),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () => _updateNotice(),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.black.withOpacity(0.5),
                  ),
                  child: Text(
                    "Update Notice",
                    style: GoogleFonts.lato(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTextField(TextEditingController controller, String text, {int maxLine = 1}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextField(
        maxLines: maxLine,
        style: const TextStyle(color: Colors.black),
        controller: controller,
        decoration: InputDecoration(
          fillColor: Color(0xffC4C4C4).withOpacity(0.2),
          filled: true,
          hintText: text,
          hintStyle: GoogleFonts.lato(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<void> _updateNotice() async {
    try {
      await FirebaseFirestore.instance.collection('notice').doc(widget.notice.id).update({
        'postTitle': _titleController.text,
        'postText': _textController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notice updated successfully')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating notice: $e')));
    }
  }
}
