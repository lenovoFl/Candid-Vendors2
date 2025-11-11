import 'package:candid_vendors/Screens/AuthScreens/CreateProfile.dart';
import 'package:candid_vendors/Services/Collections/App/AppDataColl.dart';
import 'package:candid_vendors/Services/Collections/Offers/OffersCat/OffersCatColl.dart';
import 'package:candid_vendors/Services/Collections/VendorPolicy/VendorPolicyColl.dart';
import 'package:candid_vendors/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

import '../../../Controllers/Notification/NotificationController.dart';
import '../../../main.dart';
import '../../Collections/User/VendorUserColl.dart';

// run command to use localhost api - adb reverse tcp:3636 tcp:3636
// run command to use firebase localhost api - adb reverse tcp:5001 tcp:5001

class AuthConnect extends GetConnect {
  Future<void> loginRegisterAccount({
    required String mobileNumber,
    required bool isSignUp,
    required String message,
    Map<String, dynamic>? userData,
  }) async {
    debugPrint('URL: ${'${Utils.apiUrl}/login-register'}');

    mobileNumber = mobileNumber.replaceAll(' ', '');

    if (userData != null && isSignUp) {
      String token = (await firebaseMessaging.getToken(
        vapidKey:
            "BD93uA4LT6RTzfWR3aWZs-u2b4Uh0utaTEIQ6X5xgetpTTafFzXFZSIkrKg465rJhDbcLtdipMWARn-Dbu5NAJA",
      ))
          .toString();
      userData['firebaseMessagingToken'] = token;
    }
    Response res = await post(
      '${Utils.apiUrl}/login-register',
      {
        'userPhone': mobileNumber,
        'isVendor': 'true',
        'userData': isSignUp ? userData : {}
      },
      headers: await utils.getHeaders(),
    );
    // debugPrint('suresh res | Response: $res');
    debugPrint('login res statusCode| ${res.statusCode}');
    debugPrint('login res body| ${res.body}');
    if (res.statusCode == null || res.statusCode != 200) {
      try {
        utils.showSnackBar(res.body['message'].toString());
        if (res.body['message']
            .toString()
            .contains('Cannot read properties of undefined')) {
          await Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => CreateProfile(
                user: firebaseAuth.currentUser!,
              ),
            ),
            (route) => false,
          );
        }
      } catch (e) {
        utils.showSnackBar('Try again later!');
      }
      if (res.statusCode == 401) {
        await utils.logOutUser();
      }
      // throw 'something is wrong while sign in / create profile';
    }
    if (res.statusCode == 200) {
      if (res.body['message']
              .toString()
              .toLowerCase()
              .contains('no data found ') ||
          res.body['message']
              .toString()
              .toLowerCase()
              .contains('need to create new profile ')) {
        await Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => CreateProfile(
              user: firebaseAuth.currentUser!,
            ),
          ),
          (route) => false,
        );
      }
      var userData = res.body['userData'];
      List<Module> allowedModules = [];
      List<Outlet> myOutletList = [];
      var currentSelectionData = CurrentSelectionData();
      if (res.body['allowedModules'] != null) {
        for (var allowedModule in res.body['allowedModules']) {
          allowedModules.add(Module(
              moduleCode: allowedModule['moduleCode'],
              moduleId: allowedModule['moduleId'],
              moduleName: allowedModule['moduleName']));
        }
      }
      if (userData['currentSelectionData'] != null &&
          userData['currentSelectionData'].isNotEmpty) {
        var module = userData['currentSelectionData']['module'];
        currentSelectionData.module = Module(
            moduleId: module['moduleId'] ?? '',
            moduleName: module['moduleName'] ?? '',
            moduleCode: module['moduleCode'] ?? '');
      } else {
        currentSelectionData.module =
            Module(moduleId: '', moduleCode: '', moduleName: '');
      }

      if (userData['myOutlets'] != null) {
        debugPrint('outlet | ${userData['myOutlets']}');
        for (var myOutlet in userData['myOutlets']) {
          var myOutletData = myOutlet['outletData'] ?? myOutlet;
          myOutletList.add(Outlet(
              lat: myOutletData['lat'],
              long: myOutletData['long'],
              //storeName: myOutletData['userstoreName'] ?? '',
              userOutletAddress1: myOutletData['userOutletAddress1'] ?? '',
              userOutletAddress2: myOutletData['userOutletAddress2'] ?? '',
              userOutletAddressCity:
                  myOutletData['userOutletAddressCity'] ?? '',
              userOutletAddressPinCode:
                  myOutletData['userOutletAddressPinCode'] ?? '',
              userOutletAddressState:
                  myOutletData['userOutletAddressState'] ?? '',
              userOutletAddressBuildingStreetArea:
                  myOutletData['userOutletAddressBuildingStreetArea'] ?? '',
              userOutletID: myOutlet['outletID'] ?? ''));
        }
      }

      await firebaseCrashlytics.setUserIdentifier(
          userData['userId'] ?? firebaseAuth.currentUser?.uid ?? '');
      List<OffersCatColl> catsList = [];
      for (var selectedCat
          in List<Map<String, dynamic>>.from(userData['selectedCatsList'])) {
        catsList.add(OffersCatColl(
            catID: selectedCat['catID'],
            catImg: selectedCat['catImg'],
            catType: selectedCat['catType'],
            catName: selectedCat['catName']));
      }

      await isar.writeTxn(() async {
        await isar.vendorUserColls.clear();
        await isar.offersCatColls.clear();
        await isar.vendorPolicyColls.clear();
        await isar.vendorUserColls.put(VendorUserColl(
          myOutlets: myOutletList,
          userToken: userData['userToken'] ?? '',
          userId: firebaseAuth.currentUser!.uid,
          allowedModules: allowedModules,
          referredBy: userData['referredBy'],
          bankAccountHolderName: userData['bankAccountHolderName'] ?? '',
          bankAccountHolderAcNumber:
              userData['bankAccountHolderAcNumber'] ?? '',
          bankAccountHolderAc1Number:
              userData['bankAccountHolderAc1Number'] ?? '',
          bankAccountHolderIFSC1: userData['bankAccountHolderIFSC1'] ?? '',
          bankAccountHolderIFSC: userData['bankAccountHolderIFSC'] ?? '',
          bankAccountHolderBankName:
              userData['bankAccountHolderBankName'] ?? '',
          bankAccountHolderBankBranch:
              userData['bankAccountHolderBankBranch'] ?? '',
          storeRating: userData['storeRating'] ?? '',
          profileStatus: userData['profileStatus'] ?? '',
          vendorQRImgUrl: userData['vendorQRImgUrl'] ?? '',
          userAddress: userData['userAddress'],
          userBusinessName: userData['userBusinessName'],
          userJoinedSince: DateTime.parse(
                  userData['userJoinedSince'] ?? DateTime.now().toString())
              .toLocal(),
          currentSelectionData: currentSelectionData,
          userName: userData['userName'] ?? '',
          userMobile1: mobileNumber,
          userEmail1: userData['userEmail1'],
          userEmail2: userData['userEmail2'] ?? '',
          userFullName: userData['userFullName'],
          userGender: userData['userGender'],
          userGroupId: userData['userGroupId'] ?? '',
          firebaseMessagingToken: userData['firebaseMessagingToken'],
          userGroupLevel: userData['userGroupLevel'].toString(),
          userGroupName: userData['userGroupName'] ?? '',
          userMobile2: userData['userMobile2'] ?? '',
          userProfilePic: userData['userProfilePic'],
          userCompanyLogo: userData['userCompanyLogo'] ?? '',
          offerCount: userData['offerCount'],
          candidOfferSubscriptionEndDate: DateTime.parse(
                  userData['candidOfferSubscriptionEndDate'] ??
                      DateTime.now().toString())
              .toLocal(),
          candidOfferSubscriptionPlanEndDate: DateTime.parse(
                  userData['candidOfferSubscriptionPlanEndDate'] ??
                      DateTime.now().toString())
              .toLocal(),
          candidOfferSubscriptionStartDate: DateTime.parse(
                  userData['candidOfferSubscriptionStartDate'] ??
                      DateTime.now().toString())
              .toLocal(),
          candidOfferSubscriptionPlanStartDate: DateTime.parse(
                  userData['candidOfferSubscriptionStartDate'] ??
                      DateTime.now().toString())
              .toLocal(),
          userAuthToken: userData['userAuthToken'] ?? '',
          userAddressCity: userData['userAddressCity'],
          userAddressState: userData['userAddressState'],
          storeName: userData['storeName'] ?? '',
          isActive: userData['isActive'] ?? false, // Set isActive field2
          // tshirtSize: userData['tshirtSize'], // Save T-shirt size in the collection
        ));
        if (res.body.containsKey('sessionCookie') &&
            (res.body['sessionCookie'] ?? '').toString().length > 10) {
          await isar.appDataColls.clear();
          await isar.appDataColls.put(AppDataColl(
              isSignedIn: true, sessionCookie: res.body['sessionCookie']));
        }
        await isar.offersCatColls.putAll(catsList);
        await isar.vendorPolicyColls.put(VendorPolicyColl(
            vendorWarrantyPolicy: userData['warranty'] ?? "",
            vendorRefundPolicy: userData['refund'] ?? "",
            vendorDelivery: userData['delivery'] ?? "",
            vendorPaymentPolicy: userData['COD'] ?? "",
            vendorOtherPolicy: userData['other'] ?? ""));
      });
      localSeller = (await isar.vendorUserColls
          .filter()
          .idIsNotNull()
          .build()
          .findFirst())!;
      localAppData = (await isar.appDataColls
          .filter()
          .sessionCookieIsNotEmpty()
          .findFirst())!;
      utils.showSnackBar(res.body['message']);
      utils.runWhenInitOrLoggedIn();
      NotificationController notificationController = Get.find();
      notificationController.triggerAccountCreationNotification();
    }
  }

  Future<void> loginRegisterAccountviaemail({
    required String email,
    required String password,
    required String mobileNumber,
    required bool isSignUp,
    required String message,
    Map<String, dynamic>? userData,
  }) async {
    debugPrint('URL: ${'${Utils.apiUrl}/login-register-email'}');

    if (userData != null && isSignUp) {
      String token = (await firebaseMessaging.getToken(
        vapidKey:
            "BD93uA4LT6RTzfWR3aWZs-u2b4Uh0utaTEIQ6X5xgetpTTafFzXFZSIkrKg465rJhDbcLtdipMWARn-Dbu5NAJA",
      ))
          .toString();
      userData['firebaseMessagingToken'] = token;
    }
    Response res = await post(
      '${Utils.apiUrl}/login-register-email',
      {
        'userEmail': email,
        'userPassword': password,
        'isVendor': 'true',
        'userMobile1': mobileNumber,
        'userData': isSignUp ? userData : {}
      },
      headers: await utils.getHeaders(),
    );
    debugPrint('suresh res | Response: $res');
    debugPrint('login res statusCode| ${res.statusCode}');
    debugPrint('login res body| ${res.body}');
    if (res.statusCode == null || res.statusCode != 200) {
      try {
        utils.showSnackBar(res.body['message'].toString());
        if (res.body['message']
            .toString()
            .contains('Cannot read properties of undefined')) {
          await Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => CreateProfile(
                user: firebaseAuth.currentUser!,
              ),
            ),
            (route) => false,
          );
        }
      } catch (e) {
        utils.showSnackBar('Try again later!');
      }
      if (res.statusCode == 401) {
        await utils.logOutUser();
      }
      // throw 'something is wrong while sign in / create profile';
    }
    if (res.statusCode == 200) {
      if (res.body['message']
              .toString()
              .toLowerCase()
              .contains('no data found ') ||
          res.body['message']
              .toString()
              .toLowerCase()
              .contains('need to create new profile ')) {
        await Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => CreateProfile(
              user: firebaseAuth.currentUser!,
            ),
          ),
          (route) => false,
        );
      }
      var userData = res.body['userData'];
      List<Module> allowedModules = [];
      List<Outlet> myOutletList = [];
      var currentSelectionData = CurrentSelectionData();
      if (res.body['allowedModules'] != null) {
        for (var allowedModule in res.body['allowedModules']) {
          allowedModules.add(Module(
              moduleCode: allowedModule['moduleCode'],
              moduleId: allowedModule['moduleId'],
              moduleName: allowedModule['moduleName']));
        }
      }
      if (userData['currentSelectionData'] != null &&
          userData['currentSelectionData'].isNotEmpty) {
        var module = userData['currentSelectionData']['module'];
        currentSelectionData.module = Module(
            moduleId: module['moduleId'] ?? '',
            moduleName: module['moduleName'] ?? '',
            moduleCode: module['moduleCode'] ?? '');
      } else {
        currentSelectionData.module =
            Module(moduleId: '', moduleCode: '', moduleName: '');
      }

      if (userData['myOutlets'] != null) {
        debugPrint('outlet | ${userData['myOutlets']}');
        for (var myOutlet in userData['myOutlets']) {
          var myOutletData = myOutlet['outletData'] ?? myOutlet;
          myOutletList.add(Outlet(
              lat: myOutletData['lat'],
              long: myOutletData['long'],
              //storeName: myOutletData['userstoreName'] ?? '',
              userOutletAddress1: myOutletData['userOutletAddress1'] ?? '',
              userOutletAddress2: myOutletData['userOutletAddress2'] ?? '',
              userOutletAddressCity:
                  myOutletData['userOutletAddressCity'] ?? '',
              userOutletAddressPinCode:
                  myOutletData['userOutletAddressPinCode'] ?? '',
              userOutletAddressState:
                  myOutletData['userOutletAddressState'] ?? '',
              userOutletAddressBuildingStreetArea:
                  myOutletData['userOutletAddressBuildingStreetArea'] ?? '',
              userOutletID: myOutlet['outletID'] ?? ''));
        }
      }

      await firebaseCrashlytics.setUserIdentifier(
          userData['userId'] ?? firebaseAuth.currentUser?.uid ?? '');
      List<OffersCatColl> catsList = [];
      for (var selectedCat
          in List<Map<String, dynamic>>.from(userData['selectedCatsList'])) {
        catsList.add(OffersCatColl(
            catID: selectedCat['catID'],
            catImg: selectedCat['catImg'],
            catType: selectedCat['catType'],
            catName: selectedCat['catName']));
      }
      await isar.writeTxn(() async {
        await isar.vendorUserColls.clear();
        await isar.offersCatColls.clear();
        await isar.vendorPolicyColls.clear();
        await isar.vendorUserColls.put(VendorUserColl(
          myOutlets: myOutletList,
          userToken: userData['userToken'] ?? '',
          userId: firebaseAuth.currentUser!.uid,
          allowedModules: allowedModules,
          referredBy: userData['referredBy'],
          bankAccountHolderName: userData['bankAccountHolderName'] ?? '',
          bankAccountHolderAcNumber:
              userData['bankAccountHolderAcNumber'] ?? '',
          bankAccountHolderAc1Number:
              userData['bankAccountHolderAc1Number'] ?? '',
          bankAccountHolderIFSC1: userData['bankAccountHolderIFSC1'] ?? '',
          bankAccountHolderIFSC: userData['bankAccountHolderIFSC'] ?? '',
          bankAccountHolderBankName:
              userData['bankAccountHolderBankName'] ?? '',
          bankAccountHolderBankBranch:
              userData['bankAccountHolderBankBranch'] ?? '',
          storeRating: userData['storeRating'] ?? '',
          profileStatus: userData['profileStatus'] ?? '',
          vendorQRImgUrl: userData['vendorQRImgUrl'] ?? '',
          userAddress: userData['userAddress'],
          userBusinessName: userData['userBusinessName'],
          userJoinedSince: DateTime.parse(
                  userData['userJoinedSince'] ?? DateTime.now().toString())
              .toLocal(),
          currentSelectionData: currentSelectionData,
          userName: userData['userName'] ?? '',
          userMobile1: email,
          userEmail1: userData['userEmail1'],
          userEmail2: userData['userEmail2'] ?? '',
          userFullName: userData['userFullName'],
          userGender: userData['userGender'],
          userGroupId: userData['userGroupId'] ?? '',
          firebaseMessagingToken: userData['firebaseMessagingToken'],
          userGroupLevel: userData['userGroupLevel'].toString(),
          userGroupName: userData['userGroupName'] ?? '',
          userMobile2: userData['userMobile2'] ?? '',
          userProfilePic: userData['userProfilePic'],
          userCompanyLogo: userData['userCompanyLogo'] ?? '',
          offerCount: userData['offerCount'],
          candidOfferSubscriptionEndDate: DateTime.parse(
                  userData['candidOfferSubscriptionEndDate'] ??
                      DateTime.now().toString())
              .toLocal(),
          candidOfferSubscriptionPlanEndDate: DateTime.parse(
                  userData['candidOfferSubscriptionPlanEndDate'] ??
                      DateTime.now().toString())
              .toLocal(),
          candidOfferSubscriptionStartDate: DateTime.parse(
                  userData['candidOfferSubscriptionStartDate'] ??
                      DateTime.now().toString())
              .toLocal(),
          candidOfferSubscriptionPlanStartDate: DateTime.parse(
                  userData['candidOfferSubscriptionStartDate'] ??
                      DateTime.now().toString())
              .toLocal(),
          userAuthToken: userData['userAuthToken'] ?? '',
          userAddressCity: userData['userAddressCity'],
          userAddressState: userData['userAddressState'],
          storeName: userData['storeName'] ?? '',
          isActive: userData['isActive'] ?? false, // Set isActive field2
          // tshirtSize:
          //     userData['tshirtSize'], // Save T-shirt size in the collection
        ));
        if (res.body.containsKey('sessionCookie') &&
            (res.body['sessionCookie'] ?? '').toString().length > 10) {
          await isar.appDataColls.clear();
          await isar.appDataColls.put(AppDataColl(
              isSignedIn: true, sessionCookie: res.body['sessionCookie']));
        }
        await isar.offersCatColls.putAll(catsList);
        await isar.vendorPolicyColls.put(VendorPolicyColl(
            vendorWarrantyPolicy: userData['warranty'] ?? "",
            vendorRefundPolicy: userData['refund'] ?? "",
            vendorDelivery: userData['delivery'] ?? "",
            vendorPaymentPolicy: userData['COD'] ?? "",
            vendorOtherPolicy: userData['other'] ?? ""));
      });
      localSeller = (await isar.vendorUserColls
          .filter()
          .idIsNotNull()
          .build()
          .findFirst())!;
      localAppData = (await isar.appDataColls
          .filter()
          .sessionCookieIsNotEmpty()
          .findFirst())!;
      utils.showSnackBar(res.body['message']);
      utils.runWhenInitOrLoggedIn();
    }
  }

  createSessionApi() async {
    try {
      Response res = await post('${Utils.apiUrl}/createSessionCookie', {},
          headers: await utils.getHeaders());

      if (res.statusCode != 200) {
        throw Exception('Failed to create session: ${res.statusCode}');
      }

      if (res.body.containsKey('sessionCookie')) {
        await isar.writeTxn(() async {
          await isar.appDataColls.clear();
          await isar.appDataColls.put(AppDataColl(
              isSignedIn: false, sessionCookie: res.body['sessionCookie']));
        });
      } else {
        // Show popup message if sessionCookie is not received
        utils.showSnackBar('Your account is disabled. Please contact support.');
      }
    } catch (e, stackTrace) {
      // Log the error to Crashlytics
      await firebaseCrashlytics.recordError(e, stackTrace);

      // Show a snackbar or handle the error message in your UI
      utils.showSnackBar('Failed to create session: $e');
    }
  }

// checkSessionApi() async {
//   Response res = await post(
//       '${Utils.apiUrl}/checkSession',
//       {
//         'sessionCookie':
//             (await utils.getUser() as VendorUserColl).sessionCookie
//       },
//       headers: await utils.getHeaders());
//
//   debugPrint('checkSessionApi : ${res.statusCode}');
//   debugPrint('checkSessionApi : ${res.body}');
//
//   if (res.statusCode != 200) {
//     // await utils.logOutUser();
//   }
// }
}
