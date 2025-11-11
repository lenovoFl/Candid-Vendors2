import 'dart:async';
import 'dart:io';
import 'package:candid_vendors/BottomNavScreen.dart';
import 'package:candid_vendors/Screens/Profile/ProfileScreen.dart';
import 'package:candid_vendors/Services/APIs/Auth/UpdateProfile.dart';
import 'package:candid_vendors/Services/APIs/Policies/PoliciesConnect.dart';
import 'package:candid_vendors/Services/Collections/User/VendorUserColl.dart';
import 'package:candid_vendors/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';

import '../../Services/Collections/Offers/OfferHistory/OfferHistoryColl.dart';
import '../../Services/Collections/VendorPolicy/VendorPolicyColl.dart';

class ProfileController extends GetxController {
  bool isLoading = true, isPolicyAddView = true;
  VendorUserColl? user;
  bool showMap = false;
  late final VendorUserColl vendor;
  GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController(),
      address2Controller = TextEditingController(),
      //   storeNameController = TextEditingController(),
      pinCodeController = TextEditingController(),
      addressBuildingStreetAreaController = TextEditingController();
  //TextEditingController storeNameController = TextEditingController();
  TextEditingController areaNameController = TextEditingController();
  TextEditingController mapLocationController = TextEditingController();
  File? logoFile;
  TextEditingController googleUrlController = TextEditingController();
  TextEditingController instagramUrlController = TextEditingController();
  TextEditingController youtubeUrlController = TextEditingController();
  TextEditingController facebookUrlController = TextEditingController(),
      // addressController = TextEditingController(),
      contactController = TextEditingController(),
      bankAccountHolderNameEditingController = TextEditingController(),
      bankAccountHolderAcNumberController = TextEditingController(),
      bankAccountHolderAc1NumberController = TextEditingController(),
      bankAccountHolderIFSCController = TextEditingController(),
      bankAccountHolderIFSC1Controller = TextEditingController(),
      bankAccountHolderBankNameController = TextEditingController(),
      bankAccountHolderBankBranchController = TextEditingController(),
      selectedTCText = TextEditingController();
  List<String> list = <String>[
    'warranty',
    'refund',
    'delivery',
    'COD',
    'other'
  ];
  String selectedTCFor = '';
  VendorPolicyColl? vendorPolicyColl;
  RxList<String> contactNumbers = <String>[].obs;
  RxString newContactNumber = ''.obs;
  late Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();
  CameraPosition? kGooglePlex;
  late LatLng center;
  CameraPosition? kOutlet;

  updateProfile() async {
    if (!editProfileFormKey.currentState!.validate()) {
      utils.showSnackBar('Fields are required!');
      return;
    }
    try {
      isLoading = true;
      update();
      await UpdateProfile()
          .updateProfileApi(isProfileImgUpdateOnly: false, userData: {
        'userEmail1': emailController.text,
        'userAddress': addressController.text,
        'userMobile1': contactController.text
      });
      isLoading = false;
      update();
    } catch (e) {
      isLoading = false;
      update();
      debugPrint('Profile controller: update profile catch: E $e');
    }
  }

  int countOffersByStatus(List<OfferHistoryColl> offers, OfferStatus status) {
    return offers.where((offer) => offer.offerStatus == status).length;
  }

  void updateContactNumber(String newContactNumber) async {
    try {
      isLoading = true;
      update();
      await UpdateProfile().updateProfileApi(
        isProfileImgUpdateOnly: false,
        userData: {
          'userMobile1': newContactNumber,
        },
      );
      isLoading = false;
      update();
    } catch (e) {
      isLoading = false;
      update();
      debugPrint('Profile controller: update contact number catch: E $e');
    }
  }

  Future<int> getTotalOffers() async {
    final collection = FirebaseFirestore.instance.collection(
        'candidOffers'); // Replace 'offers' with your actual collection name
    final querySnapshot = await collection.get();
    return querySnapshot.size;
  }

  // onGoogleMapTap(LatLng latLng) {
  //   center = LatLng(latLng.latitude, latLng.longitude);
  //   kGooglePlex = CameraPosition(
  //     target: center,
  //     zoom: 14.4746,
  //   );
  //   kOutlet = CameraPosition(target: center, zoom: 19.151926040649414);
  //   update();
  // }

  changeProfileImg(BuildContext context) async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      try {
        isLoading = true;
        update();
        var fullRefStorage = firebaseStorage.ref().child(
            'candidVendors/${(await utils.getUser()).userId}/profileImage');
        await fullRefStorage.putFile(File(file.path));
        var downloadURL = await fullRefStorage.getDownloadURL();
        await UpdateProfile()
            .updateProfileApi(isProfileImgUpdateOnly: true, userData: {
          'userProfilePic': downloadURL,
        });
        isLoading = false;
        update();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const BottomNavScreen(), // Replace 'AccountScreen()' with your actual account screen widget.
          ),
        );
      } catch (e) {
        isLoading = false;
        update();
        debugPrint('problem with upload image | CATCH : E | $e');
      }
    }
  }

  @override
  Future<void> onInit() async {
    user = await isar.vendorUserColls.buildQuery().findFirst();

    isar.vendorUserColls.watchLazy(fireImmediately: true).listen((event) async {
      user = await isar.vendorUserColls.buildQuery().findFirst();
      update();
    });
    // contactNumber.value = user?.userMobile1 ?? '';
    isLoading = false;

    if (kDebugMode) {
      emailController.text = user?.userEmail1 ?? 'abc@gmail.com';
      bankAccountHolderAc1NumberController.text =
          '1234567890'; // Replace with your debug data
      bankAccountHolderIFSCController.text = 'ABC1234';
      bankAccountHolderNameEditingController.text = 'Vijay';
      bankAccountHolderBankBranchController.text = 'Infocity';
      addressController.text =
          user?.userAddress ?? 'abc road, abcde city, india';
      contactController.text =
          user?.userMobile1.replaceAll("+91", "") ?? '9377008214';
    } else {
      bankAccountHolderNameEditingController.text = '';
      bankAccountHolderAcNumberController.text = '';
      //bankAccountHolderAc1NumberController.text = '';
      bankAccountHolderIFSCController.text = '';
      //  bankAccountHolderIFSC1Controller.text = '';
      bankAccountHolderBankNameController.text = '';
      bankAccountHolderBankBranchController.text = '';
      emailController.text = user?.userEmail1 ?? '';
      addressController.text = user?.userAddress ?? '';
      contactController.text = user?.userMobile1.replaceAll("+91", "") ?? '';
    }
    selectedTCFor = list.first;
    vendorPolicyColl = await isar.vendorPolicyColls.where().build().findFirst();
    update();
    super.onInit();
  }

  @override
  void dispose() {
    //  storeNameController.dispose();
    areaNameController.dispose();
    mapLocationController.dispose();
    googleUrlController.dispose();
    instagramUrlController.dispose();
    youtubeUrlController.dispose();
    facebookUrlController.dispose();
    super.dispose();
  }

  Future<Isar?> openIsar() async {
    final isar = Isar.getInstance();
    return isar;
  }

  // void updateBankAccountDetails(String accountNumber, String ifscCode) {
  //   bankAccountHolderAc1NumberController.text = accountNumber;
  //   bankAccountHolderIFSCController.text = ifscCode;
  //   update();
  // }

  // changeValuePolicy({required VendorPolicyColl vendorPolicy}) {
  //   if (selectedTCFor == 'warranty') {
  //     selectedTCText.text = vendorPolicy.vendorWarrantyPolicy;
  //   }
  //   if (selectedTCFor == 'refund') {
  //     selectedTCText.text = vendorPolicy.vendorRefundPolicy;
  //   }
  //   if (selectedTCFor == 'delivery') {
  //     selectedTCText.text = vendorPolicy.vendorDelivery;
  //   }
  //   if (selectedTCFor == 'COD') {
  //     selectedTCText.text = vendorPolicy.vendorPaymentPolicy;
  //   }
  //   if (selectedTCFor == 'other') {
  //     selectedTCText.text = vendorPolicy.vendorOtherPolicy;
  //   }
  //   update();
  // }

//   showVendorPoliciesView() async {
//     vendorPolicyColl = await isar.vendorPolicyColls.where().build().findFirst();
//     changeValuePolicy(vendorPolicy: vendorPolicyColl!);
//     showGeneralDialog(
//       context: navigatorKey.currentContext!,
//       transitionBuilder: (context, a1, a2, child) {
//         var curve = Curves.easeInOut.transform(a1.value);
//         return Transform.scale(
//           scale: curve,
//           child: SafeArea(
//             child: Dialog(
//                 insetPadding: EdgeInsets.zero,
//                 child: SizedBox(
//                   height: double.infinity,
//                   width: double.infinity,
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     fit: StackFit.expand,
//                     children: [
//                       Center(
//                         child: AnimatedSwitcher(
//                           duration: const Duration(seconds: 1),
//                           child: isPolicyAddView
//                               ? SingleChildScrollView(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       FittedBox(
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           crossAxisAlignment: CrossAxisAlignment.center,
//                                           children: [
//                                             Text('Seller ID : ',
//                                                 textScaleFactor: 1.5,
//                                                 style: TextStyle(
//                                                     color: Colors.blue.shade900,
//                                                     fontWeight: FontWeight.bold)),
//                                             Text(user?.userId ?? '',
//                                                 textScaleFactor: 1.5,
//                                                 style: TextStyle(
//                                                     color: Colors.blue.shade900,
//                                                     fontWeight: FontWeight.bold)),
//                                           ],
//                                         ),
//                                       ),
//                                       FittedBox(
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           crossAxisAlignment: CrossAxisAlignment.center,
//                                           children: [
//                                             Text('Seller Name : ',
//                                                 textScaleFactor: 1.5,
//                                                 style: TextStyle(
//                                                     color: Colors.blue.shade900,
//                                                     fontWeight: FontWeight.bold)),
//                                             Text(user?.userFullName ?? '',
//                                                 textScaleFactor: 1.5,
//                                                 style: TextStyle(
//                                                     color: Colors.blue.shade900,
//                                                     fontWeight: FontWeight.bold)),
//                                           ],
//                                         ),
//                                       ),
//                                       Row(
//                                         children: [
//                                           Text('T&C For : ',
//                                               textScaleFactor: 1.5,
//                                               style: TextStyle(
//                                                   color: Colors.blue.shade900,
//                                                   fontWeight: FontWeight.bold)),
//                                           Expanded(
//                                             child: DropdownButtonFormField<String>(
//                                               value: selectedTCFor,
//                                               icon: const Icon(Icons.arrow_downward),
//                                               elevation: 16,
//                                               decoration: const InputDecoration(
//                                                   border: OutlineInputBorder(),
//                                                   hintText: 'Select T&C For',
//                                                   labelText: 'Select T&C For'),
//                                               style:
//                                                   TextStyle(color: Colors.blue.shade900),
//                                               onChanged: (String? value) {
//                                                 selectedTCFor = value!;
//                                                 if (selectedTCFor == "warranty") {
//                                                   selectedTCText.text = vendorPolicyColl
//                                                           ?.vendorWarrantyPolicy ??
//                                                       "";
//                                                 } else if (selectedTCFor == "refund") {
//                                                   selectedTCText.text = vendorPolicyColl
//                                                           ?.vendorRefundPolicy ??
//                                                       "";
//                                                 } else if (selectedTCFor == "delivery") {
//                                                   selectedTCText.text =
//                                                       vendorPolicyColl?.vendorDelivery ??
//                                                           "";
//                                                 } else if (selectedTCFor == "COD") {
//                                                   selectedTCText.text = vendorPolicyColl
//                                                           ?.vendorPaymentPolicy ??
//                                                       "";
//                                                 } else if (selectedTCFor == "other") {
//                                                   selectedTCText.text = vendorPolicyColl
//                                                           ?.vendorOtherPolicy ??
//                                                       "";
//                                                 }
//                                                 update();
//                                               },
//                                               items: list.map<DropdownMenuItem<String>>(
//                                                   (String value) {
//                                                 return DropdownMenuItem<String>(
//                                                   value: value,
//                                                   child: Text(value),
//                                                 );
//                                               }).toList(),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           Text('T&C Text : ',
//                                               textScaleFactor: 1.5,
//                                               style: TextStyle(
//                                                   color: Colors.blue.shade900,
//                                                   fontWeight: FontWeight.bold)),
//                                           Expanded(
//                                             child: TextFormField(
//                                               controller: selectedTCText,
//                                               maxLines: 4,
//                                               autovalidateMode: AutovalidateMode.always,
//                                               validator: (value) => utils.validateText(
//                                                   string: value.toString(),
//                                                   required: true),
//                                               decoration: InputDecoration(
//                                                   labelText:
//                                                       'Write T&C Text for $selectedTCFor',
//                                                   hintText:
//                                                       'Write T&C Text $selectedTCFor',
//                                                   border: const OutlineInputBorder()),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 8.0),
//                                         child: Column(children: [
//                                           Row(
//                                             children: [
//                                               const SizedBox(width: 20),
//                                               Expanded(
//                                                 child: myWidgets.getLargeButton(
//                                                   bgColor: Colors.blue.shade900,
//                                                   title: 'Save',
//                                                   onPress: () => PoliciesConnect()
//                                                       .updateVendorPolicyByPhoneApi(
//                                                     selectedTCFor: selectedTCFor,
//                                                     selectedTCText: selectedTCText.text,
//                                                     profileController: this,
//                                                     vendorPolicyColl: vendorPolicyColl,
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 20),
//                                               Expanded(
//                                                 child: myWidgets.getLargeButton(
//                                                   bgColor: Colors.blue.shade900,
//                                                   title: 'Cancel',
//                                                   onPress: () =>
//                                                       Navigator.of(context).pop(),
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 20),
//                                               Expanded(
//                                                 child: myWidgets.getLargeButton(
//                                                   bgColor: Colors.blue.shade900,
//                                                   title: 'Export',
//                                                   onPress: () {},
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 20),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 8),
//                                         ]),
//                                       ),

