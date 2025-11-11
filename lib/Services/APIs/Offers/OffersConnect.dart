import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:candid_vendors/Controllers/Offers/OfferUploadHistoryController.dart';
import 'package:candid_vendors/Services/Collections/Offers/OfferHistory/OfferHistoryColl.dart';
import 'package:candid_vendors/Services/Collections/Offers/OffersCat/OffersCatColl.dart';
import 'package:candid_vendors/Services/Collections/Policy/PolicyColl.dart';
import 'package:candid_vendors/Services/Collections/User/VendorUserColl.dart';
import 'package:candid_vendors/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../../Controllers/Notification/NotificationController.dart';
import '../../../Controllers/Offers/OfferPreviewController.dart';
import '../../../Utils/Utils.dart';
import '../../Collections/App/AppDataColl.dart';

// run command to use localhost api - adb reverse tcp:3636 tcp:3636
// run command to use firebase localhost api - adb reverse tcp:5001 tcp:5001

class OffersConnect extends GetConnect {
  // String debugUID = firebaseAuth.currentUser!.uid;
  // late String mobileNumber;

  Future<void> createOfferApi({
    required String userId,
    required OfferPreviewController controller,
    required Map<String, dynamic> offerCreateMap,
  }) async {
    final storageRef = firebaseStorage.ref();
    var pathForFile = storageRef.child('vendorOffers/$userId');
    VendorUserColl? user = await isar.vendorUserColls.where().findFirst();
    // OffersCatColl? offer = await isar.offersCatColls.where().findFirst(); // Unused, removed
    String catId = offerCreateMap['selectedCatID']?.toString() ?? '';
    print('Category ID in createOfferApi: $catId'); // Debug print
    String userMobile1 = user?.userMobile1 ?? '';
    String userEmail1 = user?.userEmail1 ?? '' ;
    String userBusinessName = user?.userBusinessName ?? ''; // ✅ Correction 1: Null check added

    final createOfferFormData = {
      "productType": offerCreateMap['selectedCategory'].toString(),
      "offerStatus": "Created",
      "offerName": offerCreateMap['offerName'].toString(),
      "offerPrimeDiscountedPrice": offerCreateMap['offerPrimeDiscountedPrice'].toString(),
      "regularUnitPrice": offerCreateMap['regularUnitPrice'].toString(),
      "offerDiscountedPrice": offerCreateMap['offerDiscountedPrice'].toString(),
      'productName': offerCreateMap['productName'].toString(),
      'unitPrice2': offerCreateMap['unitPrice2'].toString(),
      'productDescription': offerCreateMap['productDescription'].toString(),
      "offerDescription": offerCreateMap['offerDescription'].toString(),
      "discountType": offerCreateMap['discountType'].toString(),
      "discountNo": offerCreateMap['discountNo'].toString(),
      "discountNoPrime": offerCreateMap['discountNoPrime'].toString(),
      "discountUoM": offerCreateMap['discountUoM'].toString(),
      "userPinCode": offerCreateMap['postalCode'].toString(),
      "selectedStartDate": offerCreateMap['selectedStartDate'].toString(),
      "selectedEndDate": offerCreateMap['selectedEndDate'].toString(),
      'isTrending': offerCreateMap['isTrending'].toString(),
      'isBigDays': offerCreateMap['isBigDays'].toString(), // Added isBigDays to form data

      // ✅ Correction 2: Missing required user outlet fields (from OfferPreviewController's map)
      'userOutletAddress1': offerCreateMap['userOutletAddress1'].toString(),
      'userOutletAddress2': offerCreateMap['userOutletAddress2'].toString(),
      'userOutletAddressBuildingStreetArea': offerCreateMap['userOutletAddressBuildingStreetArea'].toString(),
      'userMobile2': offerCreateMap['userMobile2'].toString(),
      'maxNumClaims': offerCreateMap['maxNumClaims'].toString(),

      // Fields from VendorUserColl (passed via map for consistency)
      'userMobile1': userMobile1,
      'userBusinessName': userBusinessName,
      'userEmail1': userEmail1,

      'latitude': offerCreateMap['latitude'],
      'longitude': offerCreateMap['longitude'],
      'selectedCity': offerCreateMap['selectedCity'].toString(),
      'selectedState': offerCreateMap['selectedState'].toString(),
      'isCreativeDesigned': offerCreateMap['isCreativeDesigned'].toString(),
      "offersPackageId": "10",
      "offerType": offerCreateMap['selectedOfferType'].toString(),
      'offerDiscountType': offerCreateMap['offerDiscountType'].toString(),
      "catId": catId,
      "offerTC": offerCreateMap['offerTC'].toString(),
      "warranty": offerCreateMap['warranty'].toString(),
      "refund": offerCreateMap['refund'].toString(),
      "delivery": offerCreateMap['delivery'].toString(),
      "COD": offerCreateMap['COD'].toString(),
      "other": offerCreateMap['other'].toString() ?? "",
      // 'describeDealDetails': offerCreateMap['describeDealDetails'].toString()?? "",
      // 'stepsToRedeem': offerCreateMap['stepsToRedeem'].toString() ?? "",
      "discountNo2": "1",
      "isInStock": "true",
      "vendorId": userId,
      "views": "0",
    };

    print('offerCreateMap: $offerCreateMap');
    print('createOfferFormData catId: ${createOfferFormData["catId"]}'); // Debug print
    debugPrint('createOfferFormData : $createOfferFormData');

    Response res = await post(
        '${Utils.apiUrl}/createOffer',
        createOfferFormData,
        headers: await utils.getHeaders()
    );

    var body = res.body;
    debugPrint('create offer | res.statusCode : ${res.statusCode}');
    debugPrint('create offer | body : $body');

    if (res.statusCode != 200) {
      controller.isLoading = false;
      controller.update();
      try {
        utils.showSnackBar(body['message']);
      } catch (e) {
        utils.showSnackBar('try again later!');
      }
      if (res.statusCode == 401) {
        await utils.logOutUser();
      }
      return;
    }

    if (res.statusCode == 200) {
      await isar.writeTxn(() async {
        final user = await isar.vendorUserColls.get((await utils.getUser() as VendorUserColl).id!);
        user!.offerCount = body['offerCount'];
        await isar.vendorUserColls.put(user);
      });
      debugPrint('offer id | ${body['newOfferID']}');

      // 🖼️ STEP 1: UPLOADING IMAGES TO FIREBASE STORAGE
      List<UploadTask> uploadFilesList = [];
      for (var file in (offerCreateMap['offerImages'] as List<XFile>)) {
        uploadFilesList.add(pathForFile
            .child('${body['newOfferID']}/${file.path.split('/').last}')
            .putFile(File(file.path)));
      }
      controller.message = 'Uploading files!';
      controller.update();
      await Future.wait(uploadFilesList);

      // 🖼️ STEP 2: GETTING DOWNLOAD URLs
      var filesList = await pathForFile.child('${body['newOfferID']}').listAll();
      List<String> photosUrlList = [];
      for (var item in filesList.items) {
        photosUrlList.add(await item.getDownloadURL());
      }
      controller.currentOfferImg = photosUrlList[0];

      // 🖼️ STEP 3: UPDATING FIREBASE/SERVER (Firestore/RealtimeDB) WITH URLS
      await updateOfferImagesToDoc(
          userId: userId,
          newOfferID: body['newOfferID'],
          newOfferImagesList: photosUrlList);

      // ✅ Correction 3: Missing required fields in Isar put() call, added now.
      await isar.writeTxn(() async {
        await isar.offerHistoryColls.put(OfferHistoryColl(
          offerID: body['newOfferID'],
          userPinCode: offerCreateMap['postalCode'],
          offerDiscountedPrice: offerCreateMap['offerDiscountedPrice'].toString(),
          regularUnitPrice: offerCreateMap['regularUnitPrice'].toString(),
          unitPrice2: offerCreateMap['unitPrice2'].toString(),
          offerPrimeDiscountedPrice: offerCreateMap['offerPrimeDiscountedPrice'].toString(),
          discountNo: offerCreateMap['discountNo'].toString(),

          // --- Added Missing Outlet Details ---
          userOutletAddress1: offerCreateMap['userOutletAddress1'],
          userOutletAddress2: offerCreateMap['userOutletAddress2'],
          userMobile1: offerCreateMap['userMobile1'].toString(),
          userMobile2: offerCreateMap['userMobile2'].toString(),
          userOutletAddressBuildingStreetArea: offerCreateMap['userOutletAddressBuildingStreetArea'],
          maxNumClaims: offerCreateMap['maxNumClaims'],
          // ------------------------------------

          latitude: offerCreateMap['latitude'],
          longitude: offerCreateMap['longitude'],
          offerType: offerCreateMap['selectedOfferType'],
          catId: catId,
          productDescription: offerCreateMap['productDescription'],
          selectedCity: offerCreateMap['selectedCity'],
          selectedState: offerCreateMap['selectedState'],
          isTrending: offerCreateMap['isTrending'] == 'true', // Convert string to bool
          isBigDays: offerCreateMap['isBigDays'] == 'true', // Added
          offerDescription: offerCreateMap['offerDescription'],
          discountNo2: "1",
          offersPackageId: "10",
          discountType: offerCreateMap['discountType'].toString(),
          productType: offerCreateMap['selectedCategory'],
          createTime: DateTime.parse(body['createTime']),
          selectedStartDate: DateTime.parse(offerCreateMap['selectedStartDate'].toString()),
          selectedEndDate: DateTime.parse(offerCreateMap['selectedEndDate'].toString()),
          offerName: offerCreateMap['offerName'],
          productName: offerCreateMap['productName'],
          userEmail1: offerCreateMap['userEmail1'] ?? "", // Added null check
          userBusinessName: offerCreateMap['userBusinessName'] ?? "",
          discountNoPrime: offerCreateMap['discountNoPrime'].toString(),
          discountUoM: offerCreateMap['discountUoM'],
          isInStock: true,

          offerImages: photosUrlList, // 🖼️ URL List Saved to Isar

          offerStatus: OfferStatus.created,
          views: 0,
          warranty: offerCreateMap['warranty'],
          refund: offerCreateMap['refund'],
          delivery: offerCreateMap['delivery'],
          COD: offerCreateMap['COD'],
          other: offerCreateMap['other'] ?? "other",
          // describeDealDetails: offerCreateMap['describeDealDetails'] ?? "", // Removed due to missing field
          // stepsToRedeem: offerCreateMap['stepsToRedeem'] ?? "", // Removed due to missing field
        ));
      });

      // Schedule the expiration task here
      await FirebaseFirestore.instance
          .collection('candidOffers')
          .doc(body['newOfferID'])
          .set({
        'offerID': body['newOfferID'],
        // Add other fields if necessary
      }, SetOptions(merge: true));

      bottomNavController.selectedIndex = 0;
      controller.message = 'Offer has been created!';
      controller.isLoading = false;
      controller.isOfferCreated = true;
      controller.offerID = body['newOfferID'];
      controller.update();
      utils.showSnackBar(body['message']);

      // Notifications triggered after successful creation and DB update
      NotificationController notificationController = Get.find();
      notificationController.triggerOfferCreatedNotification();
      Future.delayed(const Duration(seconds: 3), () {
        notificationController.triggerOffergoesForReviewNotification();
      });
    }
  }


