import 'package:candid_vendors/main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import Firebase Auth

import '../../Screens/AuthScreens/VerifyNumber.dart';
import '../../Screens/AuthScreens/CreateProfile.dart';  // Import CreateProfile screen
import '../../BottomNavScreen.dart';
import '../../Services/APIs/Auth/AuthConnect.dart';  // Import BottomNavScreen

class LoginController extends GetxController {
  final List<String> list = <String>['IN +91'];
  bool isOtpSent = false;
  bool isLoading = false;
  String dropdownSelectedValue = 'IN +91';
  String mobileNumber = '';
  String email = '';
  String password = '';
  GlobalKey<FormState> loginRegisterFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> emailLoginFormKey = GlobalKey<FormState>();

  loginButtonPress(String mobileNumber) async {
    if (!loginRegisterFormKey.currentState!.validate()) {
      utils.showSnackBar('Please! write 10 digit mobile number to go forward');
      return;
    }
    await Future.delayed(const Duration(seconds: 6));
    isOtpSent = true;
    update();
    Navigator.of(navigatorKey.currentContext!).push(
      MaterialPageRoute(
        builder: (BuildContext context) => VerifyNumber(
          mobileNumber: mobileNumber,
          isSignInProcess: true,
          countryCode: dropdownSelectedValue,
        ),
      ),
    );
  }

  bool isRegisteredUser() {
    return mobileNumber == '1234567890' || email.isNotEmpty;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    bottomNavController.changeSelectedIndex(0);
    await checkLocationPermission();
    mobileNumber = '';
    email = '';
    password = '';
    update();
  }

  Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  updateMobileNumber(String mobile) {
    mobileNumber = mobile;
    update();
  }

  updateEmail(String newEmail) {
    email = newEmail;
    update();
  }

  updatePassword(String newPassword) {
    password = newPassword;
    update();
  }

  updatedDropDownSelectedValue(String val) {
    dropdownSelectedValue = val;
    update();
  }

  List<String> getCodeList() {
    return list;
  }
}