//                                       // Text('Return & exchange policy',
//                                       //     textScaleFactor: 1.5,
//                                       //     style: TextStyle(
//                                       //         color: Colors.blue.shade900,
//                                       //         fontWeight: FontWeight.bold)),
//                                       // SizedBox(
//                                       //     width: 90.w,
//                                       //     height: 35.h,
//                                       //     child: Card(
//                                       //       child: SingleChildScrollView(
//                                       //           child: Text(
//                                       //               policyColl
//                                       //                   .returnExchangePolicy,
//                                       //               textScaleFactor: 1.3)),
//                                       //     )),
//                                       // Text(
//                                       //   'Refund or Exchange In Days : ${policyColl.refundExchangeInDaysPolicy}',
//                                       //   textScaleFactor: 1.3,
//                                       // ),
//                                       // Text('Warranty Policy',
//                                       //     textScaleFactor: 1.5,
//                                       //     style: TextStyle(
//                                       //         color: Colors.blue.shade900,
//                                       //         fontWeight: FontWeight.bold)),
//                                       // SizedBox(
//                                       //     width: 90.w,
//                                       //     height: 35.h,
//                                       //     child: Card(
//                                       //       child: SingleChildScrollView(
//                                       //           child: Text(
//                                       //               policyColl.warrantyPolicy,
//                                       //               textScaleFactor: 1.3)),
//                                       //     )),
//                                       // Text(
//                                       //     'Payment Policy : ${policyColl.paymentPolicy == 'COD' ? 'Cash on delivery' : policyColl.paymentPolicy}',
//                                       //     textScaleFactor: 1.3)
//                                     ]
//                                         .map((e) => Padding(
//                                               padding: const EdgeInsets.only(top: 16.0),
//                                               child: e,
//                                             ))
//                                         .toList(),
//                                   ),
//                                 )
//                               : Center(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           const Expanded(
//                                             child: Text('Seller warranty policy'),
//                                           ),
//                                           Expanded(
//                                             child: SingleChildScrollView(
//                                               child: Text(
//                                                 vendorPolicyColl?.vendorWarrantyPolicy ??
//                                                     '',
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           const Expanded(
//                                             child: Text('Seller refund policy'),
//                                           ),
//                                           Expanded(
//                                             child: Text(
//                                               vendorPolicyColl?.vendorRefundPolicy ?? '',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           const Expanded(
//                                             child: Text('Seller delivery policy'),
//                                           ),
//                                           Expanded(
//                                             child: Text(
//                                               vendorPolicyColl?.vendorDelivery ?? '',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           const Expanded(
//                                             child: Text('Seller COD policy'),
//                                           ),
//                                           Expanded(
//                                             child: Text(
//                                               vendorPolicyColl?.vendorPaymentPolicy ?? '',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         // Add a row for "Other" policy
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           const Expanded(
//                                             child: Text('Seller Other policy'),
//                                           ),
//                                           Expanded(
//                                             child: SingleChildScrollView(
//                                               child: Text(
//                                                 vendorPolicyColl?.vendorOtherPolicy ?? '',
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ]
//                                         .map(
//                                           (e) => Padding(
//                                             padding: EdgeInsets.only(top: 5.h),
//                                             child: e,
//                                           ),
//                                         )
//                                         .toList(),
//                                   ),
//                                 ),
//                         ),
//                       ),
//                       Positioned(
//                         right: 0.0,
//                         child: InkResponse(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: const SizedBox(
//                             height: 50,
//                             width: 50,
//                             child: CircleAvatar(
//                               backgroundColor: Colors.transparent,
//                               child: Icon(
//                                 Icons.close,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )),
//           ),
//         );
//       },
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (context, animation, secondaryAnimation) {
//         return Container();
//       },
//     );
//   }
// }

// ContactNumber(String value) {}
}
