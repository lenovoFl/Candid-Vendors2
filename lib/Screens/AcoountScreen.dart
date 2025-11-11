import 'package:candid_vendors/Controllers/Account/AccountController.dart';
import 'package:candid_vendors/Services/Collections/Account/AccountData.dart';
import 'package:candid_vendors/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';
import '../Services/Collections/Offers/OfferHistory/OfferHistoryColl.dart';

Color customColor = const Color(0xFFFF0000).withOpacity(0.5);

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  OfferHistoryColl? offerData;
  String selectedFrequency = "Weekly";
  String selectedOption1 = "";
  String selectedOption2 = "";
  AccountController accountController = AccountController();
  late Future<AccountColl?> accountFuture;

  @override
  void initState() {
    super.initState();
    // Fetch account data when the screen initializes
    accountFuture = AccountController.fetchAccountData(1);
    // fetchOfferData(); // Fetch offer data
  }

  // void fetchOfferData() async {
  //   // Fetch your offer data here and set it to offerData
  //   // For example:
  //   offerData = await AccountController.fetchOfferData(1);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Your Account Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Aileron',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.03,
          ),
        ),
      ),
        body: ListView(
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: 90.w,
                  height: 60.h,
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Performance",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const InteractiveChart(), // Add your code for the InteractiveChart widget
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // StreamBuilder<List<OfferHistoryColl>>(
              //   stream: isar.offerHistoryColls
              //       .where()
              //       .offerIDIsNotEmpty()
              //       .build()
              //       .watch(fireImmediately: true),
              //   builder: (context, snapshot) {
              //     debugPrint('Isar Snapshot: $snapshot'); // Debugging line
              //
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator(); // Loading indicator
              //     }
              //     if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              //       return Text('No offer history available');
              //     }
              //     List<OfferHistoryColl> offers = snapshot.data!;
              //     final offerID = offers.first.offerID; // Get the first offer ID
              //     debugPrint('Offer ID: $offerID'); // Debugging line
              //     return Center(
              //       child: SizedBox(
              //         height: 35.h,
              //         width: 90.0.w,
              //         child: Card(
              //           elevation: 2,
              //           color: Colors.white,
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(12),
              //           ),
              //           child: Padding(
              //             padding: EdgeInsets.all(16),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text(
              //                   'Redeem Overview',
              //                   style: TextStyle(
              //                     color: Colors.black,
              //                     fontSize: 18,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //                 SizedBox(height: 8),
              //                 Text(
              //                   'How many people have used your offer',
              //                   style: TextStyle(
              //                     color: Colors.black,
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //                 SizedBox(height: 16),
              //                 StreamBuilder<QuerySnapshot>(
              //                   stream: FirebaseFirestore.instance
              //                       .collection('availedOffers')
              //                       .where('offerID', isEqualTo: offerID)
              //                       .snapshots(),
              //                   builder: (context, snapshot) {
              //                     if (snapshot.connectionState == ConnectionState.waiting) {
              //                       return CircularProgressIndicator();
              //                     }
              //
              //                     if (snapshot.hasError) {
              //                       debugPrint('Firestore error: ${snapshot.error}');
              //                       return Text('Error fetching data');
              //                     }
              //
              //                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              //                       debugPrint('No documents found for Offer ID: $offerID');
              //                       return Text('No offers redeemed for this ID');
              //                     }
              //
              //                     int redeemedCount = snapshot.data!.docs.length;
              //
              //                     debugPrint('Redeemed Count: $redeemedCount'); // Debugging line
              //
              //                     return Column(
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: [
              //                         Text(
              //                           'Redeemed',
              //                           style: TextStyle(
              //                             color: Colors.black,
              //                             fontSize: 14,
              //                             fontWeight: FontWeight.bold,
              //                           ),
              //                         ),
              //                         Text(
              //                           '$redeemedCount',
              //                           style: TextStyle(
              //                             color: Colors.black,
              //                             fontSize: 18,
              //                             fontWeight: FontWeight.bold,
              //                           ),
              //                         ),
              //                       ],
              //                     );
              //                   },
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // ),
              SizedBox(height: 2.h),
              StreamBuilder<List<OfferHistoryColl>>(
                stream: isar.offerHistoryColls
                    .where()
                    .offerIDIsNotEmpty()
                    .build()
                    .watch(fireImmediately: true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No offer history available'));
                  }
                  List<OfferHistoryColl> offers = snapshot.data!;

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 40.h, minWidth: 90.0.w),
                      child: Card(
                        elevation: 2,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0.sp),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Redeem Overview',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontFamily: 'Aileron',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.sp),
                              Text(
                                'How many people have used your offer',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12.sp,
                                  fontFamily: 'Aileron',
                                ),
                              ),
                              SizedBox(height: 16.sp),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('availedOffers')
                                    .where('offerID', whereIn: offers.map((e) => e.offerID).toList())
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                    return const Text("No offers available");
                                  }

                                  var offerDocs = snapshot.data!.docs;
                                  var totalRedeemed = offerDocs.length;
                                  var maxLimit = 100; // You might want to get this from your data
                                  var percentage = (totalRedeemed / maxLimit * 100).round();

                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 120,
                                            height: 120,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  width: 110,
                                                  height: 110,
                                                  decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 120,
                                                  height: 120,
                                                  child: CircularProgressIndicator(
                                                    value: totalRedeemed / maxLimit,
                                                    strokeWidth: 20,
                                                    backgroundColor: Colors.pink[100],
                                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                                                  ),
                                                ),
                                                Text(
                                                  '$percentage%',
                                                  style: TextStyle(
                                                    fontSize: 28.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 16.sp),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Max Limit',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 14.sp,
                                                        fontFamily: 'Aileron',
                                                      ),
                                                    ),
                                                    Text(
                                                      'Redeemed',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 14.sp,
                                                        fontFamily: 'Aileron',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 4.sp),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      '$maxLimit',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.sp,
                                                        fontFamily: 'Aileron',
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      '$totalRedeemed',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.sp,
                                                        fontFamily: 'Aileron',
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6.h),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('availedOffers')
                                            .where('offerID', whereIn: offers.map((e) => e.offerID).toList())
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          }

                                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                            return const Text("No offers available");
                                          }

                                          var offerDocs = snapshot.data!.docs;
                                          var offerList = <String, int>{};

                                          for (var doc in offerDocs) {
                                            var offerName = doc['offerName'];
                                            if (offerList.containsKey(offerName)) {
                                              offerList[offerName] = offerList[offerName]! + 1;
                                            } else {
                                              offerList[offerName] = 1;
                                            }
                                          }
                                          return ExpansionTile(
                                            title: Text(
                                              'Offers (${offerList.length})',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontFamily: 'Aileron',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            children: offerList.entries.map((entry) {
                                              return ListTile(
                                                title: Text(
                                                  'Offer Name : ${entry.key}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.sp,
                                                    fontFamily: 'Aileron',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  ' Redeemed Count: ${entry.value}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.sp,
                                                    fontFamily: 'Aileron',
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 2.h,),
            ]
        )
    );
  }
}

Widget buildCard(BuildContext context, String title, String subtitle,
    Widget route,IconData iconData) {
  return GestureDetector(
    onTap: () {
      // Navigate to the specified screen when the card is tapped.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => route),
      );
    },
    child: SizedBox(
      width: 160,
      height: 180,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 160,
              height: 180,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 15,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 37,
            top: 110,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Aileron',
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: 0.02,
              ),
            ),
          ),
          Positioned(
            left: 51,
            top: 139,
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFA6A6A6),
                fontSize: 10,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
          const Positioned(
            left: 56.55,
            top: 20.40,
            child: SizedBox(width: 47.15, height: 47.15),
          ),
          Positioned(
            left: 47,
            top: 25,
            child: Container(
              width: 70,
              height: 70,
              decoration: const ShapeDecoration(
                color: Color(0x3FC2FF3D),
                shape: CircleBorder(),
              ),
            ),
          ),
          Positioned(
            left: 64, // Adjust the left position to center the icon
            top: 40, // Adjust the top position to center the icon
            child: Icon(
              iconData,
              size: 35, // Adjust the size of the icon
              color: Colors.black, // Change the icon color as needed
            ),
          ),
        ],
      ),
    ),
  );
}



class InteractiveChart extends StatefulWidget {
  const InteractiveChart({Key? key}) : super(key: key);

  @override
  _InteractiveChartState createState() => _InteractiveChartState();
}

class _InteractiveChartState extends State<InteractiveChart> {
  late List<_ChartData> data = [];
  String selectedPeriod = 'Weekly';
  _ChartData? selectedDataPoint;

  @override
  void initState() {
    super.initState();
    // Initialize the data with an initial point
    data = [
      _ChartData(x: 'Sun', y: 0),
      _ChartData(x: 'Mon', y: 0),
      _ChartData(x: 'Tue', y: 0),
      _ChartData(x: 'Wed', y: 0),
      _ChartData(x: 'Thu', y: 0),
      _ChartData(x: 'Fri', y: 0),
      _ChartData(x: 'Sat', y: 0),
    ];

    // Listen to changes in Isar to get all offerIDs
    isar.offerHistoryColls
        .where()
        .offerIDIsNotEmpty()
        .build()
        .watch(fireImmediately: true)
        .listen((offers) {
      if (offers.isNotEmpty) {
        _fetchRedeemedCounts(offers);
      }
    });
  }
  void _fetchRedeemedCounts(List<OfferHistoryColl> offers) {
    // Clear previous data
    if (mounted) {
      setState(() {
        data.clear();
        data.add(_ChartData(x: 'Initial', y: 0));
      });
    }

    // Fetch redeemed counts for each offerID
    for (var offer in offers) {
      FirebaseFirestore.instance
          .collection('availedOffers')
          .where('offerID', whereIn: offers.map((e) => e.offerID).toList())
          .get()
          .then((snapshot) {
        if (mounted) {  // Check if the widget is still in the tree
          setState(() {
            // Calculate total redeemed count
            var totalRedeemedCount = snapshot.docs.length.toDouble();

            // Only add data if there's a count greater than 0
            if (totalRedeemedCount > 0) {
              data.add(_ChartData(x: '', y: totalRedeemedCount)); // Empty x value
            }
          });
        }
      }).catchError((error) {
        print('Error fetching data for Offer ID: ${offer.offerID} - $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Container(
        //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        //       decoration: BoxDecoration(
        //         color: Colors.grey[200],
        //         borderRadius: BorderRadius.circular(20),
        //       ),
        //       child: DropdownButton<String>(
        //         value: selectedPeriod,
        //         onChanged: (String? newValue) {
        //           setState(() {
        //             selectedPeriod = newValue!;
        //           });
        //         },
        //         items: <String>['Weekly', 'Monthly', 'Yearly']
        //             .map<DropdownMenuItem<String>>((String value) {
        //           return DropdownMenuItem<String>(
        //             value: value,
        //             child: Text(value),
        //           );
        //         }).toList(),
        //         underline: const SizedBox(),
        //       ),
        //     ),
        //   ],
        // ),
        const SizedBox(height: 20),
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 100,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false, // Hide bottom titles
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 100,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    reservedSize: 40,
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: data.length.toDouble() - 1,
              minY: 0,
              maxY: 500,
              lineBarsData: [
                LineChartBarData(
                  spots: data.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.y);
                  }).toList(),
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: true),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((barSpot) {
                      final flSpot = barSpot;
                      return LineTooltipItem(
                        '${data[flSpot.x.toInt()].x} ${flSpot.y.toInt()} redeemed',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          backgroundColor: Colors.transparent, // Tooltip background color
                        ),
                      );
                    }).toList();
                  },
                ),
                handleBuiltInTouches: true,
              ),
            ),
          ),
        ),
      ],

          );
          // const SizedBox(height: 20),


  }
}

class _ChartData {
  final String x;
  final double y;

  _ChartData({required this.x, required this.y});
}

// Center(
//   child: SizedBox(
//     height: 32.h,
//     width: 90.w,
//     child: Card(
//       elevation: 1, // Customize the elevation if needed
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(
//             12), // Customize the border radius if needed
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment:
//               MainAxisAlignment.spaceAround,
//               children: [
//                 Text(
//                   'Offers Chart',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 18.sp,
//                     fontFamily: 'Aileron',
//                     fontWeight: FontWeight.w700,
//                     height: 0,
//                     letterSpacing: 0.03,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 33.w,
//                   height: 7.h,
//                   // Adjust the width to make the dropdown smaller
//                   child: DropdownButtonFormField(
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                             Radius.circular(40)),
//                       ),
//                       labelText: 'Select Type',
//                       hintText: 'Select Type',
//                     ),
//                     items: homeScreenController
//                         .chartDropDownList
//                         .map((label) {
//                       return DropdownMenuItem(
//                         value: label,
//                         child: Text(
//                           label.toString(),
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 10.sp,
//                             fontFamily: 'Aileron',
//                             fontWeight: FontWeight.w400,
//                             height: 0,
//                             letterSpacing: -0.12,
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (selectChartType) =>
//                         homeScreenController
//                             .changeChartDropDownSelectVal(
//                             selectChartType
//                                 .toString()),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: PieChart(
//                 dataMap: homeScreenController.pieChartData,
//                 animationDuration:
//                 const Duration(milliseconds: 800),
//                 chartLegendSpacing: 32,
//                 chartRadius:
//                 MediaQuery.of(context).size.width /
//                     3.8,
//                 colorList: const [
//                   Colors.blue,
//                   Colors.green,
//                   Colors.red,
//                   Colors.orange,
//                 ],
//                 chartType: ChartType.disc,
//                 ringStrokeWidth: 32,
//                 legendOptions: const PieChartPackage.LegendOptions(
//                   showLegends: true,
//                   legendPosition: PieChartPackage.LegendPosition.right,
//                   legendShape: BoxShape.circle,
//                   legendTextStyle: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 chartValuesOptions:
//                 const ChartValuesOptions(
//                   showChartValueBackground: true,
//                   chartValueBackgroundColor:
//                   Colors.transparent,
//                   chartValueStyle: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   ),
// ),
// SizedBox(height: 2.h,),
// const Center(
//   child: Text(
//     'Take Actions',
//     style: TextStyle(
//       color: Colors.black,
//       fontSize: 14,
//       fontFamily: 'Aileron',
//       fontWeight: FontWeight.bold,
//       height: 0,
//       letterSpacing: 0.02,
//     ),
//   ),
// ),
// SizedBox(height: 2.h,),
// Center(
//   child: Column(
//     children: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           buildCard(context, "Active Offers", "View Results", const ActiveOfferScreen(),Icons.home),
//           buildCard(context, "Offer Archive", "View Offer", const OfferUploadHistory(),Icons.archive),
//         ],
//       ),
//       SizedBox(height: 2.h,),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Center(child: buildCard(context, "     Payment", "Account Setup", const RechargePaymentScreen(),Icons.payment)),
//           buildCard(context, "   Transaction", "View Passbook",  const PassbookScreen(),Icons.account_balance),
//         ],
//       ),
//       SizedBox(height: 2.h,),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           buildCard(context, "Help and Tutorial", "Knowledge Center", const HelpAndTutorialsScreen(),Icons.help),
//           buildCard(context, "Refer and Earn", "Refer Program", const ShareRefer(),Icons.person_add),
//         ],
//       ),
//     ],
//   ),
// ),
// SizedBox(height: 5.h,),
// Container(
//   width: 30.w,
//   height: 5.h,
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(20.sp),
//     border: Border.all(
//       color: Colors.black,
//       width: 1.sp,
//     ),
//   ),
//   child: Center(
//     child: DropdownButton<String>(
//       items: ["Weekly", "Monthly", "Yearly"]
//           .map((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//       onChanged: (String? newValue) {
//         setState(() {
//           selectedFrequency = newValue!;
//         });
//       },
//       value: selectedFrequency,
//       underline: Container(),
//       icon: const Icon(Icons.arrow_drop_down),
//       iconSize: 24,
//     ),
//   ),
// )
// Center(
//   child: SizedBox(
//     height: 36.h,
//     width: 90.w,
//     child: Card(
//       elevation: 2,
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: FutureBuilder<AccountColl?>(
//         future: AccountController.fetchAccountData(1), // Fetch data from your collection
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             final accountData = snapshot.data!;
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Row(
//                     children: [
//                       Icon(Icons.thumb_up, color: Colors.blue),
//                       Text(
//                         'Likes',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 14,
//                           fontFamily: 'Aileron',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Spacer(),
//                       Icon(Icons.favorite, color: Colors.red),
//                       Text(
//                         'Saves',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 14,
//                           fontFamily: 'Aileron',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Spacer(),
//                       Icon(Icons.line_axis, color: Colors.greenAccent),
//                       Text(
//                         'Reach',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 14,
//                           fontFamily: 'Aileron',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     children: [
//                       Text(
//                         accountData.Likes,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 25,
//                           fontFamily: 'Aileron',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       Text(
//                         accountData.Saves,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 25,
//                           fontFamily: 'Aileron',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       Text(
//                         accountData.Reach,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 25,
//                           fontFamily: 'Aileron',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.yellow),
//                       Text(
//                         'Prime',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 14,
//                           fontFamily: 'Aileron',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Spacer(),
//                       Icon(Icons.share, color: Colors.black),
//                       Text(
//                         'Shares',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 14,
//                           fontFamily: 'Aileron',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Spacer(),
//                       Icon(Icons.remove_red_eye, color: Colors.black),
//                       Text(
//                         'Opened',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 14,
//                           fontFamily: 'Aileron',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     children: [
//                       Text(
//                         accountData.Prime,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 25,
//                           fontFamily: 'Aileron',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       Text(
//                         accountData.Saves,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 25,
//                           fontFamily: 'Aileron',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       Text(
//                         accountData.Opened,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 25,
//                           fontFamily: 'Aileron',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return const Center(child: Text('No data available'));
//           }
//         },
//       ),
//     ),
//   ),
// ),
