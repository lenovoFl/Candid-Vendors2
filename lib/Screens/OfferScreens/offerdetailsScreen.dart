import 'dart:async';
import 'package:candid_vendors/Services/Collections/Offers/OfferHistory/OfferHistoryColl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';
import '../../Controllers/Offers/EditOfferController.dart';
import '../../main.dart';
import '../OtherScreens/ShowLoadingScreen.dart';

class OfferDetailsScreen extends StatelessWidget {
  final String offerID;

  const OfferDetailsScreen({super.key, required this.offerID});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: OfferDetailsController(offerID: offerID),
      builder: (controller) {
        return StreamBuilder(
          stream: isar.offerHistoryColls
              .filter()
              .offerNameIsNotEmpty()
              .offerIDEqualTo(offerID)
              .build()
              .watch(fireImmediately: true),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something is wrong!');
            } else if (!snapshot.hasData) {
              return const Text('No data!');
            }
            var ele = snapshot.data!.first;

            return Scaffold(
              appBar:  AppBar(
                title: Text(
                  'Offer Details',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.sp),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: controller.isLoading
                    ? const ShowLoadingScreen()
                    : Stack(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 11,
                            child: SizedBox(
                              width: 85.w,
                              child: SingleChildScrollView(
                                child: Center(
                                  child: Column(
                                    // crossAxisAlignment: CrossAxisAlignment
                                    //     .center, // Center all children
                                    children: [
                                      offerImagesList(controller, ele),
                                      Column(
                                        // crossAxisAlignment: CrossAxisAlignment
                                        //     .center, // Center all children
                                        children: [
                                          SizedBox(height: 2.h,),
                                          Container(
                                            padding: EdgeInsets.all(16.sp),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12.sp),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.3),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                // Regular Price Section
                                                _buildSectionTitle('Regular Price', Colors.brown),
                                                SizedBox(height: 1.h),
                                                _buildPriceText('₹ ${ele.unitPrice2}'),

                                                SizedBox(height: 2.h),

                                                // Price Comparison Row
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    _buildPriceColumn(
                                                      price: '₹ ${ele.offerDiscountedPrice}',
                                                      label: '* Regular Customer',
                                                      color: Colors.blue.shade700,
                                                    ),
                                                    _buildPriceColumn(
                                                      price: '₹ ${ele.offerPrimeDiscountedPrice}',
                                                      label: '* Prime Customer',
                                                      color: Colors.green.shade700,
                                                    ),
                                                  ],
                                                ),

                                                Divider(height: 3.h, color: Colors.grey.shade300),

                                                // Offer Details
                                                _buildDetailRow('OFFER ID', ele.offerID,
                                                  trailing: InkWell(
                                                    onTap: () {
                                                      Clipboard.setData(ClipboardData(text: ele.offerID));
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(content: Text('Offer ID copied to clipboard')),
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.copy,
                                                      size: 16.sp,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),

                                                _buildDetailRow('OFFER NAME', ele.offerName),

                                                _buildDetailRow('OFFER DESCRIPTION', ele.offerDescription),
                                              ],
                                            ),
                                          ),
                                          Card(
                                            margin: const EdgeInsets.all(8.0),
                                            elevation: 4,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .center,
                                                // Center all children
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(top: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: [
                                                        _buildIconWithText(
                                                          icon: Icons
                                                              .verified_outlined,
                                                          label: 'Deal',
                                                          value: '${ele
                                                              .discountNoPrime}${ele
                                                              .discountUoM}',
                                                          iconSize: 30.0,
                                                          innerColor: Colors
                                                              .redAccent,
                                                          outerColor: const Color(
                                                              0xFF0D0140),
                                                        ),
                                                        _buildIconWithText(
                                                          icon: Icons
                                                              .watch_later_outlined,
                                                          label: 'Validity',
                                                          value: DateFormat
                                                              .MMMMd().format(
                                                              ele
                                                                  .selectedEndDate),
                                                          iconSize: 30.0,
                                                          innerColor: Colors
                                                              .redAccent,
                                                          outerColor: const Color(
                                                              0xFF0D0140),
                                                        ),
                                                        _buildIconWithText(
                                                          icon: Icons
                                                              .folder_copy_outlined,
                                                          label: 'Max Claims',
                                                          value: ele
                                                              .maxNumClaims
                                                              .toString(),
                                                          iconSize: 30.0,
                                                          innerColor: Colors
                                                              .redAccent,
                                                          outerColor: const Color(
                                                              0xFF0D0140),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // const Row(
                                      //     mainAxisAlignment: MainAxisAlignment
                                      //         .spaceBetween,
                                      //     children: []),
                                      // Card(
                                      //   color: Colors.white,
                                      //   // Set the background color to white
                                      //   child: ExpansionTile(
                                      //     title: const Text('Deal Details',
                                      //         style: TextStyle(
                                      //             fontFamily: 'Aileron')),
                                      //     children: <Widget>[
                                      //       Text(ele.describeDealDetails),
                                      //     ],
                                      //   ),
                                      // ),
                                      Card(
                                        color: Colors.white,
                                        // Set the background color to white
                                        child: ExpansionTile(
                                          title: const Text(
                                              'Delivery Policy',
                                              style: TextStyle(
                                                  fontFamily: 'Aileron')),
                                          children: <Widget>[
                                            Text(ele.delivery),
                                          ],
                                        ),
                                      ),
                                      // Card(
                                      //   color: Colors.white,
                                      //   // Set the background color to white
                                      //   child: ExpansionTile(
                                      //     title: const Text(
                                      //         'Steps to Redeem Offer',
                                      //         style: TextStyle(
                                      //             fontFamily: 'Aileron')),
                                      //     children: <Widget>[
                                      //       Text(ele.stepsToRedeem),
                                      //     ],
                                      //   ),
                                      // ),
                                      Card(
                                        color: Colors.white,
                                        // Set the background color to white
                                        child: ExpansionTile(
                                          title: const Text('Warranty',
                                              style: TextStyle(
                                                  fontFamily: 'Aileron')),
                                          children: <Widget>[
                                            Text(ele.warranty),
                                          ],
                                        ),
                                      ),
                                      Card(
                                        color: Colors.white,
                                        // Set the background color to white
                                        child: ExpansionTile(
                                          title: const Text(
                                              'Refund Policy',
                                              style: TextStyle(
                                                  fontFamily: 'Aileron')),
                                          children: <Widget>[
                                            Text(ele.refund),
                                          ],
                                        ),
                                      ),
                                      Card(
                                        color: Colors.white,
                                        // Set the background color to white
                                        child: ExpansionTile(
                                          title: const Text(
                                              'Other Important Information',
                                              style: TextStyle(
                                                  fontFamily: 'Aileron')),
                                          children: <Widget>[
                                            Text(ele.other),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20.h,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  Future<double> _fetchImageAndCalculateAspectRatio(
      {required String imageUrl}) async {
    final file = await DefaultCacheManager().getSingleFile(imageUrl);

    final image = Image.file(file);
    final imageSize = Completer<Size>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
            (ImageInfo info, bool _) {
          imageSize.complete(Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          ));
        },
      ),
    );
    var img = await imageSize.future;
    return img.width / img.height;
  }

  offerImagesList(OfferDetailsController controller, OfferHistoryColl ele) {
    return Column(
      children: [
        Container(
          height: 50.h,
          margin: const EdgeInsets.only(top: 8, left: 8),
          width: double.infinity,
          child: Center(
            child: PageView.builder(
              itemCount: ele.offerImages.length,
              onPageChanged: (index) {
                controller.currentImageIndex.value = index;
              },
              itemBuilder: (context, index) {
                var imageUrl = ele.offerImages[index];
                return FutureBuilder(
                  future: _fetchImageAndCalculateAspectRatio(
                      imageUrl: imageUrl),
                  builder: (context, snapshot) {
                    return snapshot.data != null
                        ? SizedBox(
                      width: 80.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: snapshot.data!,
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    )
                        : const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            ele.offerImages.length,
                (index) =>
                Obx(
                      () =>
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.currentImageIndex.value == index
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                ),
          ),
        ),
      ],
    );
  }

  Widget buildButton({required String label,
    required VoidCallback onPressed}) {
    return Container(
      width: 23.w,
      height: 4.h,
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontFamily: 'Aileron',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
      ),
    );
  }

  Widget buildItem({
    required String discount,
    required bool isFavorite,
    required String id,
    required String offerImage,
    required BuildContext context,
  }) {
    const EdgeInsets imagePadding = EdgeInsets.all(10.0);
    const EdgeInsets discountPadding = EdgeInsets.only(
        left: 8.0, bottom: 8.0); // Adjusted padding

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OfferDetailsScreen(offerID: id),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        // Use double.infinity for width to match the parent
        height: 150,
        // Adjust height as needed
        decoration: BoxDecoration(
          color: const Color(0xFFB0B0B0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: imagePadding,
                child: myWidgets.getCachedNetworkImage(imgUrl: offerImage),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
              ),
            ),
            Positioned(
              left: 10,
              bottom: 10, // Adjusted position
              child: Padding(
                padding: discountPadding,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  // Adjust padding for better text fit
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0000),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      discount,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12, // Adjust font size as needed
                        fontFamily: 'Aileron',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: 10.sp,
        fontFamily: 'Aileron',
        fontWeight: FontWeight.w700,
        letterSpacing: 0.02,
      ),
    );
  }

  Widget _buildPriceText(String price) {
    return Text(
      price,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: 14.sp,
        fontFamily: 'Aileron',
        fontWeight: FontWeight.bold,
        letterSpacing: 0.02,
      ),
    );
  }

  Widget _buildPriceColumn({
    required String price,
    required String label,
    Color? color,
  }) {
    return Column(
      children: [
        Text(
          price,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Aileron',
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color ?? Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String title, String content, {Widget? trailing}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 1.h),
        _buildSectionTitle(title, Colors.brown),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                content,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontFamily: 'Aileron',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.02,
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
        SizedBox(height: 1.h),
      ],
    );
  }
  Widget _buildIconWithText({
    required IconData icon,
    required String label,
    required String value,
    required double iconSize,
    required Color innerColor,
    required Color outerColor,
  }) {
    return Column(
      children: [
        Stack(
          children: [
            Icon(
              icon,
              size: iconSize,
              color: outerColor, // Outer color of the icon
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: iconSize,
                  color: innerColor, // Inner color of the icon
                ),
              ),
            ),
          ],
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(
              color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

//
// otherOffersContainer(OffersColl ele) {
//   return Center(
//     child: Container(
//       height: 22.h,
//       width: 95.w,
//       margin: const EdgeInsets.only(top: 8),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//           color: Colors.grey.shade300,
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(10)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Container(
//           decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: Colors.pink.shade100),
//               borderRadius: BorderRadius.circular(10)),
//           child: Row(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                     color: Colors.pink,
//                     border: Border.all(color: Colors.pink.shade100),
//                     borderRadius: BorderRadius.circular(10)),
//                 width: 23.w,
//                 child: const Text('OTHER\nOFFERS',
//                     textScaleFactor: 1.3,
//                     style: TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.bold)),
//               ),
//               const Text('@',
//                   textScaleFactor: 1.8,
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(ele.productName,
//                         overflow: TextOverflow.clip,
//                         style: const TextStyle(
//                             color: Colors.pink, fontWeight: FontWeight.bold)),
//                     Text(ele.offerAddress,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                         style: const TextStyle(color: Colors.pink))
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(left: 8, right: 8),
//                 color: Colors.pink.shade100,
//                 child: const Text('10 Live',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               )
//             ],
//           ),
//         ),
//         const Text('Top Rated',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: FittedBox(
//             child: Row(
//               children: [
//                 const Text(
//                   'BUY 1 GET 1 FREE',
//                   textScaleFactor: 1.3,
//                   style: TextStyle(
//                       color: Colors.pink, fontWeight: FontWeight.bold),
//                 ),
//                 const Text('FREE COFFEE',
//                     textScaleFactor: 1.3,
//                     style: TextStyle(
//                         color: Colors.pink, fontWeight: FontWeight.bold)),
//                 const Text('FREE FRIES',
//                     textScaleFactor: 1.3,
//                     style: TextStyle(
//                         color: Colors.pink, fontWeight: FontWeight.bold))
//               ]
//                   .map((e) => Row(
//                         children: [
//                           Container(
//                             height: 7.h,
//                             width: 30.w,
//                             decoration: BoxDecoration(
//                                 color: Colors.pink.shade100,
//                                 border: Border.all(color: Colors.pink),
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: e,
//                           ),
//                           const VerticalDivider(
//                             width: 10,
//                           )
//                         ],
//                       ))
//                   .toList(),
//             ),
//           ),
//         )
//       ]),
//     ),
//   );
// }
// Row(children: [
//   const Expanded(child: Text('')),
//   Expanded(
//       child: Row(
//     children: [
//       IconButton(
//         icon: const Icon(
//             Icons.favorite_border_outlined,
//             color: Colors.black),
//         onPressed: () => OffersConnect()
//             .addOrRemoveOfferFromWishList(
//                 offerID: ele.offerID),
//       ),
//       IconButton(
//         icon: const Icon(Icons.share_outlined,
//             color: Colors.black),
//         onPressed: () {},
//       ),
//     ],
//   ))
// ]),
// Container(
//   margin: const EdgeInsets.all(8),
//   padding: const EdgeInsets.all(8),
//   decoration: BoxDecoration(
//       color: Colors.blue.shade100,
//       border: Border.all(color: Colors.blue),
//       borderRadius: BorderRadius.circular(10)),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Text(ele.offerName,
//           textScaleFactor: 1.3,
//           style: TextStyle(
//               color: Colors.blue.shade900,
//               fontWeight: FontWeight.bold)),
//       Card(
//         child: Row(
//           mainAxisAlignment:
//               MainAxisAlignment.spaceAround,
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text('PRIME',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold)),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   color: Colors.purple,
//                   borderRadius:
//                       BorderRadius.circular(10)),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                     'Extra ${int.parse(ele.discountNoPrime) - int.parse(ele.discountNo)}${ele.discountUoM}',
//                     style: const TextStyle(
//                         color: Colors.white)),
//               ),
//             )
//           ],
//         ),
//       )
//     ],
//   ),
// ),
// Container(
//   margin: const EdgeInsets.all(8),
//   padding: const EdgeInsets.all(8),
//   decoration: BoxDecoration(
//       color: Colors.pink.shade100,
//       border: Border.all(color: Colors.pink),
//       borderRadius: BorderRadius.circular(10)),
//   child: Row(
//     mainAxisAlignment:
//         MainAxisAlignment.spaceBetween,
//     children: [
//       Expanded(
//         child: Text(
//             'Offer valid till : ${DateFormat.yMMMMEEEEd().format(ele.selectedEndDate)}',
//             style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 overflow: TextOverflow.ellipsis)),
//       ),
//       const Icon(Icons.calendar_month_outlined)
//     ],
//   ),
// ),
// InkWell(
//   onTap: () => showGeneralDialog(
//     context: navigatorKey.currentContext!,
//     transitionBuilder: (context, a1, a2, child) {
//       var curve =
//           Curves.easeInOut.transform(a1.value);
//       return Transform.scale(
//         scale: curve,
//         child: SafeArea(
//           child: Dialog(
//               insetPadding: EdgeInsets.zero,
//               child: SizedBox(
//                 height: 70.h,
//                 width: 90.w,
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   fit: StackFit.expand,
//                   children: [
//                     Center(
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment:
//                               CrossAxisAlignment
//                                   .center,
//                           mainAxisAlignment:
//                               MainAxisAlignment
//                                   .center,
//                           children: [
//                             Text(
//                                 "Warranty: ${ele.offerTC.warranty}",
//                                 textScaleFactor:
//                                     1.5,
//                                 maxLines: 2,
//                                 overflow:
//                                     TextOverflow
//                                         .fade,
//                                 style:
//                                     const TextStyle(
//                                         color: Colors
//                                             .pink)),
//                             Text(
//                                 "Delivery: ${ele.offerTC.delivery}",
//                                 textScaleFactor:
//                                     1.5,
//                                 maxLines: 2,
//                                 overflow:
//                                     TextOverflow
//                                         .fade,
//                                 style:
//                                     const TextStyle(
//                                         color: Colors
//                                             .pink)),
//                             Text(
//                                 "COD / Payment: ${ele.offerTC.COD}",
//                                 textScaleFactor:
//                                     1.5,
//                                 maxLines: 2,
//                                 overflow:
//                                     TextOverflow
//                                         .fade,
//                                 style:
//                                     const TextStyle(
//                                         color: Colors
//                                             .pink)),
//                             Text(
//                                 "Refund: ${ele.offerTC.refund}",
//                                 textScaleFactor:
//                                     1.5,
//                                 maxLines: 2,
//                                 overflow:
//                                     TextOverflow
//                                         .fade,
//                                 style:
//                                     const TextStyle(
//                                         color: Colors
//                                             .pink)),
//                             Text(
//                                 "Other: ${ele.offerTC.other}",
//                                 textScaleFactor:
//                                     1.5,
//                                 maxLines: 3,
//                                 overflow:
//                                     TextOverflow
//                                         .fade,
//                                 style:
//                                     const TextStyle(
//                                         color: Colors
//                                             .pink))
//                           ],
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       right: 0.0,
//                       child: InkResponse(
//                         onTap: () {
//                           Navigator.of(context)
//                               .pop();
//                         },
//                         child: const SizedBox(
//                           height: 50,
//                           width: 50,
//                           child: CircleAvatar(
//                             backgroundColor:
//                                 Colors.transparent,
//                             child: Icon(
//                               Icons.close,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//         ),
//       );
//     },
//     transitionDuration:
//         const Duration(milliseconds: 300),
//     pageBuilder:
//         (context, animation, secondaryAnimation) {
//       return Container();
//     },
//   ),
//   child: Container(
//     margin: const EdgeInsets.only(top: 8),
//     padding: const EdgeInsets.all(8),
//     decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         border: Border.all(color: Colors.grey)),
//     child: const Row(
//       mainAxisAlignment:
//           MainAxisAlignment.spaceBetween,
//       children: [
//         Text('Offer Terms and condition',
//             style: TextStyle(
//                 fontWeight: FontWeight.bold)),
//         Icon(Icons.chevron_right_outlined)
//       ],
//     ),
//   ),
// ),
// Row(children: [
//   const Expanded(child: Text('')),
//   Expanded(
//       child: Row(
//     children: [
//       IconButton(
//         icon: const Icon(
//             Icons.favorite_border_outlined,
//             color: Colors.black),
//         onPressed: () => OffersConnect()
//             .addOrRemoveOfferFromWishList(
//                 offerID: ele.offerID),
//       ),
//       IconButton(
//         icon: const Icon(Icons.share_outlined,
//             color: Colors.black),
//         onPressed: () {},
//       ),
//     ],
//   ))
// ]),
// Container(
//   margin: const EdgeInsets.all(8),
//   padding: const EdgeInsets.all(8),
//   // decoration: BoxDecoration(
//   //     color: Colors.blue.shade100,
//   //     border: Border.all(color: Colors.blue),
//   //     borderRadius: BorderRadius.circular(10)),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Card(
//         child: Row(
//           mainAxisAlignment:
//               MainAxisAlignment.spaceAround,
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text('PRIME',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold)),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   color: Colors.purple,
//                   borderRadius:
//                       BorderRadius.circular(10)),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                     'Extra ${int.parse(ele.discountNoPrime) - int.parse(ele.discountNo)}${ele.discountUoM}',
//                     style: const TextStyle(
//                         color: Colors.white)),
//               ),
//             )
//           ],
//         ),
//       )
//     ],
//   ),
// ),
// Expanded(
//   child: InkWell(
//     onTap: () {
//       Navigator.of(context)
//           .push(MaterialPageRoute(
//         builder: (context) =>
//             StoreListingScreen(),
//       ));
//     },
//     child: const Row(
//       children: [
//         Icon(Icons
//             .storefront_outlined),
//         Text('  Store Name'),
//       ],
//     ),
//   ),
// ),
// Expanded(
//     child: OpenContainer(
//       closedColor: Colors.white,
//       transitionDuration:
//       const Duration(seconds: 1),
//       transitionType:
//       ContainerTransitionType
//           .fadeThrough,
//       closedBuilder: (context, action) =>
//       const Row(
//         mainAxisAlignment:
//         MainAxisAlignment.end,
//         children: [
//           Text('View more'),
//           Icon(Icons
//               .arrow_forward_ios_outlined),
//         ],
//       ),
//       openBuilder: (context, action) =>
//           StoreListingScreen(),
//     ))