import 'package:candid_vendors/Controllers/Profile/VendorOutletController/EditVendorOutletController.dart';
import 'package:candid_vendors/Services/Collections/User/VendorUserColl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';

import '../../../Services/Collections/State/StateColl.dart';
import '../../../main.dart';

class EditVendorOutletScreen extends StatelessWidget {
  final Outlet outlet;

  const EditVendorOutletScreen({super.key, required this.outlet});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditVendorOutletController(outlet: outlet),
      builder: (controller) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Outlet'),
            ),
            body: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 90.w,
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: Text(
                                    'Seller ID:\n${controller.vendor.userId}',
                                    textScaleFactor: 1.5,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.bold)),
                              ),
                              FittedBox(
                                child: Text(
                                    'Seller Name:\n${controller.vendor.userFullName}',
                                    textScaleFactor: 1.3,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.bold)),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(seconds: 1),
                                child: controller.cityList.isEmpty
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Column(
                                        children: [
                                          DropdownButtonFormField(
                                            icon: const Icon(
                                                Icons.arrow_downward_rounded),
                                            decoration: const InputDecoration(
                                              filled: true,
                                              border: OutlineInputBorder(),
                                              fillColor: Colors.transparent,
                                              labelText: 'Select City',
                                            ),
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: Colors.deepPurple),
                                            hint: const Text('Select City'),
                                            items: controller.cityList
                                                .map<DropdownMenuItem<String>>(
                                                    (String city) {
                                              return DropdownMenuItem<String>(
                                                value: city,
                                                child: Text(city,
                                                    style: const TextStyle(
                                                        color: Colors.black)),
                                              );
                                            }).toList(),
                                            value: controller.selectedCity,
                                            onChanged: (value) => controller
                                                .changeSelectedCity(value!),
                                          ),
                                          Text(
                                              "We're available in above cities only, others are coming soon!",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.blue.shade900)),
                                        ],
                                      ),
                              ),
                              StreamBuilder(
                                stream: isar.stateColls
                                    .where()
                                    .build()
                                    .watch(fireImmediately: true),
                                builder: (context, snapshot) {
                                  List<StateColl> stateList = [];
                                  if (snapshot.hasError) {
                                    return const Text(
                                        'Error or not having data to show!');
                                  }
                                  if (snapshot.hasData) {
                                    stateList =
                                        snapshot.data as List<StateColl>;
                                  }
                                  return AnimatedSwitcher(
                                    duration: const Duration(seconds: 1),
                                    child: stateList.isEmpty
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : DropdownButtonFormField(
                                            icon: const Icon(
                                                Icons.arrow_downward_rounded),
                                            decoration: const InputDecoration(
                                                filled: true,
                                                border: OutlineInputBorder(),
                                                fillColor: Colors.transparent,
                                                labelText: 'Select State',
                                                hintText: 'Select State'),
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: Colors.deepPurple),
                                            hint: const Text('Select State'),
                                            items: stateList
                                                .map<DropdownMenuItem<String>>(
                                                    (StateColl state) {
                                              return DropdownMenuItem<String>(
                                                value: state.stateName,
                                                child: Text(state.stateName,
                                                    style: const TextStyle(
                                                        color: Colors.black)),
                                              );
                                            }).toList(),
                                            value: controller.selectedState,
                                            onChanged: (value) => controller
                                                .changeSelectedState(value!),
                                          ),
                                  );
                                },
                              ),
                              TextFormField(
                                controller: controller.pinCodeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 12),
                                    labelText: 'Pin code',
                                    hintText: 'Pin code'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the pin';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: controller.addressController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    labelText: 'Address',
                                    hintText: 'Address'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the Address';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: controller.address2Controller,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    labelText: 'Address Line 2',
                                    hintText: 'Address Line 2'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the Address Line 2';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: controller
                                    .addressBuildingStreetAreaController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  labelText: 'Address building, street, area',
                                  hintText: 'Address building, street, area',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the Address Line 2';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 30.h,
                                width: 90.w,
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  buildingsEnabled: true,
                                  myLocationEnabled: true,
                                  initialCameraPosition: controller.kOutlet,
                                  onTap: controller.onGoogleMapTap,
                                  markers: <Marker>{
                                    Marker(
                                      markerId: const MarkerId("My outlet"),
                                      position: controller.center,
                                      // icon: BitmapDescriptor.,
                                      infoWindow: InfoWindow(
                                        title: 'Outlet Address',
                                        snippet: outlet.userOutletAddress1,
                                      ),
                                    ),
                                  },
                                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                                    Factory<OneSequenceGestureRecognizer>(
                                          () => EagerGestureRecognizer(),
                                    ),
                                  },
                                  onMapCreated: (GoogleMapController myMapController) {
                                    try {
                                      controller.googleMapController.complete(myMapController);
                                    } catch (e) {
                                      debugPrint('controller.googleMapController catch | $e');
                                    }
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed:
                                          controller.saveOutletClickHandler,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade900,
                                      ),
                                      child: const Text(
                                        'Save',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]
                                .map((e) => Padding(
                                      padding: EdgeInsets.only(top: 3.h),
                                      child: e,
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: controller.goToTheOutlet,
              label: const Text('To the Outlet!'),
              elevation: 16,
              icon: const Icon(Icons.location_on_outlined),
              backgroundColor: Colors.blue.shade900.withOpacity(0.5),
              foregroundColor: Colors.white,
            ));
      },
    );
  }
}
