import 'dart:io';

import 'package:candid_vendors/Controllers/HomeScreenController.dart';
import 'package:candid_vendors/Screens/OtherScreens/SplashScreen.dart';
import 'package:candid_vendors/Services/Collections/App/AppDataColl.dart';
import 'package:candid_vendors/Services/Collections/User/VendorUserColl.dart';
import 'package:candid_vendors/Utils/MyWidgets.dart';
import 'package:candid_vendors/Utils/Utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';

import 'Controllers/BottomNavController.dart';
import 'Controllers/Notification/NotificationController.dart';

final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'navigatorKey');
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
final FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.instance;
final FirebasePerformance firebasePerformance = FirebasePerformance.instance;
final FirebaseCrashlytics firebaseCrashlytics = FirebaseCrashlytics.instance;
final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
final FirebaseDynamicLinks firebaseDynamicLinks = FirebaseDynamicLinks.instance;
final BottomNavController bottomNavController = BottomNavController();
final HomeScreenController homeScreenController = HomeScreenController();
final NotificationController notificationController = NotificationController();
late final Isar isar;
//final razorPayKey = dotenv.get("RAZOR_KEY") ?? "fallback_key";
//final razorPaySecret = dotenv.get("RAZOR_SECRET") ?? "fallback_secret";
final Utils utils = Utils();
final MyWidgets myWidgets = MyWidgets();
intiateRazorPay() {
  // TODO: implement intiateRazorPay
  throw UnimplementedError();
}
late VendorUserColl localSeller;
late AppDataColl localAppData;
late Directory dir;

Future<void> main() async {
//  dotenv.load(fileName: "lib/.env");

  await utils.initRunCode();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: myWidgets.navDrawerItems.map((item) {
          return ListTile(
            title: Text(item['title']),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              if (item['screen'] != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => item['screen']));
              }
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Candid Sellers',
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue, // Use Colors.blue instead of Colors.blue.shade900
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            scaffoldBackgroundColor: const Color(0xFFF9F9F9), // Set Scaffold background color to #F9F9F9
            cardColor: Colors.white,
            cardTheme: const CardTheme(
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          home: const Scaffold(
        //    drawer: buildDrawer(context),
            body: SplashScreen(),
          ),
          builder: (context, widget) {
            Widget error = const Text('...rendering error...');
            if (widget is Scaffold || widget is Navigator) {
              error = Scaffold(body: Center(child: error));
            }
            ErrorWidget.builder = (errorDetails) => error;
            if (widget != null) return widget;
            throw ('widget is null');
          },
        );
      },
    );
  }
}
