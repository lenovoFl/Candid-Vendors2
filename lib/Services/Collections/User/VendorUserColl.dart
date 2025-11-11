import 'package:isar/isar.dart';

part 'VendorUserColl.g.dart';

// run command to generate file - flutter pub run build_runner build
// run command to use localhost api - adb reverse tcp:3636 tcp:3636

@embedded
class CurrentSelectionData {
  late final Module module;
}

@embedded
class Module {
  final String moduleId;
  final String moduleName;
  final String moduleCode;

  Module({
    this.moduleId = '',
    this.moduleName = '',
    this.moduleCode = '',
  });
}

@embedded
class Outlet {
  // Nullable + Safe default values
  double lat;
  double long;
  String userOutletID;
  String userOutletAddress1;
  String storeName;
  String userOutletAddress2;
  String userOutletAddressBuildingStreetArea;
  String userOutletAddressPinCode;
  String userOutletAddressCity;
  String userOutletAddressState;

  Outlet({
    double? lat,
    double? long,
    this.userOutletAddress1 = '',
    this.storeName = '',
    this.userOutletAddress2 = '',
    this.userOutletAddressBuildingStreetArea = '',
    this.userOutletAddressCity = '',
    this.userOutletAddressPinCode = '',
    this.userOutletAddressState = '',
    this.userOutletID = '',
  })  : lat = lat ?? 0.0,
        long = long ?? 0.0;
}

@collection
class VendorUserColl {
  Id? id; // auto increment

  bool isActive;

  final DateTime userJoinedSince;
  DateTime candidOfferSubscriptionStartDate;
  DateTime candidOfferSubscriptionEndDate;
  DateTime candidOfferSubscriptionPlanStartDate;
  DateTime candidOfferSubscriptionPlanEndDate;

  int offerCount;

  String userId;
  String userAuthToken;
  String storeRating;
  String profileStatus;
  String userToken;
  String bankAccountHolderName;
  String bankAccountHolderAcNumber;
  String bankAccountHolderAc1Number;
  String bankAccountHolderIFSC;
  String bankAccountHolderIFSC1;
  String bankAccountHolderBankName;
  String bankAccountHolderBankBranch;
  String userName;
  String storeName;
  String userBusinessName;
  String userProfilePic;
  String userCompanyLogo;
  String userAddress;
  String userGroupId;
  String userGroupName;
  String userGroupLevel;
  String userFullName;
  String userMobile1;
  String userMobile2;
  String userGender;
  String userEmail1;
  String userEmail2;
  String firebaseMessagingToken;
  String referredBy;
  String vendorQRImgUrl;
  String userAddressCity;
  String userAddressState;

  final CurrentSelectionData currentSelectionData;
  final List<Module> allowedModules;

  List<Outlet> myOutlets = List.empty(growable: true);

  VendorUserColl({
    required this.userId,
    required this.userEmail1,
    required this.storeRating,
    required this.profileStatus,
    required this.firebaseMessagingToken,
    required this.userEmail2,
    required this.userCompanyLogo,
    required this.bankAccountHolderAc1Number,
    required this.bankAccountHolderAcNumber,
    required this.bankAccountHolderBankBranch,
    required this.bankAccountHolderBankName,
    required this.bankAccountHolderIFSC,
    required this.bankAccountHolderIFSC1,
    required this.bankAccountHolderName,
    required this.isActive,
    required this.userGender,
    required this.storeName,
    required this.userMobile1,
    required this.currentSelectionData,
    required this.userMobile2,
    required this.userFullName,
    required this.userGroupLevel,
    required this.userGroupId,
    required this.userGroupName,
    required this.userAddress,
    required this.userAuthToken,
    required this.userJoinedSince,
    required this.userBusinessName,
    required this.userName,
    required this.myOutlets,
    required this.userProfilePic,
    required this.allowedModules,
    required this.offerCount,
    required this.candidOfferSubscriptionStartDate,
    required this.candidOfferSubscriptionEndDate,
    required this.referredBy,
    required this.vendorQRImgUrl,
    required this.userToken,
    required this.userAddressCity,
    required this.userAddressState,
    required this.candidOfferSubscriptionPlanStartDate,
    required this.candidOfferSubscriptionPlanEndDate,
  });

  // ✅ Factory method for safe JSON parsing
  factory VendorUserColl.fromJson(Map<String, dynamic> json) {
    return VendorUserColl(
      userId: json['userId'] ?? '',
      userEmail1: json['userEmail1'] ?? '',
      storeRating: json['storeRating'] ?? '',
      profileStatus: json['profileStatus'] ?? '',
      firebaseMessagingToken: json['firebaseMessagingToken'] ?? '',
      userEmail2: json['userEmail2'] ?? '',
      userCompanyLogo: json['userCompanyLogo'] ?? '',
      bankAccountHolderAc1Number: json['bankAccountHolderAc1Number'] ?? '',
      bankAccountHolderAcNumber: json['bankAccountHolderAcNumber'] ?? '',
      bankAccountHolderBankBranch: json['bankAccountHolderBankBranch'] ?? '',
      bankAccountHolderBankName: json['bankAccountHolderBankName'] ?? '',
      bankAccountHolderIFSC: json['bankAccountHolderIFSC'] ?? '',
      bankAccountHolderIFSC1: json['bankAccountHolderIFSC1'] ?? '',
      bankAccountHolderName: json['bankAccountHolderName'] ?? '',
      isActive: json['isActive'] ?? true,
      userGender: json['userGender'] ?? '',
      storeName: json['storeName'] ?? '',
      userMobile1: json['userMobile1'] ?? '',
      currentSelectionData: CurrentSelectionData()
        ..module = Module(
          moduleId: json['currentSelectionData']?['module']?['moduleId'] ?? '',
          moduleName: json['currentSelectionData']?['module']?['moduleName'] ?? '',
          moduleCode: json['currentSelectionData']?['module']?['moduleCode'] ?? '',
        ),
      userMobile2: json['userMobile2'] ?? '',
      userFullName: json['userFullName'] ?? '',
      userGroupLevel: json['userGroupLevel'] ?? '',
      userGroupId: json['userGroupId'] ?? '',
      userGroupName: json['userGroupName'] ?? '',
      userAddress: json['userAddress'] ?? '',
      userAuthToken: json['userAuthToken'] ?? '',
      userJoinedSince: DateTime.tryParse(json['userJoinedSince'] ?? '') ?? DateTime.now(),
      userBusinessName: json['userBusinessName'] ?? '',
      userName: json['userName'] ?? '',
      myOutlets: (json['myOutlets'] as List? ?? [])
          .map((e) => Outlet(
        lat: (e['lat'] ?? 0.0).toDouble(),
        long: (e['long'] ?? 0.0).toDouble(),
        userOutletAddress1: e['userOutletAddress1'] ?? '',
        storeName: e['storeName'] ?? '',
        userOutletAddress2: e['userOutletAddress2'] ?? '',
        userOutletAddressBuildingStreetArea:
        e['userOutletAddressBuildingStreetArea'] ?? '',
        userOutletAddressCity: e['userOutletAddressCity'] ?? '',
        userOutletAddressPinCode: e['userOutletAddressPinCode'] ?? '',
        userOutletAddressState: e['userOutletAddressState'] ?? '',
        userOutletID: e['userOutletID'] ?? '',
      ))
          .toList(),
      userProfilePic: json['userProfilePic'] ?? '',
      allowedModules: (json['allowedModules'] as List? ?? [])
          .map((e) => Module(
        moduleId: e['moduleId'] ?? '',
        moduleName: e['moduleName'] ?? '',
        moduleCode: e['moduleCode'] ?? '',
      ))
          .toList(),
      offerCount: json['offerCount'] ?? 0,
      candidOfferSubscriptionStartDate:
      DateTime.tryParse(json['candidOfferSubscriptionStartDate'] ?? '') ??
          DateTime.now(),
      candidOfferSubscriptionEndDate:
      DateTime.tryParse(json['candidOfferSubscriptionEndDate'] ?? '') ??
          DateTime.now(),
      referredBy: json['referredBy'] ?? '',
      vendorQRImgUrl: json['vendorQRImgUrl'] ?? '',
      userToken: json['userToken'] ?? '',
      userAddressCity: json['userAddressCity'] ?? '',
      userAddressState: json['userAddressState'] ?? '',
      candidOfferSubscriptionPlanStartDate:
      DateTime.tryParse(json['candidOfferSubscriptionPlanStartDate'] ?? '') ??
          DateTime.now(),
      candidOfferSubscriptionPlanEndDate:
      DateTime.tryParse(json['candidOfferSubscriptionPlanEndDate'] ?? '') ??
          DateTime.now(),
    );
  }
}
