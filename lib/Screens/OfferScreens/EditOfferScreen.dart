// import 'package:candid_vendors/Controllers/Offers/EditOfferController.dart';
// import 'package:candid_vendors/Services/Collections/Offers/OfferHistory/OfferHistoryColl.dart';
// import 'package:candid_vendors/main.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:isar/isar.dart';
// import 'package:sizer/sizer.dart';
//
// class EditOfferScreen extends StatefulWidget {
//   final double widthFactor;
//   final int offerDocId;
//
//   const EditOfferScreen({super.key, required this.widthFactor, required this.offerDocId});
//
//   @override
//   EditOfferScreenState createState() => EditOfferScreenState();
// }
//
// class EditOfferScreenState extends State<EditOfferScreen> {
//   final TextEditingController termsAndConditionsController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: myWidgets.myAppbar(title: 'EDIT Offers', bottomNavController: bottomNavController, context: context, ),
//       body: SafeArea(
//         child: GetBuilder<EditOfferController>(
//           init: EditOfferController(),
//           builder: (controller) {
//             return StreamBuilder<List<OfferHistoryColl>>(
//               stream: isar.offerHistoryColls
//                   .filter()
//                   .idEqualTo(widget.offerDocId)
//                   .build()
//                   .watch(fireImmediately: true),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 var offer = snapshot.data?.first;
//                 if (offer == null) {
//                   return const Center(
//                     child: Text('Offer not found.'),
//                   );
//                 }
//                 return AnimatedSwitcher(
//                   duration: const Duration(seconds: 1),
//                   child: controller.isLoading
//                       ? const Center(
//                           child: CircularProgressIndicator(),
//                         )
//                       : SingleChildScrollView(
//                           child: Column(
//                             children: [
//                               myWidgets.getBottomNavTopWidget(),
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: FractionallySizedBox(
//                                   widthFactor: widget.widthFactor,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text(
//                                         'PREVIEW',
//                                         style: TextStyle(
//                                           color: Colors.pink,
//                                           fontSize: 17,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         'End Date: ${DateFormat.yMMMd().format(offer.selectedEndDate)}',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 color: Colors.pink.shade50,
//                                 padding: const EdgeInsets.only(top: 8, bottom: 8),
//                                 child: Center(
//                                   child: FractionallySizedBox(
//                                     widthFactor: 0.90,
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Expanded(
//                                           child: Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 offer.offerName,
//                                                 textScaleFactor: 1.3,
//                                                 style: TextStyle(
//                                                     color: Colors.blue.shade900),
//                                               ),
//                                               Text(
//                                                 offer.offerDescription,
//                                                 overflow: TextOverflow.fade,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Column(
//                                           mainAxisAlignment: MainAxisAlignment.end,
//                                           crossAxisAlignment: CrossAxisAlignment.end,
//                                           children: [
//                                             Card(
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.spaceAround,
//                                                 children: [
//                                                   const Padding(
//                                                     padding: EdgeInsets.all(8.0),
//                                                     child: Text('PRIME',
//                                                         style: TextStyle(
//                                                             fontWeight: FontWeight.bold)),
//                                                   ),
//                                                   Container(
//                                                     color: Colors.purple,
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.all(8.0),
//                                                       child: Text(
//                                                         'Extra ${int.parse(offer.discountNoPrime) - int.parse(offer.discountNo)}${offer.discountUoM}',
//                                                         style: const TextStyle(
//                                                             color: Colors.white),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.only(top: 3.h),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     const Text('Out of Stock',
//                                         style: TextStyle(fontWeight: FontWeight.bold)),
//                                     Switch(
//                                       activeTrackColor: Colors.blue.shade900,
//                                       value: offer.isInStock,
//                                       onChanged: (isInStock) => controller
//                                           .changeOfferIsInStockStatus(offer, isInStock),
//                                     ),
//                                     const Text('In Stock',
//                                         style: TextStyle(fontWeight: FontWeight.bold)),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.only(top: 3.h),
//                                 width: 90.w,
//                                 height: 8.h,
//                                 child: myWidgets.getLargeButtonWithIcon(
//                                   bgColor: Colors.blue.shade900,
//                                   title: 'Extend Offer',
//                                   txtScale: 1.3,
//                                   icon: Icons.open_in_full,
//                                   onPressed: () => controller.extendOffer(offer),
//                                 ),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.only(top: 3.h),
//                                 width: 90.w,
//                                 height: 8.h,
//                                 child: myWidgets.getLargeButtonWithIcon(
//                                   bgColor: Colors.pink,
//                                   title: 'End Offer',
//                                   txtScale: 1.3,
//                                   icon: Icons.block_flipped,
//                                   onPressed: () => controller.endOffer(offer),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 15,
//                               ),
//                               myWidgets.getLargeButton(
//                                 title:
//                                     'Click to read policy Warranty,refund,delivery,COD,etc',
//                                 bgColor: Colors.blue.shade900,
//                                 onPress: () {
//                                   controller.isPolicyAddView = false;
//                                   controller.update();
//                                   controller.showVendorPoliciesView();
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
