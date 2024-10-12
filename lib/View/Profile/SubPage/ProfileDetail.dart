import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../Provider/profile_provider.dart';
import '../../../Utils/custom_loading.dart';
import '../../../Utils/error_dialoge.dart';
import '../../Auth/widgets/RoundButton.dart';
import '../../Auth/widgets/SnackBar.dart';

class ProfileDetails extends StatefulWidget {
  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  String roleDropdownValue = 'Community';
  String clinicalAreaDropdownValue = 'Diabetes type 1';
  String isIndependentPrescriber = 'No';
  String describeYouBest = 'Locum';

  TextEditingController otherRoleController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController GPHSRegistrationNoController = TextEditingController();
  TextEditingController otherDescriptionController = TextEditingController();
  List<String> bestDescribeList = [
    'Locum',
    'Pharmacy Owner',
    'Pharmacy Manager',
    'Relief Pharmacist',
    'Second Pharmacist',
  ];

  @override
  void initState() {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    print(pro.bestDescribe);
    print("++++++++++++++++++++++++++ pro.isProfileComplete");
    roleDropdownValue = pro.pharmacyRole ?? "Community";
    otherRoleController.text = pro.roleOther ?? "";
    numberController.text = pro.number ?? "";
    isIndependentPrescriber = pro.isIndependentPrescriber ?? "No";
    clinicalAreaDropdownValue =
        pro.clinicalArea == null || pro.clinicalArea!.isEmpty
            ? "Diabetes type 1"
            : pro.clinicalArea ?? "";
    GPHSRegistrationNoController.text = pro.GPHCNumber ?? "";
    describeYouBest = pro.bestDescribe == null
        ? "Locum"
        : bestDescribeList.contains(pro.bestDescribe)
            ? pro.bestDescribe!
            : "Other";
    otherDescriptionController.text = pro.bestDescribe == null
        ? ""
        : bestDescribeList.contains(pro.bestDescribe)
            ? ""
            : pro.bestDescribe!;
    setState(() {});
    super.initState();
  }

