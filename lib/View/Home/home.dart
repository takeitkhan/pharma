import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Provider/profile_provider.dart';
import '../Profile/SubPage/ProfileDetail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith(
              'https://leicestershire-rutland.communitypharmacy.org.uk/')) {
            return NavigationDecision.navigate;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(
        Uri.parse('https://leicestershire-rutland.communitypharmacy.org.uk/'));

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                if (!pro.isProfileComplete)
                  Container(
                    height: 50.h,
                    width: 360.w,
                    color: Colors.yellow,
                    child: Row(
                      children: [
                        SizedBox(width: 20.w),
                        Text(
                          "Please complete your profile",
                          style: GoogleFonts.lato( // Changed to Lato
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => ProfileDetails()));
                          },
                          child: Text(
                            "Start",
                            style: GoogleFonts.lato( // Changed to Lato
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w),
                      ],
                    ),
                  ),
                Expanded(child: WebViewWidget(controller: controller)),
              ],
            );
          },
        ),
      ),
    );
  }
}
