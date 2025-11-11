import 'package:candid_vendors/Controllers/Offers/CreateOfferController.dart';
import 'package:candid_vendors/Controllers/Profile/ProfileController.dart';
import 'package:candid_vendors/Services/Collections/VendorPolicy/VendorPolicyColl.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

import '../../../Utils/Utils.dart';
import '../../../main.dart';

class PoliciesConnect extends GetConnect {

  Future<void> updateVendorPolicyByPhoneApi({
    required String selectedTCFor,
    required String selectedTCText,
    required ProfileController profileController,
    VendorPolicyColl? vendorPolicyColl,
  }) async {
    if (selectedTCText.length < 3) {
      utils.showSnackBar('Min 3 letters required!');
      return;
    }
    profileController.isLoading = true;
    profileController.update();
    vendorPolicyColl = await isar.vendorPolicyColls.where().build().findFirst();
    var body = {
      'selectedTCFor': selectedTCFor.toLowerCase(),
      'selectedTCText': selectedTCText,
    };

    Response res = await post('${Utils.apiUrl}/updateVendorPolicyByPhone', body,
        headers: await utils.getHeaders());
    debugPrint('updateVendorPolicyByPhoneApi res.statusCode | ${res.statusCode}');
    debugPrint('updateVendorPolicyByPhoneApi res.body | ${res.body}');
    if (res.statusCode == 401) {
      await utils.logOutUser();
    }
    if (res.statusCode == 200) {
      vendorPolicyColl ??= VendorPolicyColl(
          vendorWarrantyPolicy: selectedTCFor.toLowerCase().contains('warranty') == true
              ? selectedTCText
              : "",
          vendorRefundPolicy: selectedTCFor.toLowerCase().contains('refund') == true
              ? selectedTCText
              : "",
          vendorDelivery: selectedTCFor.toLowerCase().contains('delivery') == true
              ? selectedTCText
              : "",
          vendorPaymentPolicy:
              selectedTCFor.toLowerCase().contains('cod') == true ? selectedTCText : "",
          vendorOtherPolicy: selectedTCFor.toLowerCase().contains('other') == true
              ? selectedTCText
              : "");
      if (selectedTCFor.toLowerCase().contains('warranty')) {
        vendorPolicyColl.vendorWarrantyPolicy = selectedTCText;
      } else if (selectedTCFor.toLowerCase().contains('refund')) {
        vendorPolicyColl.vendorRefundPolicy = selectedTCText;
      } else if (selectedTCFor.toLowerCase().contains('delivery')) {
        vendorPolicyColl.vendorDelivery = selectedTCText;
      } else if (selectedTCFor.toLowerCase().contains('cod')) {
        vendorPolicyColl.vendorPaymentPolicy = selectedTCText;
      } else if (selectedTCFor.toLowerCase().contains('other')) {
        vendorPolicyColl.vendorOtherPolicy = selectedTCText;
      }
      await isar.writeTxn(() async {
        await isar.vendorPolicyColls.put(vendorPolicyColl!);
      });
      utils.showSnackBar(res.body['message'] ?? '');
    }
    profileController.isLoading = false;
    profileController.vendorPolicyColl = vendorPolicyColl;
    profileController.update();
    Navigator.of(navigatorKey.currentContext!).pop();
  }
}
