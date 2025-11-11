// import 'package:candid_vendors/Screens/OfferScreens/OfferPreviewScreen.dart';
// import 'package:candid_vendors/main.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:share_plus/share_plus.dart';
//
// class EditImagesController extends GetxController {
//   late final List<XFile> images;
//   List<XFile> defaultImageToReset = [];
//   int selectedImageIndex = 0;
//   List<Uint8List> footerImagesData = [];
//   List<Uint8List> imagesData = [];
//
//   final String discountDropDownValue,
//       offerName,
//       offerDescription,
//       dropDownValue,
//       warranty,
//       refund,
//       delivery,
//       COD,
//       maxNumClaims,
//       describeDealDetails,
//       stepsToRedeem,
//       other,
//       offerDiscount,
//       offerPrimeDiscount,
//       productName,
//       selectedCategory,
//       selectedOfferType,
//       productDescription,
//       selectedCity,
//       selectedState,
//       offerDiscountType;
//
//   final DateTime selectedStartDate, selectedEndDate;
//
//   EditImagesController(
//       {required this.images,
//         required this.discountDropDownValue,
//         required this.offerName,
//         required this.productName,
//         required this.stepsToRedeem,
//         required this.maxNumClaims,
//         required this.describeDealDetails,
//         required this.offerDescription,
//         required this.dropDownValue,
//         required this.offerDiscount,
//         required this.offerPrimeDiscount,
//         required this.selectedStartDate,
//         required this.selectedEndDate,
//         required this.selectedCategory,
//         required this.selectedOfferType,
//         required this.productDescription,
//         required this.selectedCity,
//         required this.selectedState,
//         required this.warranty,
//         required this.refund,
//         required this.delivery,
//         required this.COD,
//         required this.other,
//         required this.offerDiscountType});
//
//   @override
//   Future<void> onInit() async {
//     super.onInit();
//     for (var image in images) {
//       imagesData.add((await image.readAsBytes()));
//       footerImagesData.add((await image.readAsBytes()));
//       defaultImageToReset.add(image);
//     }
//     update();
//   }
//
//   openOfferPreview() async =>
//       await Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(
//           builder: (BuildContext context) => OfferPreviewScreen(
//               images: images,
//               discountDropDownValue: discountDropDownValue,
//               offerName: offerName,
//               warranty: warranty,
//               refund:refund,
//               delivery: delivery,
//               COD: COD,
//               other:other,
//               maxNumClaims: maxNumClaims,
//               describeDealDetails: describeDealDetails,
//               stepsToRedeem: stepsToRedeem,
//               productName: productName,
//               dropDownValue: dropDownValue,
//               offerDiscount: offerDiscount,
//               offerDescription: offerDescription,
//               offerPrimeDiscount: offerPrimeDiscount,
//               selectedStartDate: selectedStartDate,
//               selectedEndDate: selectedEndDate,
//               selectedCategory: selectedCategory,
//               selectedOfferType: selectedOfferType,
//               productDescription: productDescription,
//               selectedCity: selectedCity,
//               selectedState: selectedState,
//               offerDiscountType: offerDiscountType,
//             offerDiscountedPrice: '',
//             offerPrimeDiscountedPrice: '',
//             unitPrice2: '',
//             regularDiscountNumber: '',
//             primeDiscountNumber: '',
//             primeUnitPrice: '',
//             primeDiscountedPrice: '',
//             regularUnitPrice: '',
//           )));
//
//   resetImageStyleToOriginal() async {
//     imagesData[selectedImageIndex] = footerImagesData[selectedImageIndex];
//     images[selectedImageIndex] = defaultImageToReset[selectedImageIndex];
//     update();
//   }
//
//   changeImageStyle() async {
//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//       sourcePath: images[selectedImageIndex].path,
//       aspectRatioPresets: [
//         CropAspectRatioPreset.square,
//         CropAspectRatioPreset.ratio3x2,
//         CropAspectRatioPreset.original,
//         CropAspectRatioPreset.ratio4x3,
//         CropAspectRatioPreset.ratio16x9,
//         CropAspectRatioPreset.ratio5x3,
//         CropAspectRatioPreset.ratio5x4,
//         CropAspectRatioPreset.ratio7x5
//       ],
//       uiSettings: [
//         AndroidUiSettings(
//             toolbarTitle: 'Cropper',
//             toolbarColor: Colors.deepOrange,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false),
//         IOSUiSettings(
//           title: 'Cropper',
//         ),
//         WebUiSettings(
//           context: navigatorKey.currentContext!,
//         ),
//       ],
//     );
//     try {
//       imagesData[selectedImageIndex] = (await croppedFile?.readAsBytes())!;
//       images[selectedImageIndex] = XFile(croppedFile!.path);
//       update();
//     } catch (e) {
//       debugPrint('CATCH: EDIT image: $e');
//     }
//   }
//
//   changeSelectedIndex(int index) {
//     selectedImageIndex = index;
//     update();
//   }
// }