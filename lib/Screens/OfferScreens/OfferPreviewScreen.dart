import 'dart:io';
import 'package:animations/animations.dart';
import 'package:candid_vendors/Controllers/Offers/OfferPreviewController.dart';
import 'package:candid_vendors/Screens/OfferScreens/StoreInformation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sizer/sizer.dart';
import '../../BottomNavScreen.dart';
import '../../Utils/MyWidgets.dart';
import '../../main.dart';

class OfferPreviewScreen extends StatefulWidget {
  final List<XFile> images;
  final String offerDiscountedPrice;
  final String offerPrimeDiscountedPrice;
  final String discountDropDownValue,
      offerName,
      offerDescription,
      dropDownValue,
      offerDiscount,
      unitPrice2,
      regularDiscountNumber,
      primeDiscountNumber,
      primeUnitPrice,
      primeDiscountedPrice,
      regularUnitPrice,
      offerPrimeDiscount,
      productName,
      selectedCategory,
      selectedOfferType,
      productDescription,
      warranty,
      refund,
      delivery,
      COD,
      other,
      maxNumClaims,
      selectedCity,
      selectedState,
      offerDiscountType,
      selectedCatID;

  final DateTime selectedStartDate, selectedEndDate;

  const OfferPreviewScreen({
    super.key,
    required this.images,
    required this.discountDropDownValue,
    required this.offerName,
    required this.productName,
    required this.offerDescription,
    required this.dropDownValue,
    required this.offerDiscount,
    required this.offerDiscountedPrice,
    required this.offerPrimeDiscountedPrice,
    required this.offerPrimeDiscount,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.selectedCategory,
    required this.selectedOfferType,
    required this.productDescription,
    required this.selectedCity,
    required this.selectedState,
    required this.offerDiscountType,
    required this.unitPrice2,
    required this.regularDiscountNumber,
    required this.primeDiscountNumber,
    required this.primeUnitPrice,
    required this.primeDiscountedPrice,
    required this.regularUnitPrice,
    required this.maxNumClaims,
    required this.warranty,
    required this.refund,
    required this.delivery,
    required this.COD,
    required this.other,
    required this.selectedCatID,
  });

  @override
  State<OfferPreviewScreen> createState() => _OfferPreviewScreenState();
}

