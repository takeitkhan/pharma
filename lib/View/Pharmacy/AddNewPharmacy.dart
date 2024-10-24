import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/Utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../Provider/pharmacy_provider.dart';
import '../../Utils/custom_loading.dart';

class AddNewPharmacy extends StatefulWidget {
  AddNewPharmacy({Key? key, this.documentSnapshot}) : super(key: key);

  final DocumentSnapshot? documentSnapshot;

  @override
  _AddNewPharmacyState createState() => _AddNewPharmacyState();
}

class _AddNewPharmacyState extends State<AddNewPharmacy> {
  late TextEditingController pharmacyNameController;
  late TextEditingController descriptionController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    pharmacyNameController = TextEditingController();
    addressController = TextEditingController();
    descriptionController = TextEditingController();

    if (widget.documentSnapshot != null) {
      pharmacyNameController.text = widget.documentSnapshot!["pharmacyName"];
      addressController.text = widget.documentSnapshot!["address"];
      descriptionController.text = widget.documentSnapshot!["description"];
    }
  }

  Future<void> uploadPharmacy() async {
    try {
      buildLoadingIndicator(context); // Show loading indicator
      await Provider.of<PharmacyProvider>(context, listen: false).addNewPharmacy(
        pharmacyName: pharmacyNameController.text,
        address: addressController.text,
        description: descriptionController.text,
        dateTime: DateTime.now().toString(),
        context: context,
      );

      // Dismiss the loading indicator
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Pharmacy added successfully"),
          duration: Duration(seconds: 2),
        ),
      );

      // Go back to the previous page
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop(); // Hide loading indicator on error
      // Show error message
      // Show success message using AlertDialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Success"),
          content: Text("Pharmacy added successfully"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Go back to the previous page
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }



  Future<void> updatePharmacy() async {
    try {
      buildLoadingIndicator(context);
      await Provider.of<PharmacyProvider>(context, listen: false).updatePharmacy(
        pharmacyName: pharmacyNameController.text,
        address: addressController.text,
        description: descriptionController.text,
        id: widget.documentSnapshot!.id,
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
          widget.documentSnapshot == null ? 'Add Pharmacy' : 'Update Pharmacy',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField(pharmacyNameController, "Pharmacy Name"),
              SizedBox(height: 10.h),
              buildTextField(addressController, "Pharmacy Address"),
              SizedBox(height: 10.h),
              buildTextField(descriptionController, "Pharmacy Details", maxLine: 6),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  if (pharmacyNameController.text.isEmpty ||
                      addressController.text.isEmpty ||
                      descriptionController.text.isEmpty) {
                    // Show error message
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Error"),
                        content: Text("Please fill in all fields."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    if (widget.documentSnapshot == null) {
                      uploadPharmacy();
                    } else {
                      updatePharmacy();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: semiBlack, // Use your secondary color
                ),
                child: Text(
                  widget.documentSnapshot == null ? "Create Pharmacy" : "Update Pharmacy",
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

  Padding buildTextField(TextEditingController controller, String label, {int maxLine = 1}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: TextField(
        maxLines: maxLine,
        controller: controller,
        decoration: InputDecoration(
          fillColor: Color(0xffC4C4C4).withOpacity(0.2),
          filled: true,
          hintText: label,
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
