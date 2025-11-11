import 'package:candid_vendors/Services/Collections/User/VendorUserColl.dart';
import 'package:candid_vendors/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../Utils/Utils.dart';

class UpdateProfile extends GetConnect {

  updateProfileApi(
      {required bool isProfileImgUpdateOnly,
      required Map<String, String> userData}) async {
    Response res = await post(
        '${Utils.apiUrl}/updateProfileByID',
        {
          'userPhone': (await utils.getUser() as VendorUserColl).userMobile1,
          'userData': userData,
        },
        headers: await utils.getHeaders());
    debugPrint('updateProfileApi | res.body : ${res.body}');
    if (res.statusCode != 200) {
      if (res.statusCode == 401) {
        utils.showSnackBar('session expired!');
        await utils.logOutUser();
      }
      debugPrint('updateProfileApi | res.statusCode : ${res.statusCode}');
      debugPrint('updateProfileApi | try again later!');
      throw res.body['message'] ?? 'Try again later!';
    }
    await isar.writeTxn(() async {
      final user =
          await isar.vendorUserColls.get((await utils.getUser() as VendorUserColl).id!);
      if (!isProfileImgUpdateOnly) {
        if (userData.containsKey('firebaseMessagingToken')) {
          user!.firebaseMessagingToken = userData['firebaseMessagingToken']!;
        } else {
          user!.userEmail1 = userData['userEmail1']!;
          user.userAddress = userData['userAddress']!;
          user.userMobile1 = userData['userMobile1']!;
        }
      } else {
        user!.userProfilePic = userData['userProfilePic']!;
      }
      await isar.vendorUserColls.put(user); // delete
    });
    Navigator.of(navigatorKey.currentContext!).pop();
    utils.showSnackBar(res.body['message']);
  }
}
