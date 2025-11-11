import 'dart:async';
import 'package:candid_vendors/Screens/AuthScreens/CreateProfile.dart';
import 'package:candid_vendors/Services/APIs/Auth/AuthConnect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../BottomNavScreen.dart';
import '../../Services/APIs/Offers/OffersConnect.dart';
import '../../main.dart';

class VerifyMobileController extends GetxController {
  String vId = '';
  String message = '';
  int? reToken;
  bool isLoading = true;
  final String mobileNumber, countryCode;
  final bool isSignInProcess;
  GlobalKey<FormState> verifyPhoneFormKey = GlobalKey<FormState>();
  int secondsRemaining = 120;
  bool enableResend = false;
  late Timer timer;

  TextEditingController otp1Controller = TextEditingController(),
      otp2Controller = TextEditingController(),
      otp3Controller = TextEditingController(),
      otp4Controller = TextEditingController(),
      otp5Controller = TextEditingController(),
      otp6Controller = TextEditingController();

  final focus1 = FocusNode(), focus2 = FocusNode(), focus3 = FocusNode(),
      focus4 = FocusNode(), focus5 = FocusNode(), focus6 = FocusNode();

  VerifyMobileController({
    required this.mobileNumber,
    required this.isSignInProcess,
    required this.countryCode,
  });

  sendOTP() async {
    debugPrint('send OTP : mobileNumber : $mobileNumber');
    try {
      isLoading = true;
      startTimer();
      update();
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: mobileNumber,
        forceResendingToken: reToken,
        timeout: const Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await signInWithPhoneCred(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('verifyPhone: verificationFailed : $e');
          isLoading = false;
          update();
          if (e.code.contains('too-many-requests')) {
            utils.showSnackBar(e.message.toString());
          } else if (e.code == 'invalid-phone-number') {
            debugPrint('The provided phone number is not valid.');
            utils.showSnackBar('The provided phone number is not valid.');
          }
          utils.showSnackBar('Verification failed, try again later!');
        },
        codeSent: (String verificationId, int? resendToken) async {
          startTimer();
          debugPrint('verifyPhone: codeSent');
          utils.showSnackBar('OTP is sent!');
          isLoading = false;
          vId = verificationId;
          reToken = resendToken;
          update();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          vId = verificationId;
          isLoading = false;
          update();
          if (firebaseAuth.currentUser == null) {
            isLoading = false;
            update();
            debugPrint('verifyPhone: codeAutoRetrievalTimeout');
            utils.showSnackBar('Timeout, Try to re-send OTP');
          }
        },
      );
    } catch (e) {
      debugPrint('firebaseAuth.verifyPhoneNumber CATCh : E $e');
    }
  }

  signInWithPhoneCred(PhoneAuthCredential credential) async {
    UserCredential userCredential = (await firebaseAuth.signInWithCredential(credential));
    debugPrint('isSignInProcess: $isSignInProcess');
    debugPrint('isSignInProcess: ${userCredential.user}');
    debugPrint('isSignInProcess: ${userCredential.additionalUserInfo}');
    await AuthConnect().createSessionApi();
    if (userCredential.additionalUserInfo!.isNewUser) {
      isLoading = false;
      update();
      debugPrint('SIGN UP');
      Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(
          builder: (BuildContext context) => CreateProfile(
              mobileNumber: mobileNumber,
              user: userCredential.user!,
              countryCode: countryCode)));
    } else {
      debugPrint('SIGN IN');
      await AuthConnect()
          .loginRegisterAccount(mobileNumber: mobileNumber, isSignUp: false,message: message);
      isLoading = false;
      update();
      bottomNavController.changeSelectedIndex(0);
      await  await Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => const BottomNavScreen()),
            (route) => false,
      );
    }
  }

  verifyOTP() async {
    if (!verifyPhoneFormKey.currentState!.validate()) {
      utils.showSnackBar('Write OTP to process further!');
      return;
    } else {
      isLoading = true;
      update();
      String otp = '${otp1Controller.text}${otp2Controller.text}'
          '${otp3Controller.text}${otp4Controller.text}'
          '${otp5Controller.text}${otp6Controller.text}';
      try {
        await signInWithPhoneCred(
            PhoneAuthProvider.credential(verificationId: vId, smsCode: otp));
      } on FirebaseAuthException catch (e) {
        isLoading = false;
        update();
        debugPrint('E: Catch: ${e.message}');
        if (e.message!.contains('phone auth credential is invalid')) {
          utils.showSnackBar('Invalid OTP');
        } else if (e.message!.contains('The otp code has expired')) {
          utils.showSnackBar('Resend OTP due to OTP expired');
        } else {
          debugPrint('FirebaseAuthException: ${e.toString()}');
          utils.showSnackBar('Error: ${e.message}');
        }
      } catch (e) {
        isLoading = false;
        update();
        debugPrint('Exception: ${e.toString()}');
        utils.showSnackBar('Error: $e');
      }
    }
  }


  @override
  Future<void> onInit() async {
    super.onInit();
    await sendOTP();

  }

  onDisposeOrOnClose() async {
    debugPrint('Verify mobile controller, onDisposeOrOnClose | called!');
    timer.cancel();
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    otp5Controller.dispose();
    otp6Controller.dispose();

  }

  @override
  Future<void> dispose() async {
    await onDisposeOrOnClose();
    super.dispose();
  }

  @override
  Future<void> onClose() async {
    await onDisposeOrOnClose();
    super.onClose();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining!= 0) {
        secondsRemaining--;
        update();
      } else {
        enableResend = true;
        update();
      }
    });
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s)!= null;
  }
}