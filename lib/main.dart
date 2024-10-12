import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharma/Provider/chat_provider.dart';
import 'package:pharma/Provider/notice_provider.dart';
import 'package:pharma/Provider/post_provider.dart';
import 'package:pharma/Provider/search_provider.dart';
import 'package:pharma/Utils/push_notification.dart';
import 'package:pharma/View/Chat/HoldingPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Provider/authentication.dart';
import 'Provider/pharmacy_provider.dart';
import 'Provider/profile_provider.dart';
import 'Utils/app_colors.dart';
import 'View/Auth/Registration.dart';
import 'View/Auth/Signin.dart';
import 'View/Notices/SingleNotice.dart';
import 'View/profile/Profile.dart';
import 'FirebaseOptions.dart';
import 'initial.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {

    print("Some notification received");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //     apiKey: "AIzaSyAXuKthNAleNpyiIGEoOKyAKje9_2q1dS4",
  //     appId: "1:924871265359:android:361c37964409bff1e2ae3a",
  //     messagingSenderId: "924871265359",
  //     projectId: "pharma-d27ac",
  //   ),
  // );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // on background notification tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      if (message.notification!.title == "Pharma") {
        print("Background Notification Tapped for notice");
        navigatorKey.currentState!.pushNamed("/message", arguments: message);
      }else{
        print("Background Notification Tapped for chat");
        navigatorKey.currentState!.pushNamed("/holdingPage", arguments: message);
      }

    }
  });

  PushNotifications.init();
  PushNotifications.localNotiInit();

  // Listen to background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // to handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {
      if (message.notification!.title == "Pharma") {
        PushNotifications.showSimpleNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            payload: payloadData);
      }
    }
  });

  // for handling in terminated state
  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    print("Launched from terminated state");
    if (message.notification!.title == "Pharma"){
      Future.delayed(Duration(seconds: 1), () {
        navigatorKey.currentState!.pushNamed("/message", arguments: message);
      });
    }else{
      Future.delayed(Duration(seconds: 1), () {
        navigatorKey.currentState!.pushNamed("/holdingPage", arguments: message);
      });
    }

  }
  FirebaseMessaging.instance.subscribeToTopic("notice");
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PharmacyProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => NoticeProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: (context, child) {
          return MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'LU Bird',
              theme: _buildTheme(Brightness.light),
              home: const MiddleOfHomeAndSignIn(),
              routes: {
                "SignIn": (ctx) => const SignIn(),
                "Registration": (ctx) => const Registration(),
                "MiddleOfHomeAndSignIn": (ctx) => const MiddleOfHomeAndSignIn(),
                "Profile": (ctx) => const Profile(),
                "/message": (ctx) => const SingleNotice(),
                "/holdingPage": (ctx) => const HoldingPage(),
              });
        },
      ),
    );
  }
}

ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(
    brightness: brightness,
    primarySwatch: greenSwatch,
  );

  return baseTheme.copyWith(
    textTheme: GoogleFonts.montserratTextTheme(baseTheme.textTheme),
    primaryColor: const Color(0xff425C5A),
    scaffoldBackgroundColor: Colors.white,
  );
}
