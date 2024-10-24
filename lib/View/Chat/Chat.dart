import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/Utils/app_colors.dart';
import 'package:pharma/View/Chat/widgets/BuildAllChats.dart';
import 'package:provider/provider.dart';

import '../../Provider/chat_provider.dart';
import '../../Provider/profile_provider.dart';

class Chat extends StatefulWidget {
  const Chat({
    Key? key,
    required this.name,
    required this.url,
    required this.uid,
    required this.token,
    this.isFromNotification,
  }) : super(key: key);

  final String name;
  final String url;
  final bool? isFromNotification;
  final String token;
  final String uid;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    var pro = Provider.of<ChatProvider>(context, listen: false);
    var pro2 = Provider.of<ProfileProvider>(context, listen: false);
    pro.createChatRoom(pro2.currentUserUid, widget.uid, pro2.profileUrl,
        widget.url, pro2.profileName, widget.name);
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: GoogleFonts.lato(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h), // Adjust the height as needed
          // buildChatTop(context, widget.name, widget.url, isFromNotification: widget.isFromNotification),
          buildAllChats(pro, widget.uid),
          Consumer<ChatProvider>(
            builder: (context, provider, child) {
              return Container(
                margin: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 20.h),
                height: 60.h,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 10,
                      )
                    ],
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: GoogleFonts.lato(color: Colors.black),
                          controller: _controller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            hintText: 'Type a message',
                            hintStyle: GoogleFonts.lato(color: Colors.grey),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            provider.addMessage(
                              message: _controller.text,
                              myUid: pro.currentUserUid,
                              receiverUid: widget.uid,
                              token: widget.token,
                              senderName: pro.profileName,
                            );
                            _controller.clear();
                          }
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Icon(
                          FontAwesomeIcons.paperPlane,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
