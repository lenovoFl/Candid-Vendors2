import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../Controllers/Profile/VendorOutletController/AddVendorOutletController.dart';

class StoreInformation extends StatelessWidget {
  const StoreInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Store Information',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Aileron',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.03,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GetBuilder(
        init: AddVendorOutletController(),
        builder: (controller) {
          return AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCard('Seller ID', controller.vendor.userId),
                    _buildCard('Seller Name', controller.vendor.userFullName),
                    _buildCard('Store Name', controller.vendor.userBusinessName),
                  //  _buildCard('Selected City', ),
                    _buildCard('Selected State', controller.selectedState ?? "Select State"),
                    _buildCard('Pin code', controller.vendor.myOutlets.last.userOutletAddressPinCode),
                    _buildCard('Address', controller.vendor.myOutlets.last.userOutletAddress1),
                    _buildCard('Address Line 2', controller.vendor.myOutlets.last.userOutletAddress2),
                    _buildCard('Address building, street, area', controller.vendor.myOutlets.last.userOutletAddressBuildingStreetArea),
                    AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: !controller.showMap
                          ? const SizedBox()
                          : SizedBox(
                        height: 30.h,
                        width: 90.w,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          buildingsEnabled: true,
                          myLocationEnabled: true,
                          onTap: controller.onGoogleMapTap,
                          initialCameraPosition: controller.kGooglePlex!,
                          markers: <Marker>{
                            Marker(
                              markerId: const MarkerId("My outlet"),
                              position: controller.center,
                              infoWindow: const InfoWindow(
                                title: 'Outlet Address',
                              ),
                            ),
                          },
                          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                            Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer(),
                            ),
                          },
                          onMapCreated: (GoogleMapController myGoogleMapController) {
                            controller.googleMapController.complete(myGoogleMapController);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )  );
        },
      ),
    );
  }

  Widget _buildCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
