import 'package:candid_vendors/Services/Collections/User/VendorUserColl.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../Utils/Utils.dart';
import '../../../main.dart';

class VendorOutletConnect extends GetConnect {
  Future<void> updateVendorOutletsApi({
    required String changeType,
    required Map<String, dynamic> changedOutletCoordinates,
    required VendorUserColl vendor,
    String? userOutletID,
  }) async {
    try {
      var body = userOutletID == null
          ? {
        'changeType': changeType,
        'changedOutletCoordinates': changedOutletCoordinates,
      }
          : {
        'changeType': changeType,
        'changedOutletCoordinates': changedOutletCoordinates,
        'docID': userOutletID,
      };

      Response response = await post(
        '${Utils.apiUrl}/updateVendorOutlets',
        body,
        headers: await utils.getHeaders(),
      );

      debugPrint('response statusCode: ${response.statusCode}');
      debugPrint('response body: ${response.body}');

      if (response.statusCode == 401) {
        utils.showSnackBar('session expired!');
        await utils.logOutUser();
        throw 'session expired!';
      } else if (response.statusCode == 200) {
        // Assuming 'message' is present in the response body
        utils.showSnackBar(response.body['message']);

        // Update the local data only if the changeType is 'add' or 'update'
        if (changeType.contains('add') || changeType.contains('update')) {
          await isar.writeTxn(() async {
            List<Outlet> myOutletList = [...vendor.myOutlets];
            myOutletList.removeWhere(
                    (outlet) => outlet.userOutletID == userOutletID);
            myOutletList.add(Outlet(
              userOutletID: response.body['userOutletID'],
            //  storeName: changedOutletCoordinates['userstoreName'],
              userOutletAddressBuildingStreetArea:
              changedOutletCoordinates['userOutletAddressBuildingStreetArea'],
              userOutletAddressPinCode:
              changedOutletCoordinates['userOutletAddressPinCode'],
              userOutletAddressCity:
              changedOutletCoordinates['userOutletAddressCity'],
              userOutletAddress2:
              changedOutletCoordinates['userOutletAddress2'],
              userOutletAddress1:
              changedOutletCoordinates['userOutletAddress1'],
              lat: changedOutletCoordinates['lat'],
              long: changedOutletCoordinates['long'],
              userOutletAddressState:
              changedOutletCoordinates['userOutletAddressState'],
            ));

            vendor.myOutlets = myOutletList;
            await isar.vendorUserColls.put(vendor);
          });
        }

      } else {
        throw 'Error: ${response.body}';
      }
    } catch (e) {
      print('Error in updateVendorOutletsApi: $e');
      throw e;
    }
  }
}
