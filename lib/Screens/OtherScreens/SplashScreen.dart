import 'package:candid_vendors/Screens/AuthScreens/CreateProfile.dart';
import 'package:candid_vendors/Services/Collections/User/VendorUserColl.dart';
import 'package:candid_vendors/main.dart';
import 'package:flutter/material.dart';

import '../../BottomNavScreen.dart';
import '../AuthScreens/LoginScreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () async {
      VendorUserColl? vendor = (await utils.getUser());
      utils.getUser().then((user) =>
          Navigator.of(navigatorKey.currentContext!).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => user != null
                  ?const BottomNavScreen()
                  : firebaseAuth.currentUser == null || vendor == null
                      ? const LoginScreen()
                      : CreateProfile(
                          mobileNumber: '',
                          user: firebaseAuth.currentUser!,
                        ))));
    });
    return const Image(
      image: AssetImage('lib/Images/SpashScreen1.png'),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.fill,
    );
  }
}
