import 'dart:async';

import 'package:candid_vendors/Services/APIs/City/CityConnect.dart';
import 'package:candid_vendors/Services/APIs/VendorOutlet/VendorOutletConnect.dart';
import 'package:candid_vendors/Services/Collections/City/CityColl.dart';
import 'package:candid_vendors/Services/Collections/State/StateColl.dart';
import 'package:candid_vendors/main.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:isar/isar.dart';

import '../../../Services/Collections/User/VendorUserColl.dart';

class AddVendorOutletController extends GetxController {
  bool isLoading = true;
  bool showMap = false;
  final formKey = GlobalKey<FormState>();
  List<String> cityList = [];

  String selectedCity = '';
  String selectedState = '';
  String selectedCityOfStateID = '';

  final TextEditingController addressController = TextEditingController();
 // final TextEditingController storeNameController = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController addressBuildingStreetAreaController =
  TextEditingController();

  late VendorUserColl vendor;
  late LatLng center;
  late Completer<GoogleMapController> googleMapController =
  Completer<GoogleMapController>();
  CameraPosition? kGooglePlex;
  CameraPosition? kOutlet;

  @override
  Future<void> onInit() async {
    super.onInit();
    vendor = (await utils.getUser()) as VendorUserColl;

    await CityConnect.getCityListApi();
    var localCities = await isar.cityColls.where().build().findAll();
    for (var i = 0; i < localCities.length; i++) {
      if (i == 0) {
        var localState = await isar.stateColls
            .filter()
            .stateIDEqualTo(localCities[i].cityOfStateID)
            .build()
            .findFirst();
        selectedState = localState!.stateName;
      }
      cityList.add(localCities[i].cityName);
    }

    // Update with user input
  //  storeNameController.text = ''; // Set to an empty string or initial value
    addressController.text = ''; // Set to an empty string or initial value
    address2Controller.text = ''; // Set to an empty string or initial value
    addressBuildingStreetAreaController.text = ''; // Set to an empty string or initial value
    pinCodeController.text = ''; // Set to an empty string or initial value

    await changeSelectedCity(cityList.first);
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      center = LatLng(position.latitude, position.longitude);
      kGooglePlex = CameraPosition(
        target: center,
        zoom: 14.4746,
      );
      kOutlet = CameraPosition(target: center, zoom: 19.151926040649414);
      showMap = true;
    } catch (e) {
      debugPrint('Permission for location catch | $e');
      utils.showSnackBar(e.toString());
    }
    isLoading = false;
    update();
  }

  @override
  void dispose() {
   // storeNameController.dispose();
    addressController.dispose();
    address2Controller.dispose();
    addressBuildingStreetAreaController.dispose();
    pinCodeController.dispose();
    super.dispose();
  }

  Future<void> addVendorOutletWithLocation(LatLng latLng) async {
    try {
      await VendorOutletConnect().updateVendorOutletsApi(
        changeType: 'add', // Change this to 'update' if needed
        changedOutletCoordinates: {
         // 'userstoreName': storeNameController.text,
          'userOutletAddressBuildingStreetArea': addressBuildingStreetAreaController.text,
          'userOutletAddressPinCode': pinCodeController.text,
          'userOutletAddressCity': selectedCity,
          'userOutletAddress2': address2Controller.text,
          'userOutletAddress1': addressController.text,
          'lat': latLng.latitude,
          'long': latLng.longitude,
          'userOutletAddressState': selectedState,
        },
        vendor: vendor,
      );

      Get.back(result: true); // Navigation code
    } catch (e) {
      utils.showSnackBar('Error adding outlet: $e');
    }
  }

  addOutletClickHandler(LatLng latLng) async {
    if (!formKey.currentState!.validate()) {
      utils.showSnackBar('Write proper outlet details!');
      return;
    }
    isLoading = true;
    update();
    formKey.currentState?.reset();
    try {
      await addVendorOutletWithLocation(latLng); // Pass the tapped LatLng here
    } catch (e) {
      utils.showSnackBar('Error adding outlet: $e');
    } finally {
      isLoading = false;
      update();
    }
    try {
      if (showMap) {
        await addVendorOutletWithLocation(center);
      } else {
        String fullAddress =
            '${addressController.text.trim()},'
            ' ${address2Controller.text.trim()},'
            ' ${addressBuildingStreetAreaController.text.trim()}, '
            '${selectedCity.toString().trim()},'
            ' ${selectedState.toString().trim()},'
            ' ${pinCodeController.text.trim()}';
        List<Location> locations = await locationFromAddress(fullAddress);
        if (locations.isNotEmpty) {
          Location location = locations.first;
          await addVendorOutletWithLocation(
              LatLng(location.latitude, location.longitude));
        } else {
          throw Exception(
              "Location not found for the provided address");
        }
      }
    } catch (e) {
      // Handle the error appropriately, e.g., show an error message to the user
      utils.showSnackBar('Error adding outlet: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  onGoogleMapTap(LatLng latLng) {
    center = LatLng(latLng.latitude, latLng.longitude);
    kGooglePlex = CameraPosition(
      target: center,
      zoom: 14.4746,
    );
    kOutlet = CameraPosition(target: center, zoom: 19.151926040649414);
    update();
  }

  onReportClickHandler() {
    // Perform report functionality
    debugPrint('onReportClickHandler');
  }

  onCancelClickHandler() {
    formKey.currentState!.reset();
    Navigator.of(navigatorKey.currentContext!).pop();
  }

  changeSelectedState(String stateName) async {
    selectedState = stateName;
    var localState = await isar.stateColls
        .filter()
        .stateNameEqualTo(stateName)
        .findFirst();
    cityList.clear();
    for (var city in await isar.cityColls
        .filter()
        .cityOfStateIDEqualTo(localState!.stateID)
        .findAll()) {
      cityList.add(city.cityName);
    }
    selectedCity = cityList.first;
    selectedCityOfStateID = localState.stateID;
    update();
  }

  changeSelectedCity(String city) async {
    selectedCity = city;
    update();
  }
}