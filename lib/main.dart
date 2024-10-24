import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Background Notification received: ${message.notification!.title}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Background Notification Tapped: ${message.notification!.title}");
      navigatorKey.currentState!.pushNamed(
        "/message",
        arguments: message,
      );
    }
  });

  PushNotifications.init();
  PushNotifications.localNotiInit();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      PushNotifications.showSimpleNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
        payload: jsonEncode(message.data),
      );
    }
  });

  final RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    print("Launched from terminated state");
    navigatorKey.currentState!.pushNamed("/message", arguments: message);
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
            },
          );
        },
      ),
    );
  }
}

Future<void> storeTokenInFirestore(String userId, String token) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'device_token': token,
    }, SetOptions(merge: true));
  } catch (e) {
    print('Error storing token: $e');
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
