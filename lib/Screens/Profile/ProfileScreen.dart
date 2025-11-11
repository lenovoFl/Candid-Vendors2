import 'package:cached_network_image/cached_network_image.dart';
import 'package:candid_vendors/Controllers/Profile/ProfileController.dart';
import 'package:candid_vendors/Screens/AcoountScreen.dart';
import 'package:candid_vendors/Screens/OfferScreens/ActiveOfferScreen.dart';
import 'package:candid_vendors/Screens/PaymentScreens/RechargePaymentScreen.dart';
import 'package:candid_vendors/Services/Collections/Offers/OfferHistory/OfferHistoryColl.dart';
import 'package:candid_vendors/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';
import '../../Controllers/Profile/VendorOutletController/AddVendorOutletController.dart';
import '../../Services/Collections/User/VendorUserColl.dart';

class ProfileScreen extends StatefulWidget {
  final VendorUserColl? currentUser;
  const ProfileScreen({super.key, this.currentUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<int> getTotalDeals() async {
    final count = await isar.offerHistoryColls.where().count();
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      backgroundColor: Colors.white,
      body: GetBuilder(
        init: ProfileController(),
        // id: AddVendorOutletController(),
        builder: (controller) {
          return StreamBuilder(
            stream: isar.vendorUserColls
                .where()
                .build()
                .watch(fireImmediately: true),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }
              try {
                VendorUserColl? user = snapshot.data?.first;
                return AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    child: snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data!.isEmpty
                        ? const Center(
                            child: Text('No User data available!'),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50.h,
                                  width: 110.w,
                                  child: Card(
                                    color: const Color(0xFF00BADD),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 6,
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: CachedNetworkImage(
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      height: 12.h,
                                                      width: 25.w,
                                                      decoration:
                                                          ShapeDecoration(
                                                        image: DecorationImage(
                                                          image: CachedNetworkImageProvider(
                                                              localSeller
                                                                  .userProfilePic),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side:
                                                              const BorderSide(
                                                                  width: 2,
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        shadows: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x19000000),
                                                            blurRadius: 5,
                                                            offset:
                                                                Offset(5, 5),
                                                            spreadRadius: 0,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    imageUrl: user!
                                                            .userProfilePic
                                                            .isNotEmpty
                                                        ? user.userProfilePic
                                                        : 'https://png.pngtree.com/png-vector/20190710/ourmid/pngtree-user-vector-avatar-png-image_1541962.jpg',
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 10,
                                                  right: 10,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      controller
                                                          .changeProfileImg(
                                                              context);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.7),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.black,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 1.h),
                                                    Text(
                                                      'Seller Name: ${user.userFullName}',
                                                      textScaleFactor: 1.4,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 1.h),
                                                    Text(
                                                      'Joined since: ${DateFormat.yMMMMEEEEd().format(user.userJoinedSince.toLocal())}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            color: Colors.transparent,
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'SellerID: ${user.userId}',
                                                        textScaleFactor: 1.0,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Clipboard.setData(
                                                            ClipboardData(
                                                                text: user
                                                                    .userId));
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Seller ID copied to clipboard'),
                                                            duration: Duration(
                                                                seconds: 2),
                                                          ),
                                                        );
                                                      },
                                                      child: const Icon(
                                                        Icons.copy,
                                                        color: Colors.white,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 1.h),
                                                // const Text(
                                                //   'Store Name:',
                                                //   textScaleFactor: 1.0,
                                                //   style: TextStyle(
                                                //     color: Colors.white,
                                                //     fontWeight: FontWeight.bold,
                                                //   ),
                                                // ),
                                                SizedBox(height: 1.h),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: 90.w,
                                                        height: 6.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                                child: Center(
                                                                  child: Text(
                                                                    user.userBusinessName,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
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
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                          MaterialPageRoute(builder: (context) => const ActiveOfferScreen()),
                                                        );
                                                      },
                                                      child: _buildCard(
                                                        'My Offers',
                                                        Icons.card_giftcard,
                                                        iconColor: Colors.orange, // My Offers icon
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                          MaterialPageRoute(builder: (context) => const AccountScreen()),
                                                        );
                                                      },
                                                      child: _buildCard(
                                                        'Accounts',
                                                        Icons.account_balance,
                                                        iconColor: Colors.blue, // Accounts icon
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                          MaterialPageRoute(builder: (context) => const RechargePaymentScreen()),
                                                        );
                                                      },
                                                      child: _buildCard(
                                                        'Buy Offers',
                                                        Icons.money,
                                                        iconColor: Colors.green, // Buy Offers icon
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Container(
                                    width: 90.w,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(13),
                                          child: Row(
                                            children: [
                                              // Container(
                                              //   height: 10.h,
                                              //   width: 10.h,
                                              //   padding: EdgeInsets.only(bottom: 18.h),
                                              //   decoration: ShapeDecoration(
                                              //     image: DecorationImage(
                                              //       image: CachedNetworkImageProvider(
                                              //           localSeller.userProfilePic),
                                              //       fit: BoxFit.fill,
                                              //     ),
                                              //     shape: RoundedRectangleBorder(
                                              //       side: const BorderSide(
                                              //           width: 2, color: Colors.white),
                                              //       borderRadius: BorderRadius.circular(6),
                                              //     ),
                                              //     shadows: const [
                                              //       BoxShadow(
                                              //         color: Color(0x19000000),
                                              //         blurRadius: 5,
                                              //         offset: Offset(5, 5),
                                              //         spreadRadius: 0,
                                              //       )
                                              //     ],
                                              //   ),
                                              //   margin: EdgeInsets.only(left: 5.w),
                                              // ),

                                              Container(
                                                height: 10.h,
                                                width: 10.h,
                                                margin:
                                                    EdgeInsets.only(left: 5.w),
                                                decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        width: 2,
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  shadows: const [
                                                    BoxShadow(
                                                      color: Color(0x19000000),
                                                      blurRadius: 5,
                                                      offset: Offset(5, 5),
                                                      spreadRadius: 0,
                                                    )
                                                  ],
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: user
                                                              ?.userCompanyLogo
                                                              ?.isNotEmpty ==
                                                          true
                                                      ? user!.userCompanyLogo
                                                      : 'https://png.pngtree.com/png-vector/20190710/ourmid/pngtree-user-vector-avatar-png-image_1541962.jpg',
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: ShapeDecoration(
                                                      image: DecorationImage(
                                                        image:
                                                            imageProvider, // Use the provided imageProvider instead of creating new one
                                                        fit: BoxFit
                                                            .cover, // Changed from fill to cover for better scaling
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: const BorderSide(
                                                            width: 2,
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      shadows: const [
                                                        BoxShadow(
                                                          color:
                                                              Color(0x19000000),
                                                          blurRadius: 5,
                                                          offset: Offset(5, 5),
                                                          spreadRadius: 0,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    decoration: ShapeDecoration(
                                                      color: Colors.grey[200],
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: const BorderSide(
                                                            width: 2,
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                    ),
                                                    child: const Icon(
                                                        Icons.error,
                                                        color: Colors.grey),
                                                  ),
                                                  memCacheWidth: 1000,
                                                  memCacheHeight: 1000,
                                                  fadeInDuration:
                                                      const Duration(
                                                          milliseconds: 300),
                                                ),
                                              ),
                                              SizedBox(width: 5.w),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Store Name', // Adding "Store Name" text above the business name
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16
                                                          .sp, // Adjust the font size if needed
                                                      fontFamily: 'Aileron',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing:
                                                          0.03, // Adjust the font weight if needed
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1.5.h,
                                                  ),
                                                  Text(
                                                    user.userBusinessName,
                                                    //  ? user.myOutlets.last.storeName
                                                    //   : 'No updated store names', // Show a default message if the list is empty
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.sp,
                                                      fontFamily: 'Aileron',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: 0.03,
                                                    ),
                                                  ),
                                                  Text(
                                                    user.myOutlets.last
                                                        .userOutletAddress1,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.sp,
                                                      fontFamily: 'Aileron',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: 0.03,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  user.offerCount.toString(),
                                                  style: const TextStyle(
                                                    color: Color(0xFFFB4646),
                                                    fontSize: 16,
                                                    fontFamily: 'Aileron',
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: -0.80,
                                                  ),
                                                ),
                                                const Text(
                                                  'Offers Left',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    fontFamily: 'Aileron',
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.02,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                FutureBuilder<int>(
                                                  future: getTotalDeals(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const SizedBox(
                                                        width:
                                                            24, // Adjust the size of the CircularProgressIndicator
                                                        height:
                                                            24, // Adjust the size of the CircularProgressIndicator
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth:
                                                              2, // Adjust the thickness of the progress indicator
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Error: ${snapshot.error}');
                                                    } else {
                                                      return Text(
                                                        snapshot.data
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFFFB4646),
                                                          fontSize: 16,
                                                          fontFamily: 'Aileron',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing: -0.80,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                                const Text(
                                                  'Total Deals',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    fontFamily: 'Aileron',
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.02,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Container(
                                  height: 6.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                    Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Adjust the radius here
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.storefront,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            user.userBusinessName,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: 'Aileron',
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.03,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 2.h),

                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF00BADD), // First color
                                        Color(0xFF00BADD), // First color
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    border: Border.all(
                                      color: Colors.white, // Border color
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8), // Radius
                                  ),
                                  child: Text(
                                    'Your store information :',
                                    style: GoogleFonts.workSans(
                                      color: Colors.white, // Text color visible on gradient
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.02,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                    width: 90.w,
                                    child: Center(
                                        child: Column(children: [
                                       // Row(
                                      //   children: [
                                      //     Expanded(
                                      //       child: SizedBox(
                                      //         height: 6.h,
                                      //         width: 20.w,
                                      //         child: Container(
                                      //           decoration: BoxDecoration(
                                      //             border: Border.all(
                                      //               color: Colors
                                      //                   .black, // Set border color to black
                                      //             ),
                                      //             borderRadius:
                                      //                 BorderRadius.circular(
                                      //                     10.0), // Optional: Add border radius
                                      //           ),
                                      //           child: const Padding(
                                      //             padding: EdgeInsets.symmetric(
                                      //                 horizontal: 5),
                                      //             child: Row(
                                      //               children: [
                                      //                 Icon(
                                      //                   Icons.info,
                                      //                   color: Colors.black,
                                      //                 ),
                                      //                 Expanded(
                                      //                   child: Text(
                                      //                     '      Your store information',
                                      //                     style: TextStyle(
                                      //                       color: Colors.black,
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),

                                          StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('candidVendors')
                                            .doc(firebaseAuth
                                                    .currentUser?.uid ??
                                                '') // Replace with actual user ID
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }

                                          if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'));
                                          }

                                          if (!snapshot.hasData ||
                                              !snapshot.data!.exists) {
                                            return const Center(
                                                child:
                                                    Text('No data available'));
                                          }

                                          Map<String, dynamic> vendorData =
                                              snapshot.data!.data()
                                                  as Map<String, dynamic>;

                                          return StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('candidVendors')
                                                .doc(firebaseAuth
                                                        .currentUser?.uid ??
                                                    '')
                                                .collection(
                                                    'candidVendorOutlets')
                                                .limit(1)
                                                .snapshots(),
                                            builder: (context, outletSnapshot) {
                                              if (outletSnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                              // debugPrint(
                                              //     "vendordata :$outletSnapshot");
                                              Map<String, dynamic> outletData =
                                                  {};
                                              if (outletSnapshot.hasData &&
                                                  outletSnapshot
                                                      .data!.docs.isNotEmpty) {
                                                outletData = outletSnapshot
                                                        .data!.docs.first
                                                        .data()
                                                    as Map<String, dynamic>;
                                              }

                                              return SingleChildScrollView(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: SizedBox(
                                                  width: 90.w,
                                                  child: Form(
                                                    key: GlobalKey<FormState>(),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        _buildDetailField(
                                                            'Address Line 1',
                                                            outletData[
                                                                    'userOutletAddress1'] ??
                                                                ''),
                                                        _buildDetailField(
                                                            'Address Line 2',
                                                            outletData[
                                                                    'userOutletAddress2'] ??
                                                                ''),
                                                        _buildDetailField(
                                                            'Near Landmark',
                                                            outletData[
                                                                    'userOutletAddressBuildingStreetArea'] ??
                                                                ''),
                                                        _buildDetailField(
                                                            'Pincode ',
                                                            outletData[
                                                                    'userOutletAddressPinCode'] ??
                                                                ''),
                                                        _buildDetailField(
                                                            'City',
                                                            outletData[
                                                                    'userOutletAddressCity'] ??
                                                                ''),
                                                        _buildDetailField(
                                                            'State',
                                                            outletData[
                                                                    'userOutletAddressState'] ??
                                                                ''),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      const Divider(),
                                      const SizedBox(height: 10),
                                      // Add some space between the button and the copyright text
                                      SizedBox(
                                        width: 100.w,
                                        height: 5.h,
                                        child: const Text(
                                          '© Candid Offers Seller Stores ',
                                          style: TextStyle(
                                            color: Color(0xFFA6A6A6),
                                            fontSize: 12,
                                            fontFamily: 'Aileron',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                          textAlign: TextAlign
                                              .center, // Center align the text
                                        ),
                                      ),
                                    ])
                                        //)
                                        ))
                              ],
                            ),
                          ));
              } catch (e) {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
    );
  }
}

Widget _buildCard(String title, IconData iconData, {Color iconColor = const Color(0xFFC2FF3D)}) {
  return Container(
    width: 28.w,
    height: 10.h,
    decoration: BoxDecoration(
      color: const Color(0xFF00badd),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.white,
          blurRadius: 15,
          offset: Offset(0, 0),
          spreadRadius: 0,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: 48,
          color: iconColor, // Yaha color parameter use kiya
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}

Widget _buildDetailField(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0), // Space between each detail
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textScaleFactor: 1.3,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.black
                .withOpacity(0.8), // Slightly transparent black for label
          ),
        ),
        const SizedBox(height: 8), // Spacing between label and value
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // Circular border
            border: Border.all(
              color: Colors.black,
            ), // Black border
          ),
          child: TextField(
            controller: TextEditingController(text: value),
            enabled: false, // Make text field read-only
            decoration: const InputDecoration(
              border: InputBorder.none, // Remove default border
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12), // Padding inside text field
            ),
            style: TextStyle(
              fontFamily: 'Roboto',
              color: Colors.black.withOpacity(0.8), // Text color
            ),
          ),
        ),
      ],
    ),
  );
}

//  Expanded(
//     child: ElevatedButton(
//       onPressed: controller.onCancelClickHandler,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.blue.shade900,
//       ),
//       child: const Text(
//         'Cancel',
//         style: TextStyle(color: Colors.white),
//        ),
//     ),
//    ),
//    SizedBox(width: 1),
//     Expanded(
//       child: ElevatedButton(
//        onPressed: controller.onReportClickHandler,
//        style: ElevatedButton.styleFrom(
//          backgroundColor: Colors.blue.shade900,
//      ),
//      child: const Text(
//        'Report',
//       style: TextStyle(color: Colors.white),
//     ),
//    ),
//   ),
//ListView.builder(
//     itemCount: controller.vendor.myOutlets.length,
//     shrinkWrap: true,
//     itemBuilder: (context, index) {
//       final outlet = controller.vendor.myOutlets[index];
//       return OpenContainer(
//         closedColor: Colors.white,
//         middleColor: Colors.blue.shade900,
//         openColor: Colors.white,
//         closedElevation: 10,
////         openElevation: 10,
//        transitionType: ContainerTransitionType.fadeThrough,
//        transitionDuration: const Duration(seconds: 1),
//        closedBuilder: (context, action) {
//         return Card(
//           elevation: 0,
//          shadowColor: Colors.blue.shade900,
//         child: Padding(
//          padding: const EdgeInsets.all(8.0),
//       child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: [
//         _buildDetail('StoreName:', outlet.storeName),
//        SizedBox(height: 2.h,),
//       _buildDetail('City:', outlet.userOutletAddressCity),
//    SizedBox(height: 2.h,),
//      _buildDetail('State:', outlet.userOutletAddressState),
//      SizedBox(height: 2.h,),
//       _buildDetail('Address:', outlet.userOutletAddress1),
//       SizedBox(height: 2.h,),
//       _buildDetail('Address Line 2:', outlet.userOutletAddress2),
//       const SizedBox(height: 8), // Add space between each detail
//        AnimatedSwitcher(
//          duration: const Duration(seconds: 1),
//          child: controller.vendor.myOutlets.length > 1
//             ? IconButton(
//               onPressed: () {},
//                icon: const Icon(Icons.delete_forever_outlined),
//              )
//              : const SizedBox(),
//         )
//         ],
//        ),
//       ),
//     );
//    },
//    openBuilder: (context, action) {
//        return
//         EditVendorOutletScreen(outlet: outlet);
////      },
//     );
//    },
//  ),
//  AnimatedSwitcher(
//   duration: const Duration(seconds: 1),
//    child: !controller.showMap
//       ? const SizedBox()
//       : SizedBox(
//      height: 30.h,
//      width: 90.w,
//     child: GoogleMap(
//       mapType: MapType.normal,
//       buildingsEnabled: true,
//       myLocationEnabled: true,
//      onTap: controller.onGoogleMapTap,
//      initialCameraPosition: controller.kGooglePlex!,
//       markers: <Marker>{
//       Marker(
//          markerId: const MarkerId("My outlet"),
//          position: controller.center,
//   icon: BitmapDescriptor.,
//         infoWindow: const InfoWindow(
//            title: 'Outlet Address',
//          ),
//       ),
//     },
//      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
//        Factory<OneSequenceGestureRecognizer>(
//             () => EagerGestureRecognizer(),
////       ),
//     },
//      onMapCreated: (GoogleMapController myGoogleMapController) {
//         controller.googleMapController.complete(myGoogleMapController);
//       },
//    ),
//  ),
//   ),
// const SizedBox(height: 24),
// Add spacing before the social media input fields
//   _buildSocialMediaInput(
//      hintText: 'Enter Google URL',
//    imagePath:
//        'lib/Images/google.png', // Specify the image asset path
//  ),
//   _buildSocialMediaInput(
//     labelText: 'Instagram URL*',
//     hintText: 'Enter Instagram URL',
//      imagePath:
//         'lib/Images/instagram.png', // Specify the image asset path
//    ),
//     _buildSocialMediaInput(
//      labelText: 'Youtube URL*',
//       hintText: 'Enter Youtube URL',
//      imagePath:
//       'lib/Images/youtube.png', // Specify the image asset path
//),
//   _buildSocialMediaInput(
//     labelText: 'Facebook URL*',
//     hintText: 'Enter Facebook URL',
//     imagePath:
//        'lib/Images/facebook.png', // Specify the image asset path
//   ),
//// ElevatedButton(
//  onPressed: () {
//  },
// style: ElevatedButton
//     .styleFrom(
//     foregroundColor: Colors.white, backgroundColor: Colors.black,
// Set the button text color to white
//      fixedSize:
//      const Size(350, 50),
// Set the desired width and height for the button
//      shape:
//    RoundedRectangleBorder(
//      borderRadius:
//      BorderRadius.circular(
//          10), // Set a square shape
//    ),
//   ),
//    child: const Text('Save'),
//    ),
//  Row(
//    children: [
//       Expanded(
//        child: SizedBox(
//        height: 10.h,
//       width: 20.w,
//      child: Container(
//        decoration: BoxDecoration(
////    border: Border.all(
//   color: Colors.white,
//  ),
//     borderRadius: BorderRadius.circular(10.0), // Optional: Add border radius
//    ),
//    child: const Padding(
//     padding: EdgeInsets.symmetric(horizontal: 8.0),
//     child: Row(
//       children: [
//        Icon(
//          Icons.info,
//         color: Colors.black,
//        ),
//         Expanded(
//          child: Text(
//           'Bank information',
//         style: TextStyle(
//           color: Colors.black,
//         ),
//        ),
//         ),
//         Icon(
//           Icons.keyboard_arrow_down_rounded,
//           color: Colors.black,
//          ),
//        ],
//       ),
//       ),
//       ),
//     ),
//    ),
//   ],
//  ),
// const SizedBox(height: 24),
// Add spacing before the social media input fields
//   _buildSocialMediaInput(
//      hintText: 'Enter Google URL',
//    imagePath:
//        'lib/Images/google.png', // Specify the image asset path
//  ),
//   _buildSocialMediaInput(
//     labelText: 'Instagram URL*',
//     hintText: 'Enter Instagram URL',
//      imagePath:
//         'lib/Images/instagram.png', // Specify the image asset path
//    ),
//     _buildSocialMediaInput(
//      labelText: 'Youtube URL*',
//       hintText: 'Enter Youtube URL',
//      imagePath:
//       'lib/Images/youtube.png', // Specify the image asset path
//),
//   _buildSocialMediaInput(
//     labelText: 'Facebook URL*',
//     hintText: 'Enter Facebook URL',
//     imagePath:
//        'lib/Images/facebook.png', // Specify the image asset path
//   ),
//// ElevatedButton(
//  onPressed: () {
//  },
// style: ElevatedButton
//     .styleFrom(
//     foregroundColor: Colors.white, backgroundColor: Colors.black,
// Set the button text color to white
//      fixedSize:
//      const Size(350, 50),
// Set the desired width and height for the button
//      shape:
//    RoundedRectangleBorder(
//      borderRadius:
//      BorderRadius.circular(
//          10), // Set a square shape
//    ),
//   ),
//    child: const Text('Save'),
//    ),
//  Row(
//    children: [
//       Expanded(
//        child: SizedBox(
//        height: 10.h,
//       width: 20.w,
//      child: Container(
//        decoration: BoxDecoration(
////    border: Border.all(
//   color: Colors.white,
//  ),
//     borderRadius: BorderRadius.circular(10.0), // Optional: Add border radius
//    ),
//    child: const Padding(
//     padding: EdgeInsets.symmetric(horizontal: 8.0),
//     child: Row(
//       children: [
//        Icon(
//          Icons.info,
//         color: Colors.black,
//        ),
//         Expanded(
//          child: Text(
//           'Bank information',
//         style: TextStyle(
//           color: Colors.black,
//         ),
//        ),
//         ),
//         Icon(
//           Icons.keyboard_arrow_down_rounded,
//           color: Colors.black,
//          ),
//        ],
//       ),
//       ),
//       ),
//     ),
//    ),
//   ],
//  ),
//     Padding(
//     padding: const EdgeInsets.only(left: 1, right: 240),
//     child: Text(
//      'IFSC Code: ${controller.bankAccountHolderIFSCController.text}', // Show entered bank account number
//      style: const TextStyle(
//        color: Colors.black,
//       fontSize: 15,
////        fontFamily: 'Aileron',
//      fontWeight: FontWeight.w700,
//        height: 0,
//     ),
//    ),
//   ),
//    SizedBox(height: 2.h,),
//    const Divider(),