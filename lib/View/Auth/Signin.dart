import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharma/View/Auth/widgets/PageIndicator.dart';
import 'package:pharma/View/Auth/widgets/RoundButton.dart';
import 'package:pharma/View/Auth/widgets/SnackBar.dart';
import 'package:pharma/View/Auth/widgets/SwitchPage.dart';
import 'package:pharma/View/Auth/widgets/TextField.dart';
import 'package:provider/provider.dart';
import '../../Provider/authentication.dart';
import '../../Utils/custom_loading.dart';
import 'ForgotPassword.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    super.dispose();
  }

  validate() async {
    if (_formKey.currentState!.validate()) {
      try {
        buildLoadingIndicator(context);
        Provider.of<Authentication>(context, listen: false)
            .signIn(emailController.text, passwordController.text, context)
            .then(
          (value) {
            Navigator.of(context, rootNavigator: true).pop();
            if (value != "Success") {
              snackBar(context, value);
            } else {
              Navigator.of(context)
                  .pushReplacementNamed("MiddleOfHomeAndSignIn");
            }
          },
        );
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
        child: SizedBox(
          height: 610.h,
          width: 360.w,
          child: Padding(
            padding: EdgeInsets.all(30.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 45.h),
                // Centered and resized logo
                Center(
                  child: Image.asset(
                    "assets/site_logo.jpeg",
                    width: 150.w,  // Adjusted width
                    height: 150.h, // Adjusted height
                  ),
                ),
                SizedBox(height: 30.h), // Space between logo and email field

                // Form with email and password fields
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      customTextField(emailController, "Enter your email",
                          context, Icons.email_outlined),
                      SizedBox(height: 25.h),
                      customTextField(passwordController, "Password", context,
                          Icons.lock_outline_rounded),
                    ],
                  ),
                ),
                SizedBox(height: 17.h),

                // Reduced height for the gap between register button and sign in button
                switchPageButton("New Member? ", "Register now", context),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    validate();
                  },
                  child: roundedButton("Sign in"),
                ),
                SizedBox(height: 10.h), // Reduced height for the gap
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialogBox();
                            });
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