class _OfferPreviewScreenState extends State<OfferPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: OfferPreviewController(
          images: widget.images,
          discountDropDownValue: widget.discountDropDownValue,
          dropDownValue: widget.dropDownValue,
          warranty: widget.warranty,
          refund: widget.refund,
          delivery: widget.delivery,
          other: widget.other ?? "",
          COD: widget.COD,
          maxNumClaims: widget.maxNumClaims,
          // stepsToRedeem: widget.stepsToRedeem,
          // describeDealDetails: widget.describeDealDetails,
          offerDescription: widget.offerDescription,
          offerDiscount: widget.offerDiscount,
          offerName: widget.offerName,
          unitPrice2: widget.unitPrice2,
          productName: widget.productName,
          offerPrimeDiscount: widget.offerPrimeDiscount,
          selectedStartDate: widget.selectedStartDate,
          selectedEndDate: widget.selectedEndDate,
          selectedCategory: widget.selectedCategory,
          selectedOfferType: widget.selectedOfferType,
          productDescription: widget.productDescription,
          selectedCity: widget.selectedCity,
          selectedState: widget.selectedState,
          offerDiscountType: widget.offerDiscountType,
          offerDiscountedPrice: widget.offerDiscountedPrice,
          regularDiscountNumber: widget.regularDiscountNumber,
          primeDiscountNumber: widget.primeDiscountNumber,
          primeUnitPrice: widget.primeUnitPrice,
          primeDiscountedPrice: widget.primeDiscountedPrice,
          regularUnitPrice: widget.regularUnitPrice,
          offerPrimeDiscountedPrice: widget.offerPrimeDiscountedPrice,
          selectedCatID: widget.selectedCatID),
      builder: (controller) {
        return WillPopScope(
            onWillPop: () async {
              if (controller.isOfferCreated) {
                await Navigator.of(navigatorKey.currentContext!)
                    .pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const BottomNavScreen()),
                  (route) => false,
                );
              } else {
                Navigator.of(navigatorKey.currentContext!).pop();
              }
              return false;
            },
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: MyWidgets().offerDetailsAppBar(controller: controller),
                body: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    child: controller.isLoading
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  controller.message,
                                  textScaleFactor: 1.3,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          )
                        : !controller.isOfferCreated
                            ? Column(
                                children: [
                                  Expanded(
                                    flex: 11,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          offerImagesList(widget.images),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  height: 10.h,
                                                  width: 45.w,
                                                  child: Stack(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    children: [
                                                      Image.asset(
                                                        'lib/Images/Coupen.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '${controller.offerDiscount}% OFF',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              ' For Prime Extra ${int.parse(controller.offerPrimeDiscount) - int.parse(controller.offerDiscount)}${controller.discountDropDownValue}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: IconButton(
                                                  icon: const Icon(
                                                      Icons.share_outlined,
                                                      color: Colors.black),
                                                  onPressed: () => controller
                                                      .shareOfferOnSocialMedia(
                                                          offer: controller),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SingleChildScrollView(
                                            child: SizedBox(
                                              width: 87.w,
                                              child: Card(
                                                color: Colors.white,
                                                elevation: 1,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '₹ ${controller.unitPrice2}',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14.sp,
                                                          fontFamily: 'Aileron',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          decoration: TextDecoration
                                                              .lineThrough, // Add strike-through decoration
                                                          height: 1,
                                                          letterSpacing: 0.02,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1.h,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '₹ ${controller.offerDiscountedPrice}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontFamily:
                                                                        'Aileron',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    height: 0,
                                                                    letterSpacing:
                                                                        0.02,
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  '  *Regular',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '₹ ${controller.offerPrimeDiscountedPrice}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontFamily:
                                                                        'Aileron',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    height: 0,
                                                                    letterSpacing:
                                                                        0.02,
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  '  *Prime',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const Divider(),
                                                      Text(
                                                        controller.offerName,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.sp,
                                                          fontFamily: 'Aileron',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 0,
                                                          letterSpacing: 0.02,
                                                        ),
                                                      ),
                                                      const Divider(),
                                                      Text(
                                                        controller.productName,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.sp,
                                                          fontFamily: 'Aileron',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 0,
                                                          letterSpacing: 0.02,
                                                        ),
                                                      ),
                                                      const Divider(),
                                                      Text(
                                                        controller
                                                            .offerDescription,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.sp,
                                                          fontFamily: 'Aileron',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 0,
                                                          letterSpacing: 0.02,
                                                        ),
                                                      ),
                                                      const Divider(),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              const Icon(Icons
                                                                  .verified_outlined),
                                                              const Text(
                                                                'Deal',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                '${controller.offerDiscount}%',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              const Icon(Icons
                                                                  .folder_copy_outlined),
                                                              const Text(
                                                                'Max Claims',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                controller
                                                                    .maxNumClaims,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              const Icon(Icons
                                                                  .watch_later_outlined),
                                                              const Text(
                                                                'Validity',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                DateFormat
                                                                        .MMMMd()
                                                                    .format(controller
                                                                        .selectedEndDate),
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      const Divider(),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          buildButton(
                                                            label: controller
                                                                .selectedCategory,
                                                            onPressed: () {},
                                                          ),
                                                          buildButton(
                                                            label: controller
                                                                .selectedOfferType,
                                                            onPressed: () {},
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          buildButton(
                                                            label: controller
                                                                .selectedCity,
                                                            onPressed: () {},
                                                          ),
                                                          buildButton(
                                                            label: controller
                                                                .selectedState,
                                                            onPressed: () {},
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Container(
                                            color: Colors.white,
                                            height: 30.h,
                                            width: 85.w,
                                            child: Card(
                                              color: Colors.white,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Expanded(
                                                          child: InkWell(
                                                            child: Row(
                                                              children: [
                                                                const Icon(Icons
                                                                    .storefront_outlined),
                                                                Text(
                                                                  controller
                                                                      .user
                                                                      .userBusinessName,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18,
                                                                    fontFamily:
                                                                        'Aileron',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    letterSpacing:
                                                                        0.03,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        OpenContainer(
                                                          //  closedColor: Colors.white,
                                                          transitionDuration:
                                                              const Duration(
                                                                  seconds: 1),
                                                          transitionType:
                                                              ContainerTransitionType
                                                                  .fadeThrough,
                                                          closedBuilder:
                                                              (context,
                                                                      action) =>
                                                                  const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text('View more'),
                                                              Icon(Icons
                                                                  .arrow_forward_ios_outlined),
                                                            ],
                                                          ),
                                                          openBuilder: (context,
                                                                  action) =>
                                                              const StoreInformation(),
                                                        ),
                                                      ],
                                                    ),
                                                    Card(
                                                      child: ExpansionTile(
                                                        title: const Text(
                                                            'Terms & Conditions'),
                                                        children: <Widget>[
                                                          SingleChildScrollView(
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  'warranty: ${controller.warranty}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontFamily:
                                                                        'Aileron',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height: 0,
                                                                    letterSpacing:
                                                                        0.02,
                                                                  ),
                                                                  //   overflow: TextOverflow.ellipsis,
                                                                ),
                                                                const Divider(),
                                                                Text(
                                                                  'other: ${controller.other}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontFamily:
                                                                        'Aileron',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height: 0,
                                                                    letterSpacing:
                                                                        0.02,
                                                                  ),
                                                                  //     overflow: TextOverflow.ellipsis,
                                                                ),
                                                                const Divider(),
                                                                Text(
                                                                  'delivery: ${controller.delivery}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontFamily:
                                                                        'Aileron',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height: 0,
                                                                    letterSpacing:
                                                                        0.02,
                                                                  ),
                                                                  //       overflow: TextOverflow.ellipsis,
                                                                ),
                                                                const Divider(),
                                                                Text(
                                                                  'refund: ${controller.refund}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontFamily:
                                                                        'Aileron',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height: 0,
                                                                    letterSpacing:
                                                                        0.02,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 80.w,
                                            height: 6.h,
                                            margin: const EdgeInsets.only(
                                                top: 16.0),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                Get.snackbar(
                                                  'Please wait...',
                                                  'Creating your offer...',
                                                  backgroundColor: Colors.blueAccent,
                                                  colorText: Colors.white,
                                                  snackPosition: SnackPosition.BOTTOM,
                                                );

                                                try {
                                                  await controller.createOffer();

                                                  Get.snackbar(
                                                    'Success',
                                                    'Offer created successfully!',
                                                    backgroundColor: Colors.green,
                                                    colorText: Colors.white,
                                                    snackPosition: SnackPosition.BOTTOM,
                                                    duration: const Duration(seconds: 2),
                                                  );

                                                  await Future.delayed(const Duration(seconds: 1));

                                                  // ✅ Purane GetX controllers clear kar do
                                                  Get.deleteAll(force: true);

                                                  // ✅ Ab fresh start karo BottomNavScreen se
                                                  Get.offAll(
                                                        () => BottomNavScreen(),
                                                    transition: Transition.fadeIn,
                                                    duration: const Duration(milliseconds: 600),
                                                  );
                                                } catch (e) {
                                                  Get.snackbar(
                                                    'Error',
                                                    'Failed to create offer: $e',
                                                    backgroundColor: Colors.redAccent,
                                                    colorText: Colors.white,
                                                    snackPosition: SnackPosition.BOTTOM,
                                                  );
                                                }
                                              }
,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0),
                                                ),
                                              ),
                                              child: const Text(
                                                'UPLOAD NOW',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Column(
                                            children: [],
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : FractionallySizedBox(
                                widthFactor:
                                    0.90, // This controls the width of the container relative to its parent
                                alignment: Alignment
                                    .center, // Ensures the container is centered
                                child: Container(
                                  width: 80.w,
                                  height: 80.h,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFF8F8F8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Center(
                                    child: Stack(
                                      alignment: Alignment
                                          .center, // Ensures the content inside Stack is centered
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center, // Align text to the center
                                          children: [
                                            // Image just above the text
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16.0),
                                              child: Center(
                                                child: FractionallySizedBox(
                                                  widthFactor:
                                                      0.3, // Adjust width of the image
                                                  child: AspectRatio(
                                                    aspectRatio:
                                                        1, // Maintain aspect ratio
                                                    child: SvgPicture.asset(
                                                      'lib/Images/Vector (1).svg', // Path to your SVG asset
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(17),
                                              child: Text(
                                                'Your Offer has been submitted for review. Check notifications follow updates for reviews.',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontFamily: 'Aileron',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign
                                                    .center, // Center the text
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                height: 5.h,
                                                margin:
                                                    EdgeInsets.only(top: 5.h),
                                                child: MyWidgets()
                                                    .getLargeButtonWithIcon(
                                                  bgColor: Colors.black,
                                                  title: 'SHARE OFFER',
                                                  icon: Icons.share_outlined,
                                                  onPressed: () {
                                                    controller
                                                        .shareOfferOnSocialMedia(
                                                            offer: controller);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                  ),
                )));
      },
    );
  }

  Widget offerImagesList(List<XFile> images) {
    final PageController _pageController = PageController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50.h,
          width: 70.w,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(images[index].path),
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h), // Space between images and dots
        SmoothPageIndicator(
          controller: _pageController,
          count: images.length,
          effect: const ExpandingDotsEffect(
            dotHeight: 8.0,
            dotWidth: 8.0,
            activeDotColor: Colors.blue, // Active dot color
            dotColor: Colors.grey, // Inactive dot color
          ),
        ),
      ],
    );
  }

  Widget buildButton({required String label, required VoidCallback onPressed}) {
    return Container(
      width: 23.w,
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5), // Added padding for better spacing
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero), // Remove default padding from the button
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontFamily: 'Aileron',
            fontWeight: FontWeight.w400,
            height: 1.5, // Increased height to space lines
          ),
          maxLines: 2, // Allow up to two lines of text
          overflow:
              TextOverflow.ellipsis, // Ensures long text is truncated if needed
          textAlign: TextAlign.center, // Center the text within the button
        ),
      ),
    );
  }
}
