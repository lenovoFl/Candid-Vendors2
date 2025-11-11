import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Services/Collections/User/VendorUserColl.dart';
import '../main.dart';

class BottomNavController extends GetxController {
  int selectedIndex = 0;
  int drawerIndex = 0;

  late VendorUserColl vendor;

  @override
  Future<void> onInit() async {
    super.onInit();
    // Initialize vendor user collection
    var user = await utils.getUser();
    if (user != null) {
      vendor = user as VendorUserColl;
    } else {
      utils.showSnackBar('User data is not available');
    }
  }

  Future<bool> fetchIsActiveStatus() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('candidVendors')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    return userDoc['isActive'] ?? false;
  }

  void changeSelectedIndex(int index) async {
    if (index == 2) {
      bool isActive = await fetchIsActiveStatus();
      if (isActive) {
        if (selectedIndex != index) {
          selectedIndex = index;
          update(); // Ensure this triggers the UI update
        }
      } else {
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Card(
                color: Colors.white,
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'lib/Images/stores.png',
                          width: 100,
                          height: 50,
                        ),
                      ],
                    ),
                    const ListTile(
                      title: Text('Profile Under Review'),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Your profile has been submitted for review. '
                            'Once your profile is approved by Candid Offers, you can create an offer.',
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.black,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    } else {
      if (selectedIndex != index) {
        selectedIndex = index;
        update(); // Ensure this triggers the UI update
      }
    }
  }

  void changeDrawerIndex(int index) {
    Future.delayed(
      const Duration(milliseconds: 0), // Adjust delay if necessary
          () {
        drawerIndex = index;
        update();
      },
    );
  }

  @override
  Future<void> dispose() async {
    await firebaseCrashlytics.sendUnsentReports();
    super.dispose();
  }

  @override
  Future<void> onClose() async {
    await firebaseCrashlytics.sendUnsentReports();
    super.onClose();
  }
}
