
import 'package:cached_network_image/cached_network_image.dart';
import 'package:candid_vendors/Controllers/Offers/OfferPreviewController.dart';
import 'package:candid_vendors/Screens/AcoountScreen.dart';
import 'package:candid_vendors/Screens/AuthScreens/LogoutScreen.dart';
import 'package:candid_vendors/Screens/Help&TutorialsScreens/Help&TutorialsScreen.dart';
import 'package:candid_vendors/Screens/NotificationScreen/NotificationScreen.dart';
import 'package:candid_vendors/Screens/OfferScreens/AboutusScreen.dart';
import 'package:candid_vendors/Screens/OfferScreens/ActiveOfferScreen.dart';
import 'package:candid_vendors/Screens/OfferScreens/ShareandreferScreen.dart';
import 'package:candid_vendors/Screens/OtherScreens/TermsAndCondition.dart';
import 'package:candid_vendors/Screens/Profile/ProfileScreen.dart';
import 'package:candid_vendors/Screens/Profile/SettingsScreen.dart';
import 'package:candid_vendors/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';

import '../BottomNavScreen.dart';
import '../Controllers/BottomNavController.dart';
import '../Controllers/Notification/NotificationController.dart';
import '../Screens/Help&TutorialsScreens/HelpandSupport.dart';
import '../Screens/Scanqr.dart';
import '../Services/Collections/Offers/OfferHistory/OfferHistoryColl.dart';

class MyWidgets {
  final List<Map<String, dynamic>> navDrawerItems = [
    {'title': 'My Profile', 'screen':   const ProfileScreen()},
    {'title': 'Account Overview', 'screen':   const AccountScreen()},
    {'title': 'My Deals', 'screen': const  ActiveOfferScreen()},
    {'title': 'Share and Refer', 'screen': const ShareRefer()},
    {'title': 'Notifications', 'screen': const NotificationScreen()},
    {'title': 'Redeemed Offers', 'screen': const RedeemedOffersScreen()},
    {'title': 'About', 'screen': const AboutScreen()},
    {'title': 'User Setting', 'screen':  Settings1()},
    {'title': 'Help & Support', 'screen':  const HelpAndSupportScreen()},
    {'title': 'Terms & Condition', 'screen': const TermsAndConditionsScreen()},
    {'title': 'Log out', 'screen': const LogoutScreen()},
  ];

