import 'package:candid_vendors/Services/APIs/VendorOutlet/VendorOutletConnect.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../Services/Collections/User/VendorUserColl.dart';
import '../../../main.dart';

class VendorOutletsListController extends GetxController {
  bool isLoading = true;
  late VendorUserColl vendor;

  VendorOutletsListController({required this.vendor});

  deleteOutletClickHandler({required String userOutletID}) async {
    try {
      isLoading = true;
      update();
      await VendorOutletConnect().updateVendorOutletsApi(
        changeType: 'remove',
        vendor: vendor,
        userOutletID: userOutletID,
        changedOutletCoordinates: {},
      );
      isLoading = false;
      update();
    } catch (e) {
      debugPrint('vendor outlets list delete | catch | $e');
      isLoading = false;
      update();
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    isar.vendorUserColls.watchLazy(fireImmediately: true).listen((event) async {
      try {
        vendor = await isar.vendorUserColls.buildQuery().findFirst();
        update();
      } catch (e) {
        debugPrint('outlet list | init listen | $e');
      }
    });
    isLoading = false;
    update();
  }
}