  updateOfferImagesToDoc(
      {required String userId,
        required String newOfferID,
        required List<String> newOfferImagesList}) async {
    Map<String, dynamic> body = {
      'vendorId': userId,
      'offerId': newOfferID,
      'offerImages': newOfferImagesList,
    };
    Response response = await post(
      '${Utils.apiUrl}/editOfferById',
      body,
      headers: await utils.getHeaders(),
    );
    debugPrint('response statusCode: ${response.statusCode}');
    debugPrint('response body: ${response.body}');
    if (response.statusCode != 200) {
      throw 'error in updating images url to DB | offerID : $newOfferID';
    }
  }

  static getOfferHistoryApi(
      {OfferUploadHistoryController? offerUploadHistoryController}) async {
    ReceivePort myReceivePort = ReceivePort();
    debugPrint('getOfferHistoryApi CALLED!');
    getOfferHistoryApiIsolate(List list) async {
      SendPort sendPort = list[0];
      final isar = await Isar.open(
        [OfferHistoryCollSchema, AppDataCollSchema],
        directory: list[1].path,
      );
      Response offerHistoryRes = await GetConnect().post(
          '${Utils.apiUrl}/getOffersByVendorID', {'vendorId': list[2].userId},
          headers: await Utils.getHeaders1(isar, list[2], list[3], list[4]));

      debugPrint('getOfferHistoryApiIsolate | ${offerHistoryRes.statusCode}');
      debugPrint('getOfferHistoryApiIsolate | ${offerHistoryRes.body}');
      String fixDateString(String dateString) {
        // Add leading zero to the day if it's missing
        if (RegExp(r'\d{4}-\d{2}-\d{1}T').hasMatch(dateString)) {
          // Fix the one-digit day to two digits
          dateString = dateString.replaceFirstMapped(RegExp(r'(\d{4}-\d{2}-)(\d{1})T'), (match) {
            return '${match[1]}0${match[2]}T';
          });
        }
        return dateString;
      }
      if (offerHistoryRes.statusCode == 200) {
        var body = offerHistoryRes.body;
        List<OfferHistoryColl> offersHistory = [];
        for (var offer in body['data']) {
          var offerData = offer['offerData'];
          OfferStatus offerStatus = OfferStatus.live; // Default to live for debugging purposes
          switch (offerData['offerStatus'].toString().toLowerCase()) {
            case 'created':
              offerStatus = OfferStatus.created;
              break;
            case 'live':
              offerStatus = OfferStatus.live;
              break;
            case 'available':
              offerStatus = OfferStatus.available;
              break;
            case 'end':
              offerStatus = OfferStatus.expired;
              break;
            case 'total encash':
              offerStatus = OfferStatus.totalEncash;
              break;
            case 'out of stock':
              offerStatus = OfferStatus.outOfStock;
              break;
            case 'rejected':
              offerStatus = OfferStatus.rejected;
              break;
            default:
              debugPrint('Unknown offer status: ${offerData['offerStatus']}');
              break;
          }
          debugPrint('Number of offers fetched: ${offersHistory.length}');
          bool isInStock = offerData['isInStock'] is bool
              ? offerData['isInStock']
              : offerData['isInStock'].toString().toLowerCase() == 'true';
          offersHistory.add(OfferHistoryColl(
            selectedStartDate: DateTime.parse(fixDateString(offerData['selectedStartDate'])),
            selectedEndDate: DateTime.parse(fixDateString(offerData['selectedEndDate'])),
            createTime: DateTime.parse(fixDateString(offer['createTime'])),
            isInStock: isInStock,
            offerID: offer['offerID'],
            offerStatus: offerStatus,
            userPinCode: offerData['userPinCode'].toString(),
            discountNo: offerData['discountNo'].toString(),
            offerType: offerData['offerType'].toString(),
            catId: offerData['catId']?.toString() ?? '',
            discountNoPrime: offerData['discountNoPrime'],
            unitPrice2:offerData['unitPrice2'].toString(),
            discountUoM: offerData['discountUoM'],
            offerName: offerData['offerName'],
            offerDiscountedPrice : offerData['offerDiscountedPrice'].toString(),
            regularUnitPrice:offerData['regularUnitPrice'].toString(),
            offerPrimeDiscountedPrice : offerData['offerPrimeDiscountedPrice'].toString(),
            productName: offerData['productName'],
            isTrending: offerData['isTrending'] is bool
                ? offerData['isTrending']
                : offerData['isTrending'].toString().toLowerCase() == 'true',
            isBigDays: offerData['isTrending'] is bool
                ? offerData['isTrending']
                : offerData['isTrending'].toString().toLowerCase() == 'true',
            userOutletAddress1: offerData ['userOutletAddress1'],
            userOutletAddress2: offerData ['userOutletAddress2'],
            userEmail1: offerData ['userEmail1'] ?? '',
            userBusinessName: offerData['userBusinessName']?? "",
            userOutletAddressBuildingStreetArea: offerData ['userOutletAddressBuildingStreetArea'],
            longitude: double.tryParse(offerData['longitude']?.toString() ?? '0') ?? 0.0,
            latitude: double.tryParse(offerData['longitude']?.toString() ?? '0') ?? 0.0,
            userMobile1: offerData['userMobile1']?.toString() ?? '',
            userMobile2: offerData['userMobile2']?.toString() ?? '',
            offerDescription: offerData['offerDescription'].toString(),
            discountNo2: offerData['discountNo2'].toString(),
            offersPackageId: offerData['offersPackageId'].toString(),
            discountType: offerData['discountType'].toString(),
            productType: offerData['productType'].toString(),
            // selectedStartDate: DateTime.parse(offerData['selectedStartDate']),
            // selectedEndDate: DateTime.parse(offerData['selectedEndDate']),
            offerImages: List<String>.from(offerData['offerImages'] ?? ['']),
            productDescription: offerData['productDescription'],
            selectedCity: offerData['selectedCity'],
            selectedState: offerData['selectedState'],
            views: double.tryParse(offerData['views'].toString()) ?? 0.0,
            //     regularDiscountNumber: offerData['regularDiscountNumber'] ?? [''],
            //     regularUnitPrice: offerData['regularUnitPrice'],
            //    primeDiscountNumber: offerData['primeDiscountNumber'],
            //    primeUnitPrice: offerData['primeUnitPrice']?? [''],
            //    primeDiscountedPrice: offerData['primeDiscountedPrice'],
            warranty: offerData['warranty'],
            refund: offerData['refund'],
            other: offerData['other'] ?? "",
            COD: offerData['COD'],
            delivery: offerData['delivery'],
            //  termsAndCondition: offerData['termsAndCondition'],
            maxNumClaims: offerData['maxNumClaims'],
            // describeDealDetails: offerData['describeDealDetails'] ?? "",
            // stepsToRedeem: offerData['stepsToRedeem'] ?? "",
          ));
        }
        debugPrint('Number of offers fetched: ${offersHistory.length}');
        await isar.writeTxn(() async {
          try {
            await isar.offerHistoryColls.putAll(offersHistory);
            debugPrint('Offers updated successfully in Isar.');
          } catch (e) {
            debugPrint('Error while updating Isar: $e');
          }
        });
        offerUploadHistoryController?.isLoading = false;
        offerUploadHistoryController?.update();
        return sendPort.send("offer history done");
      } else if (offerHistoryRes.statusCode == 401) {
        utils.showSnackBar('session expired!');
        await utils.logOutUser();
        return sendPort.send("Session or logout!");
      }
    }
    try {
      debugPrint('getOfferHistoryApi CALLED1!');
      Isolate isolate = await Isolate.spawn(getOfferHistoryApiIsolate, [
        myReceivePort.sendPort,
        dir,
        localSeller,
        await Utils.getToken(),
        localAppData
      ]);
      debugPrint('getOfferHistoryApi DDD DATA: ${await myReceivePort.first}');
      isolate.kill();
    } catch (e) {
      debugPrint('getOfferHistoryApi CATCH: ${await myReceivePort.first}');
      debugPrint('getOfferHistoryApi CATCH: $e');
    } finally {
      myReceivePort.close();
    }
  }

