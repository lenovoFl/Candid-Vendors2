import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateProfileController extends GetxController {
  final String mobileNumber;
  final String countryCode;
  final User user;

  CreateProfileController({
    required this.mobileNumber,
    required this.user,
    required this.countryCode,
  });

  int selectedStep = 0;
  bool isLoading = false;
  bool isPaymentDone = false;

  // ---- Week Days ----
  List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  // ---- Shop Timing Data ----
  Map<String, Map<String, String>> shopTiming = {};

  /// Pick Time Function
  Future<void> pickTime(BuildContext context, int index, bool isOpen) async {
    final day = weekDays[index];
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      shopTiming[day] ??= {};
      shopTiming[day]![isOpen ? 'open' : 'close'] = picked.format(context);
      update();
    }
  }

  // ---- Stepper Controls ----
  void onStepContinue() {
    if (selectedStep < 2) {
      selectedStep++;
      update();
    } else {
      saveSellerData();
    }
  }

  void onStepCancel() {
    if (selectedStep > 0) {
      selectedStep--;
      update();
    }
  }

  void onStepTapped(int step) {
    selectedStep = step;
    update();
  }

  // ---- Save Shop Timing in Firestore ----
  Future<void> saveSellerData() async {
    isLoading = true;
    update();

    try {
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(user.uid)
          .set({
        'mobile': mobileNumber,
        'countryCode': countryCode,
        'shopTiming': shopTiming,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      Get.snackbar('Success', 'Shop timing saved successfully!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }

    isLoading = false;
    update();
  }
}
