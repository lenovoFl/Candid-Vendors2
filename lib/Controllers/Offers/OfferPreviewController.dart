import 'dart:async';
import 'package:candid_vendors/Services/Collections/User/VendorUserColl.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:isar/isar.dart';
import 'package:share_plus/share_plus.dart';

import '../../Services/APIs/Offers/OffersConnect.dart';
import '../../Utils/Utils.dart';
import '../../main.dart';
import '../Notification/NotificationController.dart';

class OfferPreviewController extends GetxController {
//  TextEditingController maxNumClaimsController = TextEditingController();
  TextEditingController countedPrimeDiscountController = TextEditingController();
  TextEditingController countedDiscountController = TextEditingController();
  // TextEditingController describeDealDetailsController = TextEditingController();
  //TextEditingController termsAndConditionController = TextEditingController();
  // TextEditingController stepsToRedeemController = TextEditingController();
//  TextEditingController warrantyController = TextEditingController();
  // TextEditingController refundController = TextEditingController();
//  TextEditingController deliveryController = TextEditingController();

  // paymentController = TextEditingController(),
  //TextEditingController otherController = TextEditingController();
  // TextEditingController CODController = TextEditingController();

  bool showMap = false;
  bool isLoading = true,
      isOfferCreated = false;
  String offerDiscountedPrice = '';
  late LatLng center;
  late CameraPosition kOutlet;
  late Completer<GoogleMapController> googleMapController =
  Completer<GoogleMapController>();
  CameraPosition? kGooglePlex;

  String message = 'Creating offer for you!',

      currentOfferImg = '',
      offerID = '',
      offerAddress = '';
  final List<XFile> images;

  final String discountDropDownValue,
      offerName,
      offerDescription,
      dropDownValue,
      offerDiscount,
      offerPrimeDiscount,
      unitPrice2,
      warranty,
      refund,
      delivery,
      COD,
      other,
      maxNumClaims,
      // describeDealDetails,
      // stepsToRedeem,
      regularDiscountNumber,
      primeDiscountNumber,
      primeUnitPrice,
      primeDiscountedPrice,
      regularUnitPrice,
      productName,
      offerPrimeDiscountedPrice,
      selectedCategory,
      selectedOfferType,
      productDescription,
      selectedCity,
      selectedState,
      offerDiscountType,
      selectedCatID;
  final DateTime selectedStartDate, selectedEndDate;

  OfferPreviewController({
    required this.images,
    required this.discountDropDownValue,
    required this.offerDiscountedPrice,
    required this.offerPrimeDiscount,
    required this.offerPrimeDiscountedPrice,
    required this.offerName,
    required this.regularDiscountNumber,
    required this.primeDiscountNumber,
    required this.primeUnitPrice,
    required this.primeDiscountedPrice,
    required this.regularUnitPrice,
    required this.productName,
    required this.offerDescription,
    required this.dropDownValue,
    required this.offerDiscount,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.selectedCategory,
    required this.selectedOfferType,
    required this.productDescription,
    required this.selectedCity,
    required this.selectedState,
    // required this.stepsToRedeem,
    required this.maxNumClaims,
    // required this.describeDealDetails,
    required this.warranty,
    required this.refund,
    required this.delivery,
    required this.COD,
    required this.other,
    required this.offerDiscountType,
    required this.unitPrice2,
    required this.selectedCatID,
  });

  late VendorUserColl user;

  late Placemark placeMark;

