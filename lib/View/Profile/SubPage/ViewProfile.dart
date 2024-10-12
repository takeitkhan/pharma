import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharma/View/Profile/ProfileWidget/ProfileImage.dart';
import 'package:provider/provider.dart';
import '../../../Provider/profile_provider.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/custom_loading.dart';
import '../../Auth/widgets/SnackBar.dart';
import '../../Chat/Chat.dart';

class ViewProfile extends StatefulWidget {
  ViewProfile({Key? key, required this.id}) : super(key: key);
  String id;

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  bool isLoading = true;
  var data;

  getInfo() async {
    try {
      data = await Provider.of<ProfileProvider>(context, listen: false)
          .getProfileInfoByUID(widget.id);

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (err) {
      snackBar(context, "Some error occur");
    }
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var pro = Provider.of<ProfileProvider>(context, listen: false);

    return Scaffold(
      body: isLoading
          ? buildLoadingWidget()
          : SingleChildScrollView(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        height: size.height * 0.21,
                        color: Colors.white,
                      ),
                      Container(
                        height: size.height - size.height * 0.21,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                    ],
                  ),
                  topWidget(size, pro, context, data)
                ],
              ),
            ),
    );
  }
}

Widget topWidget(
    Size size, ProfileProvider pro, BuildContext context, var data) {
  bool showDetail = true;
  try {
    data['roleOther'];
  } catch (e) {
    showDetail = false;
  }

  return SingleChildScrollView(
    child: SizedBox(
      height: 800.h,
      width: 360.w,
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.12,
          ),
          const ProfileImage(),
          Consumer<ProfileProvider>(builder: (_, __, ___) {
            return Text(
              data['name'],
              style: TextStyle(
                fontSize: 23.sp,
                fontWeight: FontWeight.bold,
              ),
            );
          }),

          const SizedBox(height: 10),
          Text(
            data['email'],
            style: TextStyle(fontSize: 13.sp, color: Colors.grey),
          ),

          const SizedBox(height: 10),
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Chat(
                        name: data["name"],
                        url: data["url"],
                        token: data["token"],
                        uid: data.id,
                      ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email, color: primaryColor,),
                SizedBox(width: 10.w),
                Text(
                  "Send Message",
                  style: TextStyle(fontSize: 13.sp, color: primaryColor),
                ),
              ],
            ),
          ),

          Consumer<ProfileProvider>(builder: (_, __, ___) {
            return Expanded(
              child: showDetail
                  ? ListView(
                      children: [
                        _profileList(
                            "Role: ",
                            data['roleOther'] == ""
                                ? data['pharmacyRole']
                                : data['roleOther']),
                        _profileList("Number: ", data['number']),
                        _profileList("Is Independent Prescriber: ",
                            data['isIndependentPrescriber']),
                        if (data['clinicalArea'] != "")
                          _profileList("Clinical Area: ", data['clinicalArea']),
                        if (data['GPHCNumber'] != "")
                          _profileList("GPHC Number: ", data['GPHCNumber']),
                        _profileList(
                            "Describe Me Best: ", data['bestDescribe']),
                      ],
                    )
                  : const Center(child: Text("No detail available")),
            );
          }),

          //const SizedBox(height: 55),
        ],
      ),
    ),
  );
}

Widget _profileList(String text, String value) {
  return Padding(
    padding: EdgeInsets.fromLTRB(25.w, 5.h, 25.w, 0),
    child: Column(
      children: [
        Row(
          children: [

            Text(
              text,
              style: TextStyle(
                  color: const Color(0xff383840),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                  color: const Color(0xff383840),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Divider(
          color: primaryColor.withOpacity(0.1),
        )
      ],
    ),
  );
}
