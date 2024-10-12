import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharma/Utils/fcode.dart';
import 'package:pharma/View/Auth/widgets/PageIndicator.dart';
import 'package:pharma/View/Auth/widgets/RoundButton.dart';
import 'package:pharma/View/Auth/widgets/SnackBar.dart';
import 'package:pharma/View/Auth/widgets/SwitchPage.dart';
import 'package:pharma/View/Auth/widgets/TextField.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Provider/authentication.dart';
import '../../Utils/custom_loading.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController fcodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;

  @override
  void dispose() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    fcodeController.clear();
    super.dispose();
  }

  validate() async {
    if (isChecked) {
      if (!_formKey.currentState!.validate()) {
        print("invalid *------------------------");
        return;
      }
      if (confirmPasswordController.text != passwordController.text) {
        snackBar(context, "Password does not match");
        return;
      }
      if (!fcodeList.contains(fcodeController.text)) {
        snackBar(context, "Invalid ODS id");
        return;
      }
    }
    if (_formKey.currentState!.validate()) {
      try {
        if (confirmPasswordController.text != passwordController.text) {
          snackBar(context, "Password does not match");
          return;
        }
        buildLoadingIndicator(context);
        Provider.of<Authentication>(context, listen: false)
            .signUp(
              name: nameController.text,
              email: emailController.text,
              password: passwordController.text,
              fCode: fcodeController.text.isEmpty ? "" : fcodeController.text,
              context: context,
            ).then((value) async {
          if (value != "Success") {
            snackBar(context, value);
          } else {
            final User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              user.sendEmailVerification();
            }
          }
        });
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        snackBar(context, "Some error occur");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(30.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 45.h),
              SizedBox(
                height: 150.h,
                child: Image.asset("assets/site_logo.jpeg"),
              ),
              SizedBox(height: 40.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    customTextField(nameController, "Full name", context,
                        Icons.person_outline_rounded),
                    SizedBox(height: 20.h),
                    customTextField(emailController, "NHS email", context,
                        Icons.email_outlined),
                    SizedBox(height: 20.h),
                    customTextField(passwordController, "Password", context,
                        Icons.lock_outline_rounded),
                    SizedBox(height: 20.h),
                    customTextField(
                        confirmPasswordController,
                        "Confirm Password",
                        context,
                        Icons.lock_outline_rounded),
                    SizedBox(height: 20.h),
                    switchPageButton(
                        "Already Have An Account? ", "Log In", context),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Text(
                          "Are you a contractor?",
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: Theme.of(context).primaryColor),
                        ),
                        Checkbox(
                          tristate: true,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value ?? false;
                            });
                          },
                        ),
                        Text(
                          "Yes",
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                    if (isChecked)
                      Row(
                        children: [
                          Text(
                            "Please provide your ODS code.",
                            style: TextStyle(
                                fontSize: 13.sp,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    if (isChecked) SizedBox(height: 20.h),
                    if (isChecked)
                      customTextField(fcodeController, "ODS Code", context,
                          Icons.password_outlined),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  validate();
                },
                child: roundedButton("Register"),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
