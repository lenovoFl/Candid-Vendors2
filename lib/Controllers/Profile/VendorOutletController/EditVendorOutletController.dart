import 'dart:async';

import 'package:candid_vendors/Services/APIs/VendorOutlet/VendorOutletConnect.dart';
import 'package:candid_vendors/Services/Collections/City/CityColl.dart';
import 'package:candid_vendors/Services/Collections/State/StateColl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:isar/isar.dart';

import '../../../Services/Collections/User/VendorUserColl.dart';
import '../../../main.dart';

class EditVendorOutletController extends GetxController {
  final Outlet outlet;

  EditVendorOutletController({required this.outlet});

  bool isLoading = true;
  final formKey = GlobalKey<FormState>();
  List<String> cityList = [];

  String selectedCity = '', selectedState = '', selectedCityOfStateID = '';

  final TextEditingController addressController = TextEditingController(),
      address2Controller = TextEditingController(),
      pinCodeController = TextEditingController(),
      addressBuildingStreetAreaController = TextEditingController();

  late VendorUserColl vendor;
  late LatLng center;
  late Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();
  late CameraPosition kOutlet;

  saveOutletClickHandler() async {
    try {
      isLoading = true;
      update();
      await VendorOutletConnect().updateVendorOutletsApi(
          changeType: 'update',
          vendor: vendor,
          changedOutletCoordinates: {
            'userOutletAddressBuildingStreetArea':
                addressBuildingStreetAreaController.text,
            'userOutletAddressPinCode': pinCodeController.text,
            'userOutletAddressCity': selectedCity,
            'userOutletAddress2': address2Controller.text,
            'userOutletAddress1': addressController.text,
            'lat': center.latitude,
            'long': center.longitude,
            'userOutletAddressState': selectedState
          },
          userOutletID: outlet.userOutletID);
      isLoading = false;
      update();
      Navigator.of(navigatorKey.currentContext!).pop();
    } catch (e) {
      isLoading = false;
      update();
      debugPrint('saveOutletClickHandler catch | $e');
      utils.showSnackBar(e.toString());
    }
  }

  Future<void> goToTheOutlet() async {
    await (await googleMapController.future).animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center, zoom: 19.151926040649414)));
    update();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    vendor = (await utils.getUser() as VendorUserColl);
    if (kDebugMode) {
      addressController.text = '1 ramnagar';
      address2Controller.text = 'gondal road, near pdm college';
      addressBuildingStreetAreaController.text = 'near pdm college';
      pinCodeController.text = '360004';
    }
    // await CityConnect().getCityListApi();
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
    debugPrint('outlet.userOutletAddressCity : ${outlet.userOutletAddressCity}');
    selectedCity = outlet.userOutletAddressCity;
    selectedState = outlet.userOutletAddressState;
    pinCodeController.text = outlet.userOutletAddressPinCode;
    addressController.text = outlet.userOutletAddress1;
    address2Controller.text = outlet.userOutletAddress2;
    addressBuildingStreetAreaController.text = outlet.userOutletAddressBuildingStreetArea;
    // changeSelectedCity(selectedCity);
    // await changeSelectedState(selectedState);
    center = LatLng(outlet.lat, outlet.long);
    kOutlet = CameraPosition(target: center, zoom: 19.151926040649414);
    isLoading = false;
    update();
  }

  onGoogleMapTap(LatLng latLng) {
    center = LatLng(latLng.latitude, latLng.longitude);
    kOutlet = CameraPosition(target: center, zoom: 19.151926040649414);
    update();
  }

  changeSelectedState(String stateName) async {
    selectedState = stateName;
    var localState =
        await isar.stateColls.filter().stateNameEqualTo(stateName).findFirst();
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

  changeSelectedCity(String city) {
    selectedCity = city;
    update();
  }
}