  AppBar myAppbar({
    required String title,
    bool showBack = false,
    required BuildContext context,
    required BottomNavController bottomNavController,
    bool showOfferPopup = true, // New parameter to enable/disable popup
  }) {
    // Set to keep track of offer IDs for which the pop-up has been shown
    // final Set<String> shownOfferIds = {};
    //
    // void showNewOfferPopup(BuildContext context, Map<String, dynamic> offer) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       behavior: SnackBarBehavior.floating,
    //       margin: const EdgeInsets.all(16),
    //       backgroundColor: Colors.green.shade800,
    //       duration: const Duration(seconds: 4),
    //       content: Row(
    //         children: [
    //           const Icon(
    //             Icons.local_offer_rounded,
    //             color: Colors.white,
    //             size: 24,
    //           ),
    //           const SizedBox(width: 12),
    //           Expanded(
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 const Text(
    //                   'New Offer Redeemed!',
    //                   style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     fontFamily: 'Aileron',
    //                   ),
    //                 ),
    //                 const SizedBox(height: 4),
    //                 Text(
    //                   'Offer: ${offer['offerName']}',
    //                   style: const TextStyle(
    //                     fontSize: 12,
    //                     fontFamily: 'Aileron',
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
    //
    // final ValueNotifier<bool> _showOfferPopup = ValueNotifier(showOfferPopup);

    return AppBar(
      title: FittedBox(
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Aileron',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      actions: [
        // ValueListenableBuilder(
        //   valueListenable: _showOfferPopup,
        //   builder: (context, value, child) {
        //     if (value) {
        //       return StreamBuilder<List<OfferHistoryColl>>(
        //         stream: isar.offerHistoryColls
        //             .where()
        //             .offerIDIsNotEmpty()
        //             .build()
        //             .watch(fireImmediately: true),
        //         builder: (context, offerHistorySnapshot) {
        //           if (!offerHistorySnapshot.hasData || offerHistorySnapshot.data!.isEmpty) {
        //             return const SizedBox.shrink();
        //           }
        //
        //           List<String> myOfferIds = offerHistorySnapshot.data!.map((e) => e.offerID).toList();
        //
        //           return StreamBuilder<QuerySnapshot>(
        //             stream: FirebaseFirestore.instance
        //                 .collection('availedOffers')
        //                 .where('offerID', whereIn: myOfferIds)
        //                 .snapshots(),
        //             builder: (context, availedOffersSnapshot) {
        //               if (!availedOffersSnapshot.hasData || availedOffersSnapshot.data!.docs.isEmpty) {
        //                 return const SizedBox.shrink();
        //               }
        //
        //               final redeemedOffers = availedOffersSnapshot.data!.docs;
        //
        //               // Check and show the pop-up only for new, unshown offers
        //               WidgetsBinding.instance.addPostFrameCallback((_) {
        //                 for (var offer in redeemedOffers) {
        //                   try {
        //                     Map<String, dynamic> offerData = offer.data() as Map<String, dynamic>;
        //                     bool isOfferRedeemed = offerData['isOfferRedeemed'] ?? false;
        //                     String offerID = offerData['offerID'] ?? '';
        //
        //                     // Show the pop-up only if the offer is redeemed and hasn't been shown before
        //                     if (isOfferRedeemed && !shownOfferIds.contains(offerID)) {
        //                       showNewOfferPopup(context, offerData);
        //                       shownOfferIds.add(offerID); // Mark as shown
        //                     }
        //                   } catch (e) {
        //                     print('Error processing offer: $e');
        //                   }
        //                 }
        //               });
        //
        //               return Stack(
        //                 alignment: Alignment.center,
        //                 children: [
        //                   IconButton(
        //                     icon: const Icon(
        //                       Icons.flag_rounded,
        //                       color: Colors.green,
        //                       size: 28,
        //                     ),
        //                     onPressed: () {
        //                       showModalBottomSheet(
        //                         context: context,
        //                         isScrollControlled: true,
        //                         backgroundColor: Colors.transparent,
        //                         builder: (context) => DraggableScrollableSheet(
        //                           initialChildSize: 0.7,
        //                           minChildSize: 0.5,
        //                           maxChildSize: 0.95,
        //                           builder: (_, controller) => Container(
        //                             decoration: const BoxDecoration(
        //                               color: Colors.white,
        //                               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        //                             ),
        //                             child: Column(
        //                               children: [
        //                                 Container(
        //                                   margin: const EdgeInsets.symmetric(vertical: 8),
        //                                   width: 40,
        //                                   height: 4,
        //                                   decoration: BoxDecoration(
        //                                     color: Colors.grey[300],
        //                                     borderRadius: BorderRadius.circular(2),
        //                                   ),
        //                                 ),
        //                                 Padding(
        //                                   padding: const EdgeInsets.all(16),
        //                                   child: Text(
        //                                     'Redeemed Offers (${redeemedOffers.length})',
        //                                     style: const TextStyle(
        //                                       fontSize: 20,
        //                                       fontWeight: FontWeight.bold,
        //                                       fontFamily: 'Aileron',
        //                                     ),
        //                                   ),
        //                                 ),
        //                                 Expanded(
        //                                   child: ListView.builder(
        //                                     controller: controller,
        //                                     itemCount: redeemedOffers.length,
        //                                     itemBuilder: (context, index) {
        //                                       final offer = redeemedOffers[index];
        //                                       return Card(
        //                                         margin: const EdgeInsets.symmetric(
        //                                           horizontal: 16,
        //                                           vertical: 8,
        //                                         ),
        //                                         elevation: 2,
        //                                         child: Padding(
        //                                           padding: const EdgeInsets.all(16),
        //                                           child: Column(
        //                                             crossAxisAlignment: CrossAxisAlignment.start,
        //                                             children: [
        //                                               Row(
        //                                                 children: [
        //                                                   Container(
        //                                                     width: 50,
        //                                                     height: 50,
        //                                                     decoration: BoxDecoration(
        //                                                       color: Colors.green.shade50,
        //                                                       borderRadius: BorderRadius.circular(8),
        //                                                     ),
        //                                                     child: const Icon(
        //                                                       Icons.local_offer_rounded,
        //                                                       color: Colors.green,
        //                                                       size: 24,
        //                                                     ),
        //                                                   ),
        //                                                   const SizedBox(width: 12),
        //                                                   Expanded(
        //                                                     child: Column(
        //                                                       crossAxisAlignment: CrossAxisAlignment.start,
        //                                                       children: [
        //                                                         Text(
        //                                                           offer['productName'] ?? 'Product',
        //                                                           style: const TextStyle(
        //                                                             fontSize: 16,
        //                                                             fontWeight: FontWeight.bold,
        //                                                             fontFamily: 'Aileron',
        //                                                           ),
        //                                                         ),
        //                                                         const SizedBox(height: 4),
        //                                                         Text(
        //                                                           'Offer: ${offer['offerName']}',
        //                                                           style: const TextStyle(
        //                                                             color: Colors.green,
        //                                                             fontWeight: FontWeight.w500,
        //                                                             fontFamily: 'Aileron',
        //                                                           ),
        //                                                         ),
        //                                                       ],
        //                                                     ),
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                               const Divider(height: 24),
        //                                               _buildDetailRow(
        //                                                 'Order ID',
        //                                                 offer['orderID'] ?? 'N/A',
        //                                                 Icons.receipt_long_rounded,
        //                                               ),
        //                                               _buildDetailRow(
        //                                                 'Phone',
        //                                                 offer['userPhone'] ?? 'N/A',
        //                                                 Icons.phone_rounded,
        //                                               ),
        //                                               _buildDetailRow(
        //                                                 'Store',
        //                                                 offer['StoreAddress'] ?? 'N/A',
        //                                                 Icons.store_rounded,
        //                                               ),
        //                                               const SizedBox(height: 12),
        //                                               Row(
        //                                                 children: [
        //                                                   _buildStatusChip(
        //                                                     'Prime Member',
        //                                                     offer['isUserPrimeMember'] ?? false,
        //                                                     Colors.blue,
        //                                                   ),
        //                                                   const SizedBox(width: 8),
        //                                                   _buildStatusChip(
        //                                                     'Redeemed',
        //                                                     offer['isOfferRedeemed'] ?? false,
        //                                                     Colors.green,
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                             ],
        //                                           ),
        //                                         ),
        //                                       );
        //                                     },
        //                                   ),
        //                                 ),
        //                               ],
        //                             ),
        //                           ),
        //                         ),
        //                       );
        //                     },
        //                   ),
        //                   Positioned(
        //                     top: 8,
        //                     right: 8,
        //                     child: Container(
        //                       padding: const EdgeInsets.all(4),
        //                       decoration: const BoxDecoration(
        //                         color: Colors.red,
        //                         shape: BoxShape.circle,
        //                       ),
        //                       child: Text(
        //                         redeemedOffers.length.toString(),
        //                         style: const TextStyle(
        //                           color: Colors.white,
        //                           fontSize: 10,
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               );
        //             },
        //           );
        //         },
        //       );
        //     } else {
        //       return IconButton(
        //         icon: const Icon(
        //           Icons.flag_outlined,
        //           color: Colors.grey,
        //           size: 28,
        //         ),
        //         onPressed: () {
        //           _showOfferPopup.value = true;
        //         },
        //       );
        //     }
        //   },
        // ),


        // QR Code Scanner Icon
        IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          iconSize: 35,
          color: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen1(),
              ),
            );
          },
        ),

        // Notification Icon (unchanged)
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          },
          child: GetBuilder<NotificationController>(
            init: notificationController,
            builder: (controller) => Container(
              width: 85,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.black,
                      size: 35,
                    ),
                    onPressed: () => Navigator.of(navigatorKey.currentContext!).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const NotificationScreen(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Obx(() => Visibility(
                      visible: controller.unreadNotificationCount.value > 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Text(
                          controller.unreadNotificationCount.value.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
                  ),
                ],

              ),
            ),
          ),
        ),
      ],

    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontFamily: 'Aileron',
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: 'Aileron',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, bool status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status ? color.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status ? color : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: status ? color : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: status ? color : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Aileron',
            ),
          ),
        ],
      ),
    );
  }

  Widget getBottomNavTopWidget() {
    return SizedBox(
      height: 11.h,
      child: GestureDetector(
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: Container(
            color: Colors.lightBlue.shade100,
            height: 11.h,
            child: Row(
              children: [
                Expanded(
                    child: Center(
                        child: SizedBox(
                          width: 13.w,
                          height: 6.h,
                          child: getCachedNetworkImage(imgUrl: localSeller.userProfilePic),
                        ))),
                Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(localSeller.userBusinessName,
                            textScaleFactor: 1.4,
                            style: TextStyle(
                                color: Colors.blue[900], fontWeight: FontWeight.bold)),
                        Text(localSeller.userAddress,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 1.1,
                            style: const TextStyle(color: Colors.blue)),
                      ],
                    ))
              ],
            ),
          ),
        ),
        onTap: () {
          showGeneralDialog(
            context: navigatorKey.currentContext!,
            transitionBuilder: (context, a1, a2, child) {
              var curve = Curves.easeInOut.transform(a1.value);
              return Transform.scale(
                scale: curve,
                child: SafeArea(
                  child: Dialog(
                      insetPadding: EdgeInsets.zero,
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            const ProfileScreen(),
                            Positioned(
                              right: 0.0,
                              child: InkResponse(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) {
              return Container();
            },
          );
        },
      ),
    );
  }

  Drawer buildDrawer(BuildContext context, BottomNavController bottomNavController) {
    return Drawer(
      backgroundColor: Colors.white, // Set drawer background to white
      child: SingleChildScrollView( // Make the drawer scrollable
        child: Column(
          children: [
            // Close Button
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24, // Add top padding for spacing
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context); // Close the drawer
                  },
                ),
              ),
            ),
            // Custom Drawer Header
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                // top: 24, // Add top padding for spacing
              ),
              child: Row(
                children: [
                  Container(
                    width: 15.w,
                    height: 7.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(localSeller.userProfilePic),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                  SizedBox(width: 4.w), // Adjust spacing if needed
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localSeller.userFullName,
                          overflow: TextOverflow.ellipsis, // Optional: handles very long names
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontFamily: 'Aileron',
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            letterSpacing: 0.03,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat.yMMMd().format(localSeller.userJoinedSince),
                          style: TextStyle(
                            color: const Color(0xFF727173),
                            fontSize: 8.sp,
                            fontFamily: 'Aileron',
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                            letterSpacing: 0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16, // Add space after the header
            ),
            const Divider(), // Add a divider below the header (optional)
            const SizedBox(
              height: 8, // Space between divider and list items
            ),
            ...navDrawerItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16), // Add padding around each card
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white, // Background color of the card
                  elevation: 4, // Add shadow to the card
                  child: ListTile(
                    title: Text(item['title']),
                    onTap: () {
                      bottomNavController
                          .changeDrawerIndex(index); // Change the drawer item index
                      Navigator.pop(context); // Close the drawer
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Scaffold(
                                backgroundColor: Colors.white, // Set the background color to white
                                body: item['screen'],
                              )));
                    },
                    trailing: const Icon(Icons.arrow_forward_ios), // Add a right arrow icon
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  ElevatedButton getLargeButtonWithIcon({
    required String title,
    required IconData icon,
    double txtScale = 1.0,
    required VoidCallback onPressed,
    required Color bgColor,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: bgColor, // Set text color to white
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Text(
            title,
            textScaleFactor: txtScale,
          ),
        ],
      ),
    );
  }

  getLargeButton(
      {required String title,
        required onPress,
        txtScale = 1.0,
        bgColor = Colors.black,
        txtColor = Colors.white}) {
    return SizedBox(
      height: 4.h,
      width: 95.w,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              backgroundColor: bgColor,
              foregroundColor: txtColor),
          onPressed: onPress,
          child: FittedBox(
            child: Text(
              title,
              textScaleFactor: txtScale,
            ),
          )),
    );
  }

  // getOtpInput(TextEditingController controller, bool autoFocus) {
  //   return SizedBox(
  //     height: 60,
  //     width: 50,
  //     child: TextField(
  //       autofocus: autoFocus,
  //       textAlign: TextAlign.center,
  //       keyboardType: TextInputType.number,
  //       controller: controller,
  //       maxLength: 1,
  //       cursorColor: Theme.of(navigatorKey.currentContext!).primaryColor,
  //       decoration: const InputDecoration(
  //           border: OutlineInputBorder(),
  //           counterText: '',
  //           hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
  //       onChanged: (value) {
  //         if (value.length == 1) {
  //           FocusScope.of(navigatorKey.currentContext!).nextFocus();
  //         }
  //       },
  //     ),
  //   );
  // }

  requiredField() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '*',
        textScaleFactor: 1.5,
        style: TextStyle(color: Colors.red.shade900),
      ),
    );
  }

  AppBar offerDetailsAppBar({required OfferPreviewController controller}) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        onPressed: () async {
          if (controller.isOfferCreated) {
            await Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) =>  const BottomNavScreen()),
                  (route) => false,
            );
          } else {
            Navigator.of(navigatorKey.currentContext!).pop();
          }
        },
      ),
      actions: const [
        //   IconButton(
        //    icon: const Icon(Icons.favorite_border_outlined, color: Colors.black),
        //    onPressed: () => {},
        //  ),
        //   IconButton(
        //     icon: const Icon(Icons.share_outlined, color: Colors.black),
        //    onPressed: () {},
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.search_outlined, color: Colors.black),
        //    onPressed: () {},
        //   ),
      ],
    );
  }

