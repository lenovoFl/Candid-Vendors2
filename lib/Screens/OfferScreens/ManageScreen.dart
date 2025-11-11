import 'package:animations/animations.dart';
import 'package:candid_vendors/Controllers/HomeScreenController.dart';
import 'package:candid_vendors/Screens/OfferScreens/EditOfferScreen.dart';
import 'package:candid_vendors/Services/Collections/Offers/OfferHistory/OfferHistoryColl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';

import '../../main.dart';

class ManageScreen extends StatelessWidget {
  final HomeScreenController homeController;
  final double widthFactor;

  const ManageScreen(
      {super.key, required this.homeController, required this.widthFactor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      child: SingleChildScrollView(
        child: Column(
          children: [
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => homeController.updateActiveOfferIndex(0),
                        child: SizedBox(
                          height: 10.h,
                          width: 30.w,
                          child: Card(
                            surfaceTintColor:
                                homeController.activeOfferIndex == 0
                                    ? Colors.blue.shade900
                                    : Colors.white,
                            color: homeController.activeOfferIndex == 0
                                ? Colors.blue.shade900
                                : Colors.white,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.live_tv,
                                    color: homeController.activeOfferIndex == 0
                                        ? Colors.white
                                        : Colors.blue.shade900,
                                  ),
                                  Text(
                                    'Live now',
                                    style: TextStyle(
                                        color:
                                            homeController.activeOfferIndex == 0
                                                ? Colors.white
                                                : Colors.black),
                                  )
                                ]),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => homeController.updateActiveOfferIndex(1),
                        child: SizedBox(
                          height: 10.h,
                          width: 30.w,
                          child: Card(
                            surfaceTintColor:
                                homeController.activeOfferIndex == 1
                                    ? Colors.blue.shade900
                                    : Colors.white,
                            color: homeController.activeOfferIndex == 1
                                ? Colors.blue.shade900
                                : Colors.white,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.gif_box_outlined,
                                    color: homeController.activeOfferIndex == 1
                                        ? Colors.white
                                        : Colors.blue.shade900,
                                  ),
                                  Text(
                                    'Out of Stock',
                                    style: TextStyle(
                                        color:
                                            homeController.activeOfferIndex == 1
                                                ? Colors.white
                                                : Colors.black),
                                  )
                                ]),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => homeController.updateActiveOfferIndex(2),
                        child: SizedBox(
                          height: 10.h,
                          width: 30.w,
                          child: Card(
                            surfaceTintColor:
                                homeController.activeOfferIndex == 2
                                    ? Colors.blue.shade900
                                    : Colors.white,
                            color: homeController.activeOfferIndex == 2
                                ? Colors.blue.shade900
                                : Colors.white,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.circle_outlined,
                                    color: homeController.activeOfferIndex == 2
                                        ? Colors.white
                                        : Colors.blue.shade900,
                                  ),
                                  Text(
                                    'Expired',
                                    style: TextStyle(
                                        color:
                                            homeController.activeOfferIndex == 2
                                                ? Colors.white
                                                : Colors.black),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        homeController
                            .offersType[homeController.activeOfferIndex],
                        style: TextStyle(
                            color: Colors.blue.shade900, fontSize: 17),
                      ),
                      const Text(
                        'Click offers to Edit',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
            StreamBuilder(
              stream: homeController.selectedOfferStatus !=
                      OfferStatus.outOfStock
                  ? isar.offerHistoryColls
                      .filter()
                      .offerStatusEqualTo(homeController.selectedOfferStatus)
                      .build()
                      .watch(fireImmediately: true)
                  : isar.offerHistoryColls
                      .filter()
                      .isInStockEqualTo(false)
                      .build()
                      .watch(fireImmediately: true),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                List<OfferHistoryColl>? offersList = snapshot.data;
                return AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: offersList!.isEmpty
                      ? Center(
                          child: Text('No offers found!',
                              textScaleFactor: 1.5,
                              style: TextStyle(color: Colors.blue.shade900)),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: offersList.length,
                          itemBuilder: (context, index) {
                            OfferHistoryColl offer = offersList[index];
                            debugPrint('offer.offerStatus | ${offer.offerStatus}');
                            // return OpenContainer(
                            //   closedColor: Colors.white,
                            //   middleColor: Colors.white,
                            //   openColor: Colors.white,
                            //   closedElevation: 10,
                            //   openElevation: 10,
                            //   tappable: homeController.selectedOfferStatus !=
                            //       OfferStatus.expired,
                            //   transitionType:
                            //       ContainerTransitionType.fadeThrough,
                            //   transitionDuration: const Duration(seconds: 1),
                            //   closedBuilder: (context, action) => Column(
                            //     children: [
                            //       FractionallySizedBox(
                            //         widthFactor: widthFactor,
                            //         child: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             const Text(
                            //               'PREVIEW',
                            //               style: TextStyle(
                            //                   color: Colors.pink, fontSize: 17),
                            //             ),
                            //             Text(
                            //               'End Date: ${DateFormat.yMMMd().format(offer.selectedEndDate)}',
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //       Container(
                            //         color: Colors.pink.shade50,
                            //         padding: const EdgeInsets.only(
                            //             top: 8, bottom: 8),
                            //         child: Center(
                            //           child: FractionallySizedBox(
                            //             widthFactor: 0.90,
                            //             child: Row(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.spaceBetween,
                            //               children: [
                            //                 SizedBox(
                            //                   width: 40.w,
                            //                   child: Column(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.start,
                            //                     crossAxisAlignment:
                            //                         CrossAxisAlignment.start,
                            //                     children: [
                            //                       Text(
                            //                         offer.offerName,
                            //                         textScaleFactor: 1.3,
                            //                         style: TextStyle(
                            //                             color: Colors
                            //                                 .blue.shade900),
                            //                       ),
                            //                       Text(
                            //                         offer.offerDescription,
                            //                         maxLines: 1,
                            //                         overflow:
                            //                             TextOverflow.ellipsis,
                            //                       )
                            //                     ],
                            //                   ),
                            //                 ),
                            //                 SizedBox(
                            //                   child: Column(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.end,
                            //                     crossAxisAlignment:
                            //                         CrossAxisAlignment.end,
                            //                     children: [
                            //                       Card(
                            //                         child: Row(
                            //                           mainAxisAlignment:
                            //                               MainAxisAlignment
                            //                                   .spaceAround,
                            //                           children: [
                            //                             const Padding(
                            //                               padding:
                            //                                   EdgeInsets.all(
                            //                                       8.0),
                            //                               child: Text('PRIME',
                            //                                   style: TextStyle(
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .bold)),
                            //                             ),
                            //                             Container(
                            //                               color: Colors.purple,
                            //                               child: Padding(
                            //                                 padding:
                            //                                     const EdgeInsets
                            //                                         .all(8.0),
                            //                                 child: Text(
                            //                                     'Extra ${int.parse(offer.discountNoPrime) - int.parse(offer.discountNo)}${offer.discountUoM}',
                            //                                     style: const TextStyle(
                            //                                         color: Colors
                            //                                             .white)),
                            //                               ),
                            //                             )
                            //                           ],
                            //                         ),
                            //                       )
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       FractionallySizedBox(
                            //           widthFactor: widthFactor,
                            //           child: const Divider()),
                            //     ],
                            //   ),
                            // );
                          },
                        ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
