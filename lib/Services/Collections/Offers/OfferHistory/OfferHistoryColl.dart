import 'package:isar/isar.dart';

part 'OfferHistoryColl.g.dart';

// run command to generate file - flutter pub run build_runner build --delete-conflicting-outputs
// run command to use localhost api - adb reverse tcp:3636 tcp:3636
// run command to use firebase localhost api - adb reverse tcp:5001 tcp:5001

@collection
class OfferHistoryColl {
  var id = Isar.autoIncrement; // you can also use id = null to auto increment

  @Index(unique: true, type: IndexType.value, replace: true)
  final String offerID;
  //final String regularDiscountNumber;
//  final double regularUnitPrice;

  // Prime Discount fields
//  final String primeDiscountNumber;
//  final double primeUnitPrice;
//  final double primeDiscountedPrice;
  final String offerName,
      discountNoPrime,
      userPinCode,
      offerDiscountedPrice,
      offerPrimeDiscountedPrice,
      maxNumClaims,
      // describeDealDetails,
      // stepsToRedeem,
      userOutletAddress1,
      userOutletAddress2,
      userMobile1,
      userMobile2,
      userOutletAddressBuildingStreetArea,
    //  termsAndCondition,
      discountNo,
      offerType,
      regularUnitPrice,
      catId,
      userBusinessName,
      unitPrice2,
      offerDescription,
      warranty,
      refund,
      delivery,
      COD,
      other,
      discountNo2,
      offersPackageId,
      discountType,
      discountUoM,
      productType,
      productName,
      userEmail1,
      selectedCity,
      selectedState,
      productDescription;

  bool isInStock, isTrending, isBigDays;
  double latitude, longitude, views;


  @enumerated
  OfferStatus offerStatus = OfferStatus.created;

  final DateTime createTime, selectedStartDate;
  DateTime selectedEndDate;

  final List<String> offerImages;

  OfferHistoryColl(
      {required this.offerID,
      required this.latitude,
      required this.longitude,
        required this.userOutletAddressBuildingStreetArea,
        required this.userOutletAddress1,
        required this.userOutletAddress2,
        required this.userMobile1,
        required this.userMobile2,
   //   required this.termsAndCondition,
     required this.maxNumClaims,
        required this.offerDiscountedPrice,
        required this.offerPrimeDiscountedPrice,
        required this.regularUnitPrice,
      // required this.describeDealDetails,
      // required this.stepsToRedeem,
      required this.userPinCode,
      required this.discountNo,
      required this.offerType,
        required this.unitPrice2,
      required this.catId,
        required this.userEmail1,
        required this.userBusinessName,
      required this.offerStatus,
      required this.offerDescription,
      required this.discountNo2,
      required this.offersPackageId,
      required this.discountType,
      required this.productType,
      required this.createTime,
      required this.isTrending,
        required this.isBigDays,
      required this.selectedStartDate,
   //    required this.regularDiscountNumber,
     //   required this.regularUnitPrice,
    ////    required this.primeDiscountNumber,
     //   required this.primeUnitPrice,
     //   required this.primeDiscountedPrice,
      required this.selectedEndDate,
      required this.offerName,
      required this.productName,
      required this.discountNoPrime,
      required this.discountUoM,
      required this.isInStock,
      required this.offerImages,
        required this.warranty,
        required this.refund,
        required this.delivery,
        required this.COD,
        required this.other,
      required this.selectedCity,
      required this.selectedState,
      required this.productDescription,
      required this.views});

  Map<String, dynamic> toMap() {
    return {
      'warranty': warranty,
      'refund':refund,
      'COD':COD,
      'other':other,
      'regularUnitPrice':regularUnitPrice,
      'maxNumClaims':maxNumClaims,
      // 'describeDealDetails':describeDealDetails,
      // 'stepsToRedeem':stepsToRedeem,
      'delivery':delivery,
      'userBusinessName': userBusinessName,
      'offerID': offerID,
      'latitude': latitude,
      'longitude': longitude,
      'userPinCode': userPinCode,
      'discountNo': discountNo,
      'userMobile1': userMobile1,
      'userMobile2': userMobile2,
      'offerType': offerType,
      'catId': catId,
      'offerStatus': offerStatus.toString().split('.')[1],
      'offerDescription': offerDescription,
      'discountNo2': discountNo2,
      'offersPackageId': offersPackageId,
      'discountType': discountType,
      'productType': productType,
      'createTime': createTime.toIso8601String(),
      'isTrending': isTrending,
      'isBigDays': isBigDays,
      'selectedStartDate': selectedStartDate.toIso8601String(),
      'selectedEndDate': selectedEndDate.toIso8601String(),
      'offerName': offerName,
      'productName': productName,
      'discountNoPrime': discountNoPrime,
      'isInStock': isInStock,
      'offerImages': offerImages,
      'offerDiscountedPrice':offerDiscountedPrice,
      'offerPrimeDiscountedPrice':offerPrimeDiscountedPrice,
      'selectedCity': selectedCity,
      'selectedState': selectedState,
     'productDescription': productDescription,
      'views': views,
   };
  }
}

enum OfferStatus {
  created,
  live,
  available,
  expired,
  totalEncash,
  outOfStock,
  rejected,
}
