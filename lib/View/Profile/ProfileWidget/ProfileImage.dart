import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../../Provider/profile_provider.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return SizedBox(
      height: size.height * 0.18,
      width: size.height * 0.155,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 4.0,
              ),
            ),
            height: size.height * 0.155,
            width: size.height * 0.155,
            child: buildClipRRect(pro, context),
          ),
          /*Positioned(
            right: 5.sp,
            bottom: 22.sp,
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        blurRadius: 3,
                        offset: const Offset(3, 3), // Shadow position
                      ),
                    ]),
                child: InkWell(
                  onTap: () {
                    pickImage(context);
                  },
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  ClipRRect buildClipRRect(ProfileProvider pro, BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: pro.profileUrl != ""
          ? CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 21,
            backgroundImage: NetworkImage(
              pro.profileUrl,
            ),
          )
          : const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 21,
              backgroundImage: AssetImage("assets/profile.jpg"),
            ),
    );
  }
}