  validate() async {
    try {
      buildLoadingIndicator(context);

      Provider.of<ProfileProvider>(context, listen: false)
          .addAdditionalProfileInfo(
        role: roleDropdownValue,
        roleOther:
            roleDropdownValue == "Others" ? otherRoleController.text : "",
        number: numberController.text,
        isIndependentPrescriber: isIndependentPrescriber,
        clinicalArea:
            isIndependentPrescriber == "No" ? "" : clinicalAreaDropdownValue,
        GPHCNumber: isIndependentPrescriber == "No"
            ? ""
            : GPHSRegistrationNoController.text,
        bestDescribe: describeYouBest == "Other"
            ? otherDescriptionController.text
            : describeYouBest,
        context: context,
      )
          .then(
        (value) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Registration Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What's your role?",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: roleDropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    roleDropdownValue = newValue!;
                  });
                },
                items: <String>[
                  'Community',
                  'General practice',
                  'ICB',
                  'Secondary care',
                  'Others',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              if (roleDropdownValue == 'Others')
                TextFormField(
                  controller: otherRoleController,
                  decoration: InputDecoration(labelText: 'Other role'),
                ),
              SizedBox(height: 20.0),
              const Text(
                'Phone Number (Will not be used for marketing)',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: numberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Are you an independent prescriber?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Radio(
                    value: 'Yes',
                    groupValue: isIndependentPrescriber,
                    onChanged: (value) {
                      setState(() {
                        isIndependentPrescriber = value.toString();
                      });
                    },
                  ),
                  const Text('Yes'),
                  Radio(
                    value: 'No',
                    groupValue: isIndependentPrescriber,
                    onChanged: (value) {
                      setState(() {
                        isIndependentPrescriber = value.toString();
                      });
                    },
                  ),
                  const Text('No'),
                  Radio(
                    value: 'In Training',
                    groupValue: isIndependentPrescriber,
                    onChanged: (value) {
                      setState(() {
                        isIndependentPrescriber = value.toString();
                      });
                    },
                  ),
                  const Text('In Training'),
                ],
              ),
              if (isIndependentPrescriber == 'Yes' ||
                  isIndependentPrescriber == 'In Training')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Which clinical area?',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    DropdownButtonFormField<String>(
                      value: clinicalAreaDropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          clinicalAreaDropdownValue = newValue!;
                        });
                      },
                      items: <String>[
                        'Diabetes type 1',
                        'Diabetes type 2',
                        'Diabetes hypertension',
                        'COPD Asthma',
                        'Respiratory heart failure',
                        'AF Mental Health',
                        'Others',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    if (clinicalAreaDropdownValue == 'Others')
                      TextFormField(
                        controller: otherRoleController,
                        decoration: const InputDecoration(
                            labelText: 'Other clinical area'),
                      ),
                  ],
                ),
              const SizedBox(height: 20.0),
              const Text(
                'GPHC registration Number (if it is applicable to you)',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: GPHSRegistrationNoController,
                decoration:
                    const InputDecoration(labelText: 'GPHC registration No'),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Select what describe you the best',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 'Locum',
                        groupValue: describeYouBest,
                        onChanged: (value) {
                          setState(() {
                            describeYouBest = value.toString();
                          });
                        },
                      ),
                      Text('Locum'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Pharmacy Owner',
                        groupValue: describeYouBest,
                        onChanged: (value) {
                          setState(() {
                            describeYouBest = value.toString();
                          });
                        },
                      ),
                      Text('Pharmacy Owner'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Pharmacy Manager',
                        groupValue: describeYouBest,
                        onChanged: (value) {
                          setState(() {
                            describeYouBest = value.toString();
                          });
                        },
                      ),
                      const Text('Pharmacy Manager'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Relief Pharmacist',
                        groupValue: describeYouBest,
                        onChanged: (value) {
                          setState(() {
                            describeYouBest = value.toString();
                          });
                        },
                      ),
                      const Text('Relief Pharmacist'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Second Pharmacist',
                        groupValue: describeYouBest,
                        onChanged: (value) {
                          setState(() {
                            describeYouBest = value.toString();
                          });
                        },
                      ),
                      const Text('Second Pharmacist'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Other',
                        groupValue: describeYouBest,
                        onChanged: (value) {
                          setState(() {
                            describeYouBest = value.toString();
                          });
                        },
                      ),
                      Text('Other'),
                    ],
                  )
                ],
              ),
              if (describeYouBest == 'Other')
                TextFormField(
                  controller: otherDescriptionController,
                  decoration: InputDecoration(labelText: 'Other description'),
                ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  if (true /*true_formKey.currentState!.validate()*/) {
                    // If the form is valid, display all the values
                    if (roleDropdownValue == "Others" &&
                        otherRoleController.text.isEmpty) {
                      snackBar(context, "Please enter role");
                      return;
                    }
                    if (numberController.text.isEmpty) {
                      snackBar(context, "Please enter your number");
                      return;
                    }
                    if (isIndependentPrescriber == "Yes" &&
                        numberController.text.isEmpty) {
                      snackBar(context, "Please enter your number");
                      return;
                    }

                    final RegExp regex = RegExp(r'^[+-]?[0-9]+$');
                    if (!regex.hasMatch(numberController.text)) {
                      snackBar(context,
                          "Number can contain only digits and + symbol");
                      return;
                    }

                    validate();

                    print('Role: $roleDropdownValue');
                    print('Role: ${otherRoleController.text}');
                    print('Phone Number: ${numberController.text}');
                    print('Independent Prescriber: $isIndependentPrescriber');
                    if (isIndependentPrescriber == 'Yes' ||
                        isIndependentPrescriber == 'In Training') {
                      print('Clinical Area: $clinicalAreaDropdownValue');
                      if (clinicalAreaDropdownValue == 'Others') {
                        print(
                            'Other Clinical Area: ${otherRoleController.text}');
                      }
                    }
                    print(
                        'GPHC Registration No: ${GPHSRegistrationNoController.text}');
                    print('Describe Best: $describeYouBest');
                    if (describeYouBest == 'Other') {
                      print(
                          'Other Description: ${otherDescriptionController.text}');
                    }
                  }
                },
                child: roundedButton("Submit"),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
