import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:candid_vendors/Screens/Help&TutorialsScreens/Help&TutorialsScreen.dart';
import 'package:candid_vendors/Screens/OfferScreens/ActiveOfferScreen.dart';
import 'package:candid_vendors/Screens/OfferScreens/ShareandreferScreen.dart';
import 'package:candid_vendors/Screens/PaymentScreens/RechargePaymentScreen.dart';
import 'package:candid_vendors/Screens/QRDataScreen.dart';
import 'package:candid_vendors/Screens/Scanqr.dart';
import 'package:candid_vendors/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sizer/sizer.dart';
import '../Services/Collections/Offers/OfferHistory/OfferHistoryColl.dart';
import 'AcoountScreen.dart';
import 'OfferScreens/OfferUploadHistory.dart';
import 'OfferScreens/offerdetailsScreen.dart';
import 'PaymentScreens/PassBookScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  final widthFactor = 0.90;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: homeScreenController,
      builder: (homeController) {
        return Scaffold(
          backgroundColor: Colors.white,
           // appBar: myWidgets.myAppbar(title: 'Home', bottomNavController: bottomNavController, context: context, ),
          body: SizedBox(
            height: 100.h,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    child: homeController.acceptedVendorOffer
                        ? SizedBox(
                            width: 90.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.pink.shade100,
                                  height: 10.h,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text('BUY 1 GET 1 FREE',
                                            textScaleFactor: 1.5,
                                            style: TextStyle(
                                                color: Colors.blue.shade900)),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text('Fox Club Shirts',
                                            textScaleFactor: 1.2,
                                            style:
                                                TextStyle(color: Colors.blue)),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: 40.w,
                                    child: Card(
                                      color: Colors.blueGrey.shade200,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('PRIME',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Container(
                                            color: Colors.purple,
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Extra 5%',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    color: Colors.pink.shade100,
                                    height: 10.h,
                                    margin: const EdgeInsets.only(
                                        top: 16, bottom: 16),
                                    child: Image.asset(
                                        'lib/Images/app_icon_mini.jpeg'),
                                  ),
                                ),
                                Text(
                                  'Offer Availed by',
                                  textScaleFactor: 1.1,
                                  style: TextStyle(color: Colors.blue.shade900),
                                ),
                                Container(
                                  color: Colors.blue.shade100,
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person_outline_outlined,
                                        color: Colors.blue.shade900,
                                      ),
                                      Text(
                                        'NALIN JAISWAL',
                                        textScaleFactor: 1.1,
                                        style: TextStyle(
                                            color: Colors.blue.shade900),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.blue.shade100,
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(top: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        Icons.phone_outlined,
                                        color: Colors.blue.shade900,
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          '9850397825',
                                          textScaleFactor: 1.1,
                                          style: TextStyle(
                                              color: Colors.blue.shade900),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Text(
                                          'CALL',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: myWidgets.getLargeButton(
                                      bgColor: Colors.blue.shade900,
                                      title: 'ACCEPT',
                                      onPress: () {}),
                                )
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 22.h,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(top: 3.h),
                                    decoration: const ShapeDecoration(
                                      color: Color(0xFF00BADD),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(6),
                                          bottomRight: Radius.circular(6),
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.w, top: 1.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                  height:
                                                  10),
                                              Text(
                                                localSeller.userFullName,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.sp,
                                                  fontFamily: 'Aileron',
                                                  fontWeight: FontWeight.w700,
                                                  height: 0,
                                                  letterSpacing: 0.03,
                                                ),
                                              ),
                                              const SizedBox(
                                                  height:
                                                  10),
                                              Text(
                                                localSeller.userEmail1,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.sp,
                                                  fontFamily: 'Aileron',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                  letterSpacing: 0.02,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:   EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      ' Available Offers',
                                                      style:  GoogleFonts.workSans(
                                                        color: Colors.white,
                                                        fontSize: 10.sp,
                                                        // fontFamily: 'Aileron',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0,
                                                        letterSpacing: 0.02,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                            EdgeInsets.only(
                                                              top: 8,
                                                              left: 30.0,
                                                          right: 8,
                                                          bottom: 8),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            'lib/Images/Vector (1).svg', // Path to your SVG asset
                                                            fit: BoxFit.fill,
                                                          ),
                                                          const SizedBox(
                                                              width:
                                                                  10), // Adjust the spacing between the icon and the text
                                                          Text(
                                                            localSeller
                                                                .offerCount
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18.sp,
                                                              fontFamily:
                                                                  'Aileron',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              height: 0,
                                                              letterSpacing:
                                                                  -1.25,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 1,
                                                height: 8.h,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Recharge',
                                                      style: GoogleFonts.workSans(
                                                        color: Colors.white,
                                                        fontSize: 10.sp,
                                                        // fontFamily: 'Aileron',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0,
                                                        letterSpacing: 0.02,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),
                                                    SizedBox(
                                                      width: 35
                                                          .w, // Set the desired width
                                                      height: 4.5
                                                          .h, // Set the desired height
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          padding: EdgeInsets.zero, // Remove default padding to show gradient fully
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(8),
                                                            side: const BorderSide(
                                                              color: Colors.white, // White border
                                                              width: 1,
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) {
                                                                return const RechargePaymentScreen();
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        child: Ink(
                                                          decoration: BoxDecoration(
                                                            gradient: const LinearGradient(
                                                              colors: [
                                                                Color.fromRGBO(0, 200, 0, 1),   // First color (bright green)
                                                                Color.fromRGBO(0, 120, 0, 1),   // Second color (darker green shade)

                                                              ],
                                                              begin: Alignment.topCenter,
                                                              end: Alignment.bottomCenter,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            constraints: BoxConstraints(
                                                              minWidth: 88, // Adjust as needed
                                                              minHeight: 36, // Adjust as needed
                                                            ),
                                                            child: Text(
                                                              'BUY OFFER',
                                                              textAlign: TextAlign.center,
                                                              style: GoogleFonts.workSans(
                                                                color: Colors.white,
                                                                fontSize: 9.sp,
                                                                fontWeight: FontWeight.w700,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Account Summary         ',
                                                      style: GoogleFonts.workSans(
                                                        color: Colors.white,
                                                        fontSize: 10.sp,
                                                         fontWeight:
                                                            FontWeight.w500,
                                                        height: 0,
                                                        letterSpacing: 0.02,
                                                      ),
                                                    ),
                                                    SizedBox(height: 1.h),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Expanded( // Makes the button stretch in row
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 16), // Left & right padding
                                                            child: SizedBox(
                                                              height: 40, // Rectangular height
                                                              child: ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:   Colors.white,
                                                                  elevation: 0,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    side: const BorderSide(
                                                                      color: Color(0xFF00BADD),
                                                                      width: 1.5,
                                                                    ),
                                                                  ),
                                                                  padding: EdgeInsets.zero,
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => const PassbookScreen(),
                                                                    ),
                                                                  );
                                                                },
                                                                child: Text(
                                                                  'VIEW PASSBOOK',
                                                                  textAlign: TextAlign.center,
                                                                  style: GoogleFonts.workSans(
                                                                    color: Colors.green.shade800,
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 10.h,
                                    width: 10.h,
                                    padding: EdgeInsets.only(bottom: 18.h),
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            localSeller.userProfilePic),
                                        fit: BoxFit.fill,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 1, color: Colors.white),
                                        borderRadius: BorderRadius.circular(6),
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
                                    margin: EdgeInsets.only(left: 5.w,top: 35),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(230, 0, 0, 1), // First color
                                            Color.fromRGBO(230, 0, 0, 1), // First color
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
                                        '* Live Offers Details :',
                                        style: GoogleFonts.workSans(
                                          color: Colors.white, // Text color visible on gradient
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.02,
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 0.5.h,
                                    ),
                                    StreamBuilder(
                                      stream: isar.offerHistoryColls
                                          .where()
                                          .offerIDIsNotEmpty()
                                          .build()
                                          .watch(fireImmediately: true),
                                      builder: (context, snapshot) {
                                        debugPrint('ACTIVE OFFER | $snapshot');
                                        List<OfferHistoryColl>? offers =
                                            snapshot.data;
                                        // Filter out the review offers
                                        List<OfferHistoryColl>? activeOffers =
                                            offers
                                                ?.where((offer) =>
                                                    offer.offerStatus ==
                                                    OfferStatus.live)
                                                .toList();
                                        return AnimatedSwitcher(
                                          duration: const Duration(seconds: 1),
                                          child: activeOffers == null
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : activeOffers.isEmpty
                                                  ? Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'No active offers!',
                                                  style: GoogleFonts.workSans(
                                                    color: Colors.black,
                                                    fontSize: 12.sp,
                                                     fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                 Container(
                                                  width: 100, // adjust underline width as needed
                                                  height: 2, // underline thickness
                                                  color: Colors.black, // underline color
                                                ),
                                              ],
                                            ),
                                          )

                                            : SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        children: List.generate(
                                                          activeOffers.length,
                                                          (index) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 0.0),
                                                            child:
                                                                _buildCardWithActiveButton(
                                                                    activeOffers[
                                                                        index],
                                                                    context),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),


                                    Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: const BorderSide(
                                          color: Colors.black, // Black border color
                                          width: 0.5, // Border width
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Offers Chart',
                                                  style: GoogleFonts.workSans(
                                                    color: Colors.black,
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.03,
                                                  ),
                                                ),
                                                // Container(
                                                //   width: 30.w,
                                                //   height: 6.h,
                                                //   decoration: BoxDecoration(
                                                //     border: Border.all(color: Colors.grey),
                                                //     borderRadius: BorderRadius.circular(20),
                                                //   ),
                                                //   child: DropdownButtonHideUnderline(
                                                //     child: DropdownButtonFormField(
                                                //       decoration: const InputDecoration(
                                                //         contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                                //         border: InputBorder.none,
                                                //       ),
                                                //       items: homeController.chartDropDownList.map((label) {
                                                //         return DropdownMenuItem(
                                                //           value: label,
                                                //           child: Text(
                                                //             label.toString(),
                                                //             style: TextStyle(
                                                //               color: Colors.black,
                                                //               fontSize: 10.sp,
                                                //               fontFamily: 'Aileron',
                                                //               fontWeight: FontWeight.w400,
                                                //             ),
                                                //           ),
                                                //         );
                                                //       }).toList(),
                                                //       onChanged: (selectChartType) => homeScreenController
                                                //           .changeChartDropDownSelectVal(selectChartType.toString()),
                                                //       value: homeController.chartDropDownList.first,
                                                //     ),
                                                //   ),
                                                // ),
                                                // Dropdown removed for brevity
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(16),
                                                          ),
                                                          elevation: 8,
                                                          backgroundColor: Colors.white,
                                                          title: Text(
                                                            'Offer Statistics',
                                                            style: GoogleFonts.workSans(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black87,
                                                            ),
                                                          ),
                                                          content: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  const CircleAvatar(
                                                                    backgroundColor: Colors.green,
                                                                    radius: 10,
                                                                  ),
                                                                  const SizedBox(width: 10),
                                                                  Text(
                                                                    'Live Offers: ${homeController.liveCount}',
                                                                    style: GoogleFonts.workSans(
                                                                      fontSize: 14,
                                                                      color: Colors.black87,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 12),
                                                              Row(
                                                                children: [
                                                                  const CircleAvatar(
                                                                    backgroundColor: Color(0xFF00BADD),
                                                                    radius: 10,
                                                                  ),
                                                                  const SizedBox(width: 10),
                                                                  Text(
                                                                    'Available Offers: ${localSeller.offerCount}',
                                                                    style: GoogleFonts.workSans(
                                                                      fontSize: 14,
                                                                      color: Colors.black87,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 12),
                                                              Row(
                                                                children: [
                                                                  const CircleAvatar(
                                                                    backgroundColor: Colors.purple,
                                                                    radius: 10,
                                                                  ),
                                                                  const SizedBox(width: 10),
                                                                  Text(
                                                                    'Expired Offers: ${homeController.expiredCount}',
                                                                    style: GoogleFonts.workSans(
                                                                      fontSize: 14,
                                                                      color: Colors.black87,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 12),
                                                              Row(
                                                                children: [
                                                                  const CircleAvatar(
                                                                    backgroundColor: Colors.yellow,
                                                                    radius: 10,
                                                                  ),
                                                                  const SizedBox(width: 10),
                                                                  Text(
                                                                    'Total Redeemed: ${homeController.totalEncashCount}',
                                                                    style: GoogleFonts.workSans(
                                                                      fontSize: 14,
                                                                      color: Colors.black87,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text(
                                                                'OK',
                                                                style: GoogleFonts.workSans(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.blue,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      PieChart(
                                                        dataMap: homeController.pieChartData,
                                                        animationDuration: const Duration(milliseconds: 800),
                                                        chartRadius: MediaQuery.of(context).size.width / 2.5,
                                                        colorList: const [
                                                          Colors.green,
                                                          Color(0xFF00BADD),
                                                          Colors.purple,
                                                          Colors.yellow,
                                                        ],
                                                        chartType: ChartType.ring,
                                                        ringStrokeWidth: 25,
                                                        legendOptions: const LegendOptions(
                                                          showLegends: true,
                                                          legendPosition: LegendPosition.right,
                                                          legendShape: BoxShape.circle,
                                                          legendTextStyle: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        chartValuesOptions: ChartValuesOptions(
                                                          showChartValues: false,
                                                          showChartValueBackground: false,
                                                          chartValueStyle: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            height: 1.2,
                                                            textBaseline: TextBaseline.alphabetic,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    // Center(
                                    //   child: IconButton(
                                    //     icon: const Icon(Icons.qr_code_scanner), // Use a QR scan icon
                                    //     iconSize: 100, // You can adjust the size of the icon
                                    //     color: Colors.black, // Icon color
                                    //     onPressed: () {
                                    //       // Navigate to your QR scan screen or trigger the QR scan functionality here
                                    //       Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //           builder: (context) => const HomeScreen1(), // Replace this with your QR scan screen or functionality
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                    // SizedBox(height: 2.h,),
                                    // Center(
                                    //   child: ElevatedButton(
                                    //     onPressed: () {
                                    //       // Show a loading screen while you prepare the account details.
                                    //       showDialog(
                                    //         context: context,
                                    //         barrierDismissible: false,
                                    //         builder: (context) {
                                    //           return const Center(
                                    //             child: CircularProgressIndicator(), // You can customize the loading screen as needed.
                                    //           );
                                    //         },
                                    //       );
                                    //       // Simulate loading account details for 2 seconds (you can replace this with actual data loading).
                                    //       Future.delayed(const Duration(seconds: 2), () {
                                    //         // Pop the loading screen.
                                    //         Navigator.pop(context);
                                    //         // Navigate to the account screen.
                                    //         Navigator.push(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //             builder: (context) =>  const AccountScreen(), // Replace 'AccountScreen()' with your actual account screen widget.
                                    //           ),
                                    //         );
                                    //       });
                                    //     },
                                    //     style: ElevatedButton.styleFrom(
                                    //       foregroundColor: Colors.white, backgroundColor: Colors.black,
                                    //       fixedSize: const Size(320, 50),
                                    //       shape: RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.circular(10),
                                    //       ),
                                    //     ),
                                    //     child: const Text('View Account Details'),
                                    //   ),
                                    // ),

                                    //   Center(
                                    //   child: Column(
                                    //     mainAxisSize: MainAxisSize.min,
                                    //     children: [
                                    //       Text(
                                    //         'Take Actions',
                                    //         style: GoogleFonts.workSans(
                                    //           color: Colors.black,
                                    //           fontSize: 12.sp,
                                    //           fontWeight: FontWeight.w700,
                                    //         ),
                                    //       ),
                                    //       Container(
                                    //         width: 80, // adjust underline width as needed
                                    //         height: 2, // underline thickness
                                    //         color: Colors.black, // underline color
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Center(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              buildCard(
                                                  context,
                                                  "Offer Details",
                                                  "View Results",
                                                  const ActiveOfferScreen(),
                                                  Icons.description),
                                              buildCard(
                                                  context,
                                                  "View Previous Offers",
                                                  "View Offers",
                                                  const OfferUploadHistory(),
                                                  Icons.card_membership),
                                            ],
                                          ),
                                          SizedBox(height: 2.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              buildCard(
                                                  context,
                                                  "Payment",
                                                  "Plans & Subscription",
                                                  const RechargePaymentScreen(),
                                                  Icons.payment),
                                              buildCard(
                                                  context,
                                                  "Transaction",
                                                  "View Passbook",
                                                  const PassbookScreen(),
                                                  Icons.account_balance),
                                            ],
                                          ),
                                          SizedBox(height: 2.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              buildCard(
                                                  context,
                                                  "Offers Performance",
                                                  "Want to see ?",
                                                  const RedeemedOffersScreen(),
                                                  Icons.redeem),
                                              buildCard(
                                                  context,
                                                  "Refer and Earn",
                                                  "Refer Program",
                                                  const ShareRefer(),
                                                  Icons.person_add),
                                            ],
                                          ),
                                          SizedBox(height: 3.h),
                                        ],
                                      ),
                                    )

                                    // SizedBox(
                                    //   width: 90.w,
                                    //   child: ElevatedButton(
                                    //     style: ElevatedButton.styleFrom(
                                    //       foregroundColor: Colors.black,
                                    //       backgroundColor: Colors.yellow[800],
                                    //       padding: const EdgeInsets.symmetric(
                                    //           vertical: 10, horizontal: 10),
                                    //     ),
                                    //     onPressed: () async {
                                    //       bottomNavController.changeSelectedIndex(1);
                                    //     },
                                    //     child: const Text(
                                    //       'CREATE NEW OFFER',
                                    //       style: TextStyle(fontSize: 16.0),
                                    //     ),
                                    //   ),
                                    // ),
                                    // const SizedBox(height: 10),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    //   children: [
                                    //     Text(
                                    //       homeController.showManageOffers
                                    //           ? 'Hide Manage offers'
                                    //           : 'Show Manage offers',
                                    //       textScaleFactor: 1.3,
                                    //     ),
                                    //     Switch(
                                    //       activeColor: Colors.blue.shade900,
                                    //       value: homeController.showManageOffers,
                                    //       onChanged: (showManageOffers) => homeController
                                    //           .updateManageOffers(showManageOffers),
                                    //     )
                                    //   ],
                                    // ),
                                    //    AnimatedSwitcher(
                                    //    duration: const Duration(seconds: 1),
                                    //   child: homeController.showManageOffers
                                    //     ? ManageScreen(
                                    //         homeController: homeController,
                                    //         widthFactor: widthFactor)
                                    //    : Center(
                                    //        child: Column(
                                    //         children: [
                                    //            InkWell(
                                    //            onTap: homeController.showScanQRView,
                                    //           child: Container(
                                    //             height: 15.h,
                                    //            margin: EdgeInsets.only(top: 3.h),
                                    //           child: const Image(
                                    //            image: AssetImage(
                                    //                 'lib/Images/qr-code.png'),
                                    //           ),
                                    //        ),
                                    //       ),
                                    //       const Text(
                                    //         'Scan Customer QR\n To Accept offers',
                                    //        textScaleFactor: 1.0,
                                    //        style: TextStyle(color: Colors.black),
                                    //      )
                                    //         ],
                                    //        ),
                                    //         ),
                                    //    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget buildCard(BuildContext context, String title, String subtitle,
    Widget route, IconData iconData) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => route),
      );
    },
    child: Container(
      width: 160,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all( // added border here
          color: Colors.black,
          width: 0.5, // you can adjust width as needed
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 15,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular background for icon
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0x3FC2FF3D),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                iconData,
                size: 35,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style:   GoogleFonts.workSans(
              color: Colors.black,
              fontSize: 14,
               fontWeight: FontWeight.w700,
              letterSpacing: 0.02,
            ),
          ),

          // Subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style:   GoogleFonts.workSans(
              color: Colors.black54,
              fontSize: 10,
               fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildCardWithActiveButton(
    OfferHistoryColl offer, BuildContext context) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(
                      "Loading Offer Details",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Aileron',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.03,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OfferDetailsScreen(offerID: offer.offerID),
          ),
        );
      });
    },
    child: Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // Adjust as needed
        height: MediaQuery.of(context).size.height * 0.25,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 0.2), // ✅ Added black border
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.30,
                  height: MediaQuery.of(context).size.width * 0.30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    image: DecorationImage(
                      image: offer.offerImages.isNotEmpty &&
                          offer.offerImages[0].isNotEmpty
                          ? NetworkImage(offer.offerImages[0])
                          : const AssetImage('lib/Images/stores.png')
                      as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'NOW TRENDING',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontFamily: 'Aileron',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          offer.offerName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Aileron',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '(${offer.discountNo}% OFF)',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Aileron',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          offer.offerDescription,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 23.w,
                              height: 4.h,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black, // Text color
                                  side: const BorderSide(color: Colors.black, width: 1), // Border color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OfferDetailsScreen(offerID: offer.offerID),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'VIEW OFFER',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Explicitly set text color
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 23.w,
                              height: 4.h,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(color: Colors.black),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  _showEditOfferDialog(context, offer);
                                },
                                child: const Text(
                                  'EDIT OFFER',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: offer.offerStatus == OfferStatus.live
                      ? const Color(0xFFB4FFB2)
                      : const Color(0xFFFFB2B2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  offer.offerStatus == OfferStatus.live ? "Active" : "Review",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Aileron',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.01,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showEditOfferDialog(BuildContext context, OfferHistoryColl offer) {
  showDialog(
    context: context,
    builder: (context) {
      String? selectedStatus;

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Edit Offer Status',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: DropdownButton<String>(
                      hint: const Text('Select Offer Status'),
                      value: selectedStatus,
                      items: ['Out of Stock'].map((status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(
                            status,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                      isExpanded: true,
                      underline: Container(),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          // Call the endOffer method with the updated status
                          homeScreenController.endOffer(
                              offer, selectedStatus, null);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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

offerImagesList(List<XFile> images) {
  return Center(
    child: SizedBox(
      height: 50.h,
      width: 70.w,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 70.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(images[index].path),
                fit:
                    BoxFit.cover, // or BoxFit.fitWidth based on your preference
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const VerticalDivider(
          color: Colors.transparent,
        ),
      ),
    ),
  );
}





