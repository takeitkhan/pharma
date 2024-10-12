import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/View/Auth/widgets/SnackBar.dart';
import 'package:pharma/View/Auth/widgets/TextField.dart';
import 'package:provider/provider.dart';
import '../../Provider/authentication.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/custom_loading.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AddPharmacists extends StatefulWidget {
  AddPharmacists({Key? key, required this.pharmacyId}) : super(key: key);

  final String pharmacyId;

  @override
  State<AddPharmacists> createState() => _AddPharmacistsState();
}

class _AddPharmacistsState extends State<AddPharmacists> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    super.dispose();
  }

  validate() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Check if email already exists
        var userSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: emailController.text)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          // Email already registered, open invite form
          _showInviteForm();
        } else {
          // Create new user
          buildLoadingIndicator(context);
          Provider.of<Authentication>(context, listen: false)
              .createUser(
                  name: nameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  department: "change it",
                  context: context,
                  isRegistration: false,
                  pharmacyId: widget.pharmacyId)
              .then((value) async {
            if (value != "Success") {
              snackBar(context, value);
            } else {
              Navigator.of(context).pop();
              snackBar(context, "Pharmacist created");
              _showMyDialog(
                  context, emailController.text, passwordController.text);
            }
          });
        }
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        snackBar(context, "Some error occurred");
      }
    }
  }

  void _showInviteForm() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController inviteNameController =
        TextEditingController(text: nameController.text);

        return AlertDialog(
          title: Text(
              'User with this email already exists. Add them to this Pharmacy? The password will remain unchanged.',
              style: GoogleFonts.lato(
                fontSize: 15.sp,
                color: semiBlack,
              )),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: inviteNameController,
                    decoration: InputDecoration(labelText: 'Full Name'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'NHS Email'),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            // Close Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Close',
                style: TextStyle(
                  color: Colors.white, // Text color white
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: semiBlack, // Background color semiBlack
                alignment: Alignment.centerLeft, // Left alignment
              ),
            ),
            // Add Now Button
            TextButton(
              child: Text('Add Now'),
              onPressed: () async {
                String email = emailController.text;
                String name = inviteNameController.text;

                try {
                  // Query Firestore to find user by email
                  QuerySnapshot userSnapshot = await FirebaseFirestore.instance
                      .collection("users")
                      .where("email", isEqualTo: email)
                      .get();

                  if (userSnapshot.docs.isNotEmpty) {
                    // Get the first document (assuming email is unique)
                    String userId = userSnapshot.docs.first.id;

                    // Add user to the pharmacy collection
                    await FirebaseFirestore.instance
                        .collection("pharmacy")
                        .doc(widget.pharmacyId)
                        .collection("pharmacies")
                        .add({"pharmaciesId": userId});

                    Navigator.of(context).pop();
                    snackBar(context, "User $email added to the pharmacy.");
                  } else {
                    // If the user does not exist, you can choose to invite them
                    UserCredential credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email,
                      password: 'tempPassword123',
                      // You can set a temporary password
                    );

                    // Send email verification
                    await credential.user!.sendEmailVerification();

                    // Store user data in Firestore
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(credential.user!.uid)
                        .set({
                          "name": name,
                          "email": credential.user!.email,
                          "url": "",
                          "role": "",
                          "token": "",
                        });

                    // Add user to the pharmacy collection
                    await FirebaseFirestore.instance
                        .collection("pharmacy")
                        .doc(widget.pharmacyId)
                        .collection("pharmacies")
                        .add({"pharmaciesId": credential.user!.uid});

                    Navigator.of(context).pop();
                    snackBar(context, "Invitation sent to $email");
                  }
                } catch (e) {
                  Navigator.of(context).pop();
                  snackBar(context, "Failed to send invitation: $e");
                }
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Add Pharmacist',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(15.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTextField(
                      nameController,
                      "Full Name",
                      context,
                      Icons.person_outline_rounded,
                    ),
                    SizedBox(height: 15.h),
                    customTextField(
                      emailController,
                      "NHS Email",
                      context,
                      Icons.email_outlined,
                    ),
                    SizedBox(height: 15.h),
                    customTextField(
                      passwordController,
                      "Password",
                      context,
                      Icons.lock_outline_rounded,
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildButton("Create", validate),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Color(0xFFF0F0F0),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          color: Color(0xFF4A4A4A),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(
      BuildContext context, String email, String pass) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share Credential'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('How do you want to share credentials?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Other Options'),
              onPressed: () {
                Share.share(
                  'Email: $email\nPassword: $pass',
                  subject: 'Auth Credential',
                );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send Email'),
              onPressed: () {
                try {
                  String? encodeQueryParameters(Map<String, String> params) {
                    return params.entries
                        .map((MapEntry<String, String> e) =>
                            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                        .join('&');
                  }

                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: email,
                    query: encodeQueryParameters(<String, String>{
                      'subject': 'Auth Credential',
                      'body': 'Email: $email\nPassword: $pass'
                    }),
                  );

                  launchUrl(emailLaunchUri);
                } catch (e) {
                  print("--------------------------------");
                  print(e);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