  static Future<void> _updateExpiredOffersOnServer(String apiUrl, List<Map<String, dynamic>> offersToUpdate, Map<String, String> headers) async {
    try {
      Response updateRes = await GetConnect().post(
        '${Utils.apiUrl}/TexpireOffers',
        {'offers': offersToUpdate},
        headers: headers,
      );

      if (updateRes.statusCode == 200) {
        debugPrint('Successfully updated expired offers on server');
      } else {
        debugPrint('Failed to update expired offers on server: ${updateRes.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating expired offers on server: $e');
    }
  }

  static OfferStatus _determineOfferStatus(String status) {
    switch (status.toLowerCase()) {
      case 'created':
        return OfferStatus.created;
      case 'live':
        return OfferStatus.live;
      case 'available':
        return OfferStatus.available;
      case 'end':
      case 'expired':
        return OfferStatus.expired;
      case 'total encash':
        return OfferStatus.totalEncash;
      case 'out of stock':
        return OfferStatus.outOfStock;
      case 'rejected':
        return OfferStatus.rejected;
      default:
        return OfferStatus.live;
    }
  }

  editProductOfferApi(
      {required OfferHistoryColl offer,
        required Map<String, dynamic> updatedOfferData}) async {
    Map<String, dynamic> body = {
      'vendorId': (await utils.getUser()).userId,
      'offerId': offer.offerID,
      'updatedOfferData': updatedOfferData,
    };
    Response response = await post(
      '${Utils.apiUrl}/editOfferById',
      body,
      headers: await utils.getHeaders(),
    );
    debugPrint(
        'editProductOfferApi | response statusCode: ${response.statusCode}');
    debugPrint('editProductOfferApi | response body: ${response.body}');
    if (response.statusCode == 200) {
      OfferHistoryColl? offerData = await isar.offerHistoryColls.get(offer.id);
      await isar.writeTxn(() async {
        if (updatedOfferData.containsKey("isInStock")) {
          offerData!.isInStock = updatedOfferData['isInStock'];
        }
        if (updatedOfferData.containsKey('offerStatus')) {
          offerData!.offerStatus = OfferStatus.outOfStock;
        }
        if (updatedOfferData.containsKey('selectedEndDate')) {
          offerData!.selectedEndDate =
              DateTime.parse(updatedOfferData['selectedEndDate']);
        }
        isar.offerHistoryColls.put(offerData!);
      });
      utils.showSnackBar(response.body['message']);
    } else if (response.statusCode == 401) {
      utils.showSnackBar('session expired!');
      await utils.logOutUser();
    }
  }

  Future<bool> offerRedeemApi({
    required String offerID,
    required String orderID,
    required String userPhone,
  }) async {
    try {
      debugPrint('Redeeming offer with:');
      debugPrint('offerID: $offerID');
      debugPrint('orderID: $orderID');
      debugPrint('userPhone: $userPhone');

      Map<String, dynamic> requestData = {
        'offerID': offerID,
        'orderID': orderID,
        'userPhone': userPhone,
      };

      Response response = await post(
        '${Utils.apiUrl1}/offerRedeem',
        requestData,
        headers: await utils.getHeaders(),
      );

      debugPrint('offerRedeemApi : response statusCode: ${response.statusCode}');
      debugPrint('offerRedeemApi : response body: ${response.body}');

      // Handle null response
      if (response.body == null) {
        utils.showSnackBar('Server response was invalid. Please check if the offer was redeemed.');
        return false;
      }

      // Parse the response body based on its type
      Map<String, dynamic> responseBody;
      if (response.body is String) {
        responseBody = jsonDecode(response.body);
      } else if (response.body is Map) {
        responseBody = Map<String, dynamic>.from(response.body);
      } else {
        utils.showSnackBar('Invalid response format');
        return false;
      }

      // Handle the message
      if (responseBody.containsKey('message')) {
        String message = responseBody['message'].toString();
        utils.showSnackBar(message);

        if (message.contains('successfully')) {
          NotificationController notificationController = Get.find();
          notificationController.triggerOfferReddemkNotification();
          await checkAndUpdateOfferStatus(offerID);
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('offerRedeemApi error: $e');
      // utils.showSnackBar('An error occurred while redeeming the offer.');
      return false;
    }
  }


  Future<void> checkAndUpdateOfferStatus(String offerID) async {
    final offer = await isar.offerHistoryColls.get(offerID as Id);
    if (offer!= null) {
      // Assuming OfferStatus is an enum with values live, rejected, outOfStock
      switch (offer.offerStatus) {
        case OfferStatus.live:
        // Trigger live offer notification
          NotificationController notificationController = Get.find();
          notificationController.triggerOfferLiveNotification() ;
          break;
        case OfferStatus.rejected:
          notificationController.triggerRejectedOfferNotification();
          break;
        case OfferStatus.outOfStock:
          notificationController.triggerOfferOutOfStockNotification();
          offer.offerStatus = OfferStatus.outOfStock;
          await isar.offerHistoryColls.put(offer);
          break;
        default:
          break;
      }
    }
  }

  offerGetPolicyForCreateApi() async {
    Response response = await post(
      '${Utils.apiUrl}/getPolicyForCreateOffer',
      {},
      headers: await utils.getHeaders(),
    );

    if (response.statusCode == 401) {
      await utils.logOutUser();
    }

    if (response.statusCode == 200) {
      var body = response.body;
      debugPrint('policy body $body');
      await isar.writeTxn(() async {
        await isar.policyColls.clear();
        await isar.policyColls.put(PolicyColl(
          returnExchangePolicy: body['returnExchangePolicy'],
          refundExchangeInDaysPolicy: body['refundExchangeInDaysPolicy'],
          warrantyPolicy: body['warrantyPolicy'],
          paymentPolicy: body['paymentPolicy'],
          otherPolicy:
          body['otherPolicy'], // Assign the "Other" policy text here
        ));
      });
    }
  }
}
