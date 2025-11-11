// import 'package:candid_vendors/Controllers/EditImagesController.dart';
// import 'package:candid_vendors/Utils/MyWidgets.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:sizer/sizer.dart';
//
// class EditImagesScreen extends StatelessWidget {
//   final List<XFile> images;
//   final String discountDropDownValue,
//       offerName,
//       offerDescription,
//       dropDownValue,
//       offerDiscount,
//       offerPrimeDiscount,
//       productName,
//       warranty,
//       refund,
//       delivery,
//       COD,
//       other,
//       maxNumClaims,
//       describeDealDetails,
//       stepsToRedeem,
//       selectedCategory,
//       selectedOfferType,
//       productDescription,
//       selectedCity,
//       selectedState,
//       offerDiscountType;
//   final DateTime selectedStartDate, selectedEndDate;
//
//   const EditImagesScreen(
//       {Key? key,
//         required this.images,
//         required this.discountDropDownValue,
//         required this.offerName,
//         required this.productName,
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
//         required this.warranty,
//         required this.refund,
//         required this.delivery,
//         required this.COD,
//         required this.other,
//         required this.stepsToRedeem,
//         required this.maxNumClaims,
//         required this.describeDealDetails,
//         required this.selectedState,
//         required this.offerDiscountType,
//         })
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder(
//       init: EditImagesController(
//           maxNumClaims: maxNumClaims,
//           describeDealDetails: describeDealDetails,
//           stepsToRedeem: stepsToRedeem,
//           images: images,
//           discountDropDownValue: discountDropDownValue,
//           dropDownValue: dropDownValue,
//           offerDescription: offerDescription,
//           offerDiscount: offerDiscount,
//           offerName: offerName,
//           productName: productName,
//           warranty: warranty,
//           refund:refund,
//           delivery: delivery,
//           COD: COD,
//           other:other,
//           offerPrimeDiscount: offerPrimeDiscount,
//           selectedStartDate: selectedStartDate,
//           selectedEndDate: selectedEndDate,
//           selectedCategory: selectedCategory,
//           selectedOfferType: selectedOfferType,
//           productDescription: productDescription,
//           selectedCity: selectedCity,
//           selectedState: selectedState,
//           offerDiscountType: offerDiscountType,
//         ),
//       builder: (controller) {
//         return Scaffold(
//           resizeToAvoidBottomInset: false,
//           appBar: AppBar(
//             title: const Text('Edit Images'),
//           ),
//           body: Center(
//             child: AnimatedSwitcher(
//               duration: const Duration(seconds: 1),
//               child: SizedBox(
//                 height: 100.h,
//                 width: 90.w,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                         height: 60.h,
//                         child: Center(
//                           child: controller.imagesData.isEmpty
//                               ? const Center(
//                             child: CircularProgressIndicator(),
//                           )
//                               : Image.memory(
//                               controller.imagesData[controller.selectedImageIndex]),
//                         )),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8),
//                       child: SizedBox(
//                         height: 5.h,
//                         width: 90.w,
//                         child: MyWidgets().getLargeButton(
//                           bgColor: Colors.blue.shade900,
//                           title: 'Edit Image',
//                           onPress: controller.changeImageStyle,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: SizedBox(
//                         height: 5.h,
//                         width: 90.w,
//                         child: MyWidgets().getLargeButton(
//                           bgColor: Colors.blue.shade900,
//                           title: 'Reset Image',
//                           onPress: controller.resetImageStyleToOriginal,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8, bottom: 8),
//                       child: SizedBox(
//                         height: 5.h,
//                         width: 90.w,
//                         child: MyWidgets().getLargeButton(
//                           bgColor: Colors.blue.shade900,
//                           title: 'Offer Preview',
//                           onPress: controller.openOfferPreview,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Align(
//                         alignment: FractionalOffset.bottomCenter,
//                         child: Container(
//                           height: 10.h,
//                           width: 90.w,
//                           color: Colors.pink.shade100,
//                           child: AnimatedSwitcher(
//                             duration: const Duration(seconds: 1),
//                             child: controller.footerImagesData.isEmpty
//                                 ? const Center(
//                               child: CircularProgressIndicator(),
//                             )
//                                 : GridView.builder(
//                               itemCount: controller.footerImagesData.length,
//                               scrollDirection: Axis.horizontal,
//                               shrinkWrap: true,
//                               gridDelegate:
//                               const SliverGridDelegateWithMaxCrossAxisExtent(
//                                   maxCrossAxisExtent: 100,
//                                   childAspectRatio: 6 / 3,
//                                   crossAxisSpacing: 20,
//                                   mainAxisSpacing: 20),
//                               itemBuilder: (context, index) {
//                                 return Stack(
//                                   children: [
//                                     InkWell(
//                                       onTap: () =>
//                                           controller.changeSelectedIndex(index),
//                                       child: Container(
//                                           height: double.infinity,
//                                           width: double.infinity,
//                                           color: Colors.blue.shade900,
//                                           alignment: Alignment.center,
//                                           child: Image.memory(
//                                               fit: BoxFit.fill,
//                                               controller.footerImagesData[index])),
//                                     ),
//                                     Visibility(
//                                       visible:
//                                       controller.selectedImageIndex == index,
//                                       child: Container(
//                                         color: Colors.black12,
//                                         height: double.infinity,
//                                         width: double.infinity,
//                                         child: const Icon(Icons.done_outline),
//                                       ),
//                                     )
//                                   ],
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }