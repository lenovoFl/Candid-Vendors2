import 'package:animations/animations.dart';
import 'package:candid_vendors/Controllers/Profile/VendorOutletController/VendorOutletsListController.dart';
import 'package:candid_vendors/Screens/Profile/OutletsScreen/AddVendorOutletScreen.dart';
import 'package:candid_vendors/Screens/Profile/OutletsScreen/EditVendorOutletScreen.dart';
import 'package:candid_vendors/Services/Collections/User/VendorUserColl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../main.dart';

class VendorOutletsListScreen extends StatelessWidget {
  final VendorUserColl vendor;

  const VendorOutletsListScreen({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outlets List'),
      ),
      body: GetBuilder(
        init: VendorOutletsListController(vendor: vendor),
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.vendor.myOutlets.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final outlet = controller.vendor.myOutlets[index];
                    return OpenContainer(
                      closedColor: Colors.white,
                      middleColor: Colors.blue.shade900,
                      openColor: Colors.white,
                      closedElevation: 10,
                      openElevation: 10,
                      transitionType: ContainerTransitionType.fadeThrough,
                      transitionDuration: const Duration(seconds: 1),
                      closedBuilder: (context, action) {
                        return Card(
                          elevation: 10,
                          shadowColor: Colors.blue.shade900,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('StoreName: ${outlet.storeName}'),
                                    Text('City: ${outlet.userOutletAddressCity}'),
                                    Text('State: ${outlet.userOutletAddressState}'),
                                    Text('Address: ${outlet.userOutletAddress1}'),
                                    Text('Address Line 2: ${outlet.userOutletAddress2}'),
                                  ],
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(seconds: 1),
                                child: controller.vendor.myOutlets.length > 1
                                    ? Card(
                                        elevation: 16,
                                        shadowColor: Colors.blue.shade900,
                                        child: IconButton(
                                          onPressed: () =>
                                              controller.deleteOutletClickHandler(
                                                  userOutletID: outlet.userOutletID),
                                          icon: const Icon(Icons.delete_forever_outlined),
                                        ),
                                      )
                                    : const SizedBox(),
                              )
                            ],
                          ),
                        );
                      },
                      openBuilder: (context, action) {
                        return EditVendorOutletScreen(outlet: outlet);
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                width: 80.w,
                child: Column(
                  children: [
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        utils.showSnackBar('Coming soon!');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                      ),
                      child: const Text(
                        'Track Sales',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        utils.showSnackBar('Coming soon!');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                      ),
                      child: const Text(
                        'Download All Data',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(
                builder: (BuildContext context) => const AddVendorOutletScreen()));
          },
          backgroundColor: Colors.blue.shade900.withOpacity(0.5),
          foregroundColor: Colors.white,
          elevation: 10,
          tooltip: 'Add Outlet',
          label: const Text('Add Outlet'),
          icon: const Icon(Icons.plus_one_outlined)),
    );
  }

// void downloadAllData(List<Map<String, dynamic>> dataList) async {
//   // Generate a file or API endpoint URL to download the data
//   const downloadUrl = 'https://example.com/download';
//
//   if (await canLaunch(downloadUrl)) {
//     await launch(downloadUrl);
//   } else {
//     throw 'Could not launch $downloadUrl';
//   }
// }
}
