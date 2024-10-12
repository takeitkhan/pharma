import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/View/Profile/SubPage/ViewProfile.dart';
import 'package:provider/provider.dart';

import '../../../Provider/profile_provider.dart';
import '../../../Provider/search_provider.dart';
import '../../../Utils/custom_loading.dart';
import '../../Chat/Chat.dart';
import 'EditProfile.dart';

enum SampleItem { admin, driver, user }

class UserList extends StatefulWidget {
  UserList({Key? key, this.isAdminPanel}) : super(key: key);
  bool? isAdminPanel;

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final data = snapshot.data;
        return Consumer<SearchProvider>(
          builder: (context, provider, child) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                String name = data?.docs[index]["name"] ?? ""; // Fallback to empty string if name is null

                if (name
                    .toLowerCase()
                    .contains(provider.userSearchText.toLowerCase())) {
                  return _user(context, data, index, name, pro);
                }
                return const SizedBox();
              },
              itemCount: data?.size ?? 0, // Fallback to 0 if data is null
            );
          },
        );
      },
    );
  }

  Column _user(BuildContext context, QuerySnapshot<Object?>? data, int index, String name, ProfileProvider pro) {
    // Retrieve user data safely
    var userDoc = data?.docs[index].data() as Map<String, dynamic>?;

    // Check if the 'url' field exists and is not empty
    String avatarUrl = (userDoc != null && userDoc.containsKey("url") && userDoc["url"] != null && userDoc["url"] != "")
        ? userDoc["url"]
        : "assets/profile.jpg"; // Fallback to default asset image

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewProfile(id: data!.docs[index].id),
              ),
            );
          },
          child: Container(
            height: 30,
            width: 350,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 21,
                  backgroundImage: avatarUrl.startsWith("http")
                      ? NetworkImage(avatarUrl)
                      : AssetImage(avatarUrl) as ImageProvider<Object>, // Cast to ImageProvider for AssetImage
                ),
                SizedBox(width: 12.w),
                Text(
                  name.length > 13 ? '${name.substring(0, 13)}...' : name,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                Consumer<ProfileProvider>(
                  builder: (context, provider, child) {
                    return changeRole(userDoc?["role"] ?? "", index);
                  },
                ),
                SizedBox(width: 10.w),
                if (pro.role == "admin" || pro.role == "contractor")
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, size: 20.sp, color: Colors.black),
                    onSelected: (String value) {
                      if (data == null) return; // Handle null data

                      if (value == "delete") {
                        _deleteUser(data.docs[index].id); // Deleting the user
                      } else {
                        _changeUserRole(data.docs[index].id, value); // Changing user role
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      // Debug output
                      print('Current user role: ${pro.role}');
                      print('User role in doc: ${userDoc?["role"]}');

                      return [
                        if (userDoc?["role"] != "admin")
                          const PopupMenuItem<String>(
                            value: "admin",
                            child: Text("Change to Admin"),
                          ),
                        if (userDoc?["role"] != "contractor")
                          const PopupMenuItem<String>(
                            value: "contractor",
                            child: Text("Change to Contractor"),
                          ),
                        const PopupMenuItem<String>(
                          value: "delete",
                          child: Text("Delete User"),
                        ), // Added delete option
                      ];
                    },
                  )
                else
                  SizedBox(width: 40.w),
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 1,
        ),
      ],
    );
  }


  void _changeUserRole(String userId, String newRole) {
    // Function to update user role in Firestore
    FirebaseFirestore.instance.collection("users").doc(userId).update({
      'role': newRole,
    }).then((_) {
      // Optionally, show a success message or perform additional actions
      print("User role updated to $newRole");
    }).catchError((error) {
      // Handle error
      print("Failed to update role: $error");
    });
  }

  void _deleteUser(String userId) {
    // Function to delete user from Firestore
    FirebaseFirestore.instance.collection("users").doc(userId).delete().then((_) {
      // Optionally, show a success message or perform additional actions
      print("User deleted successfully");
    }).catchError((error) {
      // Handle error
      print("Failed to delete user: $error");
    });
  }


  Widget changeRole(String role, int index) {
    return Center(
      child: Text(
        role == "admin"
            ? "Admin"
            : role == "contractor"
            ? "Contractor"
            : "User",
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