//  Container getOfferHeadingContainer(
  //     {required List<XFile> offerImgs,
  //     required String productName,
  //     required String offerAddress}) {
  //   return Container(
  //     height: 8.h,
  //    color: Colors.pink.shade100,
  //    child: Row(
  //       mainAxisSize: MainAxisSize.max,
  //       children: [
  //         Expanded(
  //            child: Padding(
  //          padding: const EdgeInsets.all(8.0),
  //          child: Image.file(File(offerImgs.first.path)),
  //         )),
  //        Expanded(
  //        flex: 4,
  //        child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //        child: Column(
  //        crossAxisAlignment: CrossAxisAlignment.start,
  //        mainAxisAlignment: MainAxisAlignment.start,
  //        children: [
  //          Text(productName,
  //            style: const TextStyle(
  //                color: Colors.pink, fontWeight: FontWeight.bold)),
  //        Text(offerAddress, style: const TextStyle(color: Colors.pink)),
  //        ],
  //      ),
  //    ),
  //   ),
  //  Expanded(
  //      flex: 2,
  //     child: CustomPaint(
  //      painter: MyParallelogram(),
  //      child: const Center(
  //          child: Text(
  //       'Trending',
  //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //     )),
  //    ))
  //    ],
  //  ),
  //  );
  // }

  Widget getCachedNetworkImage({String? imgUrl}) {
    if (imgUrl == null || imgUrl.isEmpty) {
      return SvgPicture.asset(
        'lib/Images/Layer_1-2.svg', // Path to your SVG asset
        fit: BoxFit.contain,
      ); // Replace with your placeholder image
    }
    return CachedNetworkImage(
      imageUrl: imgUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget validateButtonForTxtField({required String title, required void Function() onPress}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 5.h,
        width: 20.w,
        child: TextButton(
          onPressed: onPress,
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent, // Transparent background
            side: const BorderSide(color: Colors.black,), // Black border with specified width
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Set the border radius
            ),
          ),
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Adjust padding
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black, // Set the text color
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp, // Adjust font size
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  getCard({Color? color, Widget? child}) {
    return Card(
      surfaceTintColor: color ?? Colors.white,
      child: child,
    );
  }
}