  @override
  Future<void> onInit() async {
    super.onInit();
    try {
      center = const LatLng(0.0, 0.0);
      user = (await isar.vendorUserColls.filter().userIdIsNotEmpty().build().findFirst())!;
      placeMark = (await placemarkFromCoordinates(user.myOutlets.first.lat, user.myOutlets.first.long,)).first;
      offerAddress = '${placeMark.subLocality}, ${placeMark.locality}, '
          '${user.myOutlets.first.userOutletAddress1}, '
          '${user.myOutlets.first.userOutletAddress2},'
          ' ${user.myOutlets.first.userOutletAddressBuildingStreetArea}';

      // Check  location permissions before accessing the current plosition
      bool locationPermissionGranted = await _checkLocationPermission();
      if (locationPermissionGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        center = LatLng(position.latitude, position.longitude);
        kOutlet = CameraPosition(target: center, zoom: 19.151926040649414);
      } else {
        // Handle permission denied
        throw PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Location permission not granted',
        );
      }
      isLoading = false;
      update();
    } catch (e) {
      utils.showSnackBar('An error occurred');
    }
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  shareOfferOnSocialMedia({required OfferPreviewController offer}) async {
    DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
        link: Uri.parse(
            "https://candidcustomer.page.link.com/?offerID=$offerID"),
        uriPrefix: "https://candidcustomer.page.link",
        androidParameters: const AndroidParameters(
            packageName: "com.customer.candid.candid_customer",
            minimumVersion: 1),
        iosParameters: const IOSParameters(
            bundleId: "com.customer.candid.candidCustomer",
            minimumVersion: "1"),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: offerName,
            description: offerDescription,
            imageUrl: Uri.parse(currentOfferImg)));
    final dynamicLink = await firebaseDynamicLinks.buildShortLink(
        dynamicLinkParams,
        shortLinkType: ShortDynamicLinkType.unguessable);

    // final dynamicLink1 =
    //     await firebaseDynamicLinks.buildLink(dynamicLinkParams);
    // debugPrint('dynamicLink1 : $dynamicLink1');
    Share.share('Checkout this offer ${dynamicLink.shortUrl}');
  }

  createOffer() async {
    try {
      isLoading = true;
      update();
      print('Starting createOffer');
      print('Notification triggered');
      print('UserID: ${(await Utils().getUser()).userId}');
      print('PlaceMark: $placeMark');
      print('Outlet Latitude: ${user.myOutlets.first.lat}');
      print('Outlet Longitude: ${user.myOutlets.first.long}');

      // Ensure the offerCreateMap has all necessary fields and provide default values if necessary
      var offerCreateMap = createOfferCreateMap(
        placeMark,
        user.myOutlets.first.lat,
        user.myOutlets.first.long,
      );
      offerCreateMap['userMobile1'] = offerCreateMap['userMobile1'] ?? '';
      offerCreateMap['userEmail1'] = offerCreateMap['userEmail1'] ?? '';
      offerCreateMap['userMobile2'] = offerCreateMap['userMobile2'] ?? '';
      await OffersConnect().createOfferApi(
        userId: (await Utils().getUser()).userId,
        controller: this,
        offerCreateMap: offerCreateMap,
      );
      NotificationController notificationController = Get.find();
      notificationController.triggerOfferCreatedNotification();
      print('Offer creation completed');

      // Trigger the review notification after a delay of 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        notificationController.triggerOffergoesForReviewNotification();
        print('Review notification triggered after delay');
      });
    } catch (e) {
      print('Error in createOffer: $e');
      isLoading = false;
      update();
    }
  }



  Future<void> goToTheOutlet() async {
    await (await googleMapController.future).animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center, zoom: 19.151926040649414)));
    update();
  }

  onGoogleMapTap(LatLng latLng) {
    center = LatLng(latLng.latitude, latLng.longitude);
    kOutlet = CameraPosition(target: center, zoom: 19.151926040649414);
    offerAddress = '${latLng.latitude}, ${latLng.longitude}';
    update();
  }

  createOfferCreateMap(Placemark placeMark, double latitude, double longitude) {
    // var latLongArr = [];
    // if (kDebugMode) {
    //   latLongArr.add({'latitude': 22.470701, 'longitude': 70.057732});
    //   latLongArr.add({'latitude': 21.7700, 'longitude': 72.1500});
    //   latLongArr.add({'latitude': 12.840711, 'longitude': 77.676369});
    // }
    return {
      'discountUoM': discountDropDownValue,
      'offerName': offerName,
      'userOutletAddress1': user.myOutlets.first.userOutletAddress1,
      'userOutletAddress2': user.myOutlets.first.userOutletAddress2,
      'userOutletAddressBuildingStreetArea' : user.myOutlets.first.userOutletAddressBuildingStreetArea,
      'productName': productName,
      'productDescription': productDescription,
      'selectedCity': selectedCity,
      'selectedState': selectedState,
      'regularUnitPrice':regularUnitPrice,
      'warranty': warranty,
      'refund': refund,
      'delivery': delivery,
      'COD': COD,
      'offerDiscountedPrice':offerDiscountedPrice,
      'offerPrimeDiscountedPrice':offerPrimeDiscountedPrice,
      'other': other,
      'unitPrice2':unitPrice2,
      'maxNumClaims': maxNumClaims,
      // 'describeDealDetails': describeDealDetails,
      // 'stepsToRedeem': stepsToRedeem,
      'offerDiscountType': offerDiscountType,
      'offerDescription': offerDescription,
      'postalCode': placeMark.postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'selectedCategory': selectedCategory,
      'selectedOfferType': selectedOfferType,
      'discountType': dropDownValue == 'Price' ? 1 : dropDownValue == 'Volume'
          ? 2
          : 3,
      'discountNo': offerDiscount,
      'discountNoPrime': offerPrimeDiscount,
      'selectedStartDate': selectedStartDate,
      'selectedEndDate': selectedEndDate,
      'offerImages': images,
      'isTrending': false,
      'isBigDays': false,
      'selectedCatID': selectedCatID,
    };
  }
}
