import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../Provider/profile_provider.dart';
import '../../../Utils/custom_button.dart';
import '../../../Utils/custom_loading.dart';
import '../../../Utils/error_dialoge.dart';
import '../../auth/widgets/TextField.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key, this.id}) : super(key: key);
  String? id;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController changeNameController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    if (widget.id != null) {
      getData();
      changeNameController = TextEditingController(text: "");
    } else {
      changeNameController = TextEditingController(text: pro.profileName);
    }

    super.initState();
  }

  getData() async {
    DocumentSnapshot userInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .get();

    changeNameController = TextEditingController(text: userInfo["name"]);

    setState(() {});
  }

  validate() async {
    if (_formKey.currentState!.validate()) {
      try {
        buildLoadingIndicator(context);
        Provider.of<ProfileProvider>(context, listen: false)
            .updateProfileInfo(
          name: changeNameController.text,
          id: widget.id,
          context: context,
        ).then((value) async {
            Navigator.of(context, rootNavigator: true).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Profile updated successfully",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        );
      } catch (e) {
        return onError(context, "Having problem connecting to the server");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Edit Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.only(left: 25.w),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: 650.h,
          padding: EdgeInsets.all(32.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              const Spacer(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    customTextField(changeNameController, "Full name", context,
                        Icons.person_outline_rounded),

                    /*if (role == "Student" || role == "Moderator")
                      _buildContainer(
                          "Change Batch", changeBatchController, context),
                    if (role == "Student" || role == "Moderator")
                      _buildContainer(
                          "Change Section", changeSectionController, context),*/
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  validate();
                },
                child: customButton(
                    text: "Update",
                    width: 400,
                    height: 50,
                    color: Colors.black,
                    fontSize: 16.sp),
              ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
