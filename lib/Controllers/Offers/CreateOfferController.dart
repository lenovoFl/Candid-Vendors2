import 'package:candid_vendors/Screens/OfferScreens/OfferPreviewScreen.dart';
import 'package:candid_vendors/Services/Collections/City/CityColl.dart';
import 'package:candid_vendors/Services/Collections/Offers/OffersCat/OffersCatColl.dart';
import 'package:candid_vendors/Services/Collections/State/StateColl.dart';
import 'package:candid_vendors/Services/Collections/User/VendorUserColl.dart';
import 'package:candid_vendors/Services/Collections/VendorPolicy/VendorPolicyColl.dart';
import 'package:candid_vendors/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';

import '../../Services/APIs/Policies/PoliciesConnect.dart';
import '../Profile/ProfileController.dart';


class CreateOfferController extends GetxController {
  late final String offerID = '';
  VendorUserColl? user;
  // Assuming XFile is used by ImagePicker
  List<XFile> selectedImages = [];
  XFile? selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
 // late final TextEditingController maxNumClaimsController;
 // late final TextEditingController describeDealDetailsController;
 // late final TextEditingController stepsToRedeemController;
 // late final TextEditingController termsAndConditionController;
  var showDiscountedPrice = false.obs;
  var showDiscountedPrimePrice = false.obs;
  String offerDiscountedPrice = ''; // Discounted price for regular price
  String offerPrimeDiscountedPrice = ''; // Discounted price for prime price
  bool isLoading = true,
      isPolicyAddView = true,
      onlyForPrime = false,
      isCreativeDesigned = false,
      isAgreePolicies = false,
      showPriceAndPrimePrice = true,
      showChangeInPriceVolume = false;
  int availableOffer = 15;
  String OfferName = '',
      productName = '',
      productDescription = '',
      offerDescription = '',
      offerPrimeOffer = '',
      offerDiscount =  '',
      offerPrimeDiscount =  '',
      dropDownValue = 'Price',
      discountDropDownValue = '%',
      selectedCategory = '',
      selectedOfferType = '',
      regularDiscountNumber = '',
      primeDiscountNumber ='',
      primeUnitPrice = '',
      primeDiscountedPrice ='',
      regularUnitPrice = '',
      selectedCityOfStateID = '',
      selectedCity = '',
      warranty =  '',
      refund =  '',
      delivery = '',
      COD =  '',
      other = 'other',
      maxNumClaims =  '',
      // describeDealDetails = '',
      // stepsToRedeem =  '',
     // termsAndCondition = '',
      selectedState = '',
      offerDiscountType = '',
      unitPrice2 = '',
      selectedCatID = '';
//  late late final    selectedTCFor = '';
 // List<String> list = <String>['warranty', 'refund', 'delivery', 'COD', 'other'];
  String selectedTCFor = '';
 // VendorPolicyColl? vendorPolicyColl;
  DateTime selectedStartDate = DateTime.now(),
      selectedEndDate = DateTime.now().add(const Duration(days: 30));
  List<String> list = <String>['warranty', 'refund', 'delivery', 'COD', 'other'];
  VendorPolicyColl? vendorPolicyColl;
  List<String> items = [
    'Price',
    'Volume',
  ],
      discountLst = ['%', 'EA'],
      primeDiscountLst = ['%', 'EA'],
      offersType = [],
      offersCats = [],
      cityList = [],
      discountTypeList = ['Commodity', 'Product'];

  List<XFile> images = [];
  Map<String, int> claimCounts = {};
  late VendorUserColl vendor;
  ProfileController profileController = ProfileController(); // Example of how to define profileController
  final formKey = GlobalKey<FormState>();
  TextEditingController countedDiscountController = TextEditingController(),
      countedPrimeDiscountController = TextEditingController(),

      selectedTCText = TextEditingController();
     // termsAndConditionController = TextEditingController();


  bool isProductOffer = true; // Default to Product
  bool isServiceOffer = false;

  String serviceDescription = '';
  String serviceDuration = '';
  String serviceTerms = '';

  void updateSecondDropDownValue(String newValue) {
    offerDiscountType = newValue;
    showPriceAndPrimePrice = newValue == 'Commodity' ? false : true;
    if (!showChangeInPriceVolume) {
      showChangeInPriceVolume = true;
    }
    update();
  }

  @override
  Future<void> onInit() async {
    vendor = (await utils.getUser() as VendorUserColl);
    if (offersType.isNotEmpty) {
      selectedOfferType = offersType.first;
      isProductOffer = selectedOfferType.toLowerCase() == 'product';
      isServiceOffer = selectedOfferType.toLowerCase() == 'service';
    }
    // Check if discountTypeList is not empty before accessing its first element
    if (discountTypeList.isNotEmpty) {
      offerDiscountType = discountTypeList.first;
      showPriceAndPrimePrice = offerDiscountType == 'Commodity' ? false : true;
    }

    if (vendor.offerCount <= 0) {
      utils.showSnackBar(
          "You cannot create an offer as you don't have a balance to do so!");
    }

    var cats = await isar.offersCatColls
        .where(distinct: true)
        .distinctByCatType()
        .build()
        .findAll();

    for (var cat in cats) {
      offersType.add(cat.catType);
    }

    // Check if offersType is not empty before accessing its first element
    if (offersType.isNotEmpty) {
      selectedOfferType = offersType.first;
    }

    await updateCats();

    var localCities = await isar.cityColls.where().build().findAll();

    for (var city in localCities) {
      if (city.cityName == vendor.userAddressCity) {
        var localState = await isar.stateColls
            .filter()
            .stateIDEqualTo(city.cityOfStateID)
            .build()
            .findFirst();

        selectedState = localState?.stateName ?? "";
        await changeSelectedCity(city.cityName);
      }

      cityList.add(city.cityName);
    }

    isLoading = false;
  //  maxNumClaimsController = TextEditingController();
  //  describeDealDetailsController = TextEditingController();
  //  stepsToRedeemController = TextEditingController();
  //  termsAndConditionController = TextEditingController();
    update();
    super.onInit();
  }

  changeSelectedOfferType(String offerType) async {
    selectedOfferType = offerType;
    isProductOffer = offerType.toLowerCase() == 'product';
    isServiceOffer = offerType.toLowerCase() == 'service';
    update();
    await updateCats();
  }

  updateServiceDescriptionTxt(String newServiceDescription) {
    serviceDescription = newServiceDescription;
    update();
  }

  updateServiceDurationTxt(String newServiceDuration) {
    serviceDuration = newServiceDuration;
    update();
  }

  updateServiceTermsTxt(String newServiceTerms) {
    serviceTerms = newServiceTerms;
    update();
  }

  Future<void> updateCats() async {
    offersCats.clear();
    var cats = await isar.offersCatColls
        .filter()
        .catNameIsNotEmpty()
        .catTypeEqualTo(selectedOfferType)
        .build()
        .findAll();

    if (cats.isNotEmpty) {
      for (var cat in cats) {
        offersCats.add(cat.catName);
      }
      selectedCategory = offersCats.first;
      selectedCatID = cats.first.catID;
      print('Initial Category ID: $selectedCatID'); // For debugging
    } else {
      selectedCategory = '';
      selectedCatID = '';
      utils.showSnackBar('No categories available for the selected offer type!');
    }
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

  changeSelectedCity(String updatedSelectedCity) {
    selectedCity = updatedSelectedCity;
    update();
  }


  // changeSelectedOfferType(String offerType) async {
  //   selectedOfferType = offerType;
  //   update();
  //   await updateCats();
  // }

  changeSelectedCategory(String cat) async {
    selectedCategory = cat;
    // Get the category with matching name and type
    var cats = await isar.offersCatColls
        .filter()
        .catNameEqualTo(cat)
        .and()
        .catTypeEqualTo(selectedOfferType)
        .build()
        .findFirst();

    if (cats != null) {
      selectedCatID = cats.catID;
      print('Selected Category ID: $selectedCatID'); // For debugging
    } else {
      print('No matching category found'); // For debugging
      // Set a default or show error
      utils.showSnackBar('Error: Category not found');
    }
    update();
  }

  Future<void> selectImagesFromLocal() async {
    print('🟢 Image selection started');
    if (selectedImages.length >= 5) {
      Get.snackbar(
        'Limit Reached',
        'You can only select up to 5 images.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('⚠️ Already have 5 images, skipping selection');
      return;
    }

    final List<XFile>? images = await _imagePicker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      print('✅ Selected ${images.length} new image(s) from picker');
      for (var img in images) {
        print('📸 Selected Image Path: ${img.path}');
      }

      final int remainingSlots = 5 - selectedImages.length;
      selectedImages.addAll(images.take(remainingSlots));

      print('🧾 Final SelectedImages List:');
      for (var img in selectedImages) {
        print('➡️ ${img.path}');
      }
    } else {
      print('❌ No images selected!');
    }

    update();
    print('🔄 Controller updated after image selection');
  }

  void removeSelectedImageAtIndex(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      update();
    }
  }

  createOffer() async {
    if (vendor.offerCount == 0) {
      utils.showSnackBar("Don't have balance to create an offer!");
      return;
    }

    if (formKey.currentState!.validate()) {
      if (selectedImages.isEmpty) {
        utils.showSnackBar('Select at least 1 image!');
      } else {
        print('Selected Category ID before navigation: $selectedCatID'); // Debug print
        await Navigator.of(navigatorKey.currentContext!).push(
          MaterialPageRoute(
            builder: (BuildContext context) => OfferPreviewScreen(
              images: selectedImages,
              discountDropDownValue: discountDropDownValue,
              offerName: OfferName,
              refund: refund,
              COD: COD,
              other: other ?? "other",
              delivery: delivery,
              maxNumClaims: maxNumClaims,
              productName: productName,
              warranty: warranty,
              unitPrice2: unitPrice2,
              dropDownValue: dropDownValue,
              offerDiscount: offerDiscount,
              offerDescription: offerDescription,
              offerPrimeDiscount: offerPrimeDiscount,
              selectedStartDate: selectedStartDate,
              selectedEndDate: selectedEndDate,
              selectedCategory: selectedCategory,
              selectedOfferType: selectedOfferType,
              productDescription: productDescription,
              selectedCity: selectedCity,
              regularDiscountNumber: regularDiscountNumber,
              primeDiscountNumber: primeDiscountNumber,
              primeUnitPrice: primeUnitPrice,
              primeDiscountedPrice: primeDiscountedPrice,
              regularUnitPrice: regularUnitPrice,
              selectedState: selectedState,
              offerDiscountType: offerDiscountType,
              offerDiscountedPrice: offerDiscountedPrice,
              offerPrimeDiscountedPrice: offerPrimeDiscountedPrice,
              selectedCatID: selectedCatID,
            ),
          ),
        );
      }
    } else {
      utils.showSnackBar('Form needs to be filled.');
    }
    update();
  }


  bool manuallyChangedRegularPrice = false; // Flag to track manual change in regular price

  void calculateDiscountedPrice() {
    if (discountDropDownValue == '%' &&
        offerDiscount.isNotEmpty &
        unitPrice2.isNotEmpty) {
      double discount = double.parse(offerDiscount);
      double price = double.parse(unitPrice2);
      double discountedPrice = price - ((discount / 100) * price);

      if (!manuallyChangedRegularPrice) {
        offerDiscountedPrice = discountedPrice.toStringAsFixed(2);
      }
    } else if (discountDropDownValue == 'EA' &&
        offerDiscount.isNotEmpty &&
        unitPrice2.isNotEmpty) {
      int discount = int.parse(offerDiscount);
      double price = double.parse(unitPrice2);
      double discountedPrice = price - (discount * 1.0);

      if (!manuallyChangedRegularPrice) {
        offerDiscountedPrice = discountedPrice.toStringAsFixed(2);
      }
    } else {
      offerDiscountedPrice = '';
    }

    // Calculate discounted price for prime price
    if (discountDropDownValue == '%' &&
        offerPrimeDiscount.isNotEmpty &&
        unitPrice2.isNotEmpty) {
      double primeDiscount = double.parse(offerPrimeDiscount);
      double price = double.parse(unitPrice2);
      double primeDiscountedPrice = price - ((primeDiscount / 100) * price);
      offerPrimeDiscountedPrice = primeDiscountedPrice.toStringAsFixed(2);
    } else if (discountDropDownValue == 'EA' &&
        offerPrimeDiscount.isNotEmpty &&
        unitPrice2.isNotEmpty) {
      int primeDiscount = int.parse(offerPrimeDiscount);
      double price = double.parse(unitPrice2);
      double primeDiscountedPrice = price - (primeDiscount * 1.0);
      offerPrimeDiscountedPrice = primeDiscountedPrice.toStringAsFixed(2);
    } else {
      offerPrimeDiscountedPrice = '';
    }
    countedPrimeDiscountController.text = offerPrimeDiscountedPrice;
    countedDiscountController.text = offerDiscountedPrice;
    update(); // Update the state to reflect the changes
  }

  updateUnitPrice2(String unitPrice) {
    unitPrice2 = unitPrice;
    manuallyChangedRegularPrice =
    true; // User manually changed the regular price
    calculateDiscountedPrice(); // Calculate discounted price when unit price changes
    manuallyChangedRegularPrice = false; // Reset the flag for the next change
    update();
  }

  updateOfferDiscount(String newOfferDiscount) {
    if (offerDiscount.isNotEmpty) {
      showDiscountedPrice.value = true;
    } else {
      showDiscountedPrice.value = false;
    }
    offerDiscount = newOfferDiscount;
    update();
    manuallyChangedRegularPrice =
    true; // User manually changed the regular price
    calculateDiscountedPrice(); // Calculate discounted price when discount changes
    manuallyChangedRegularPrice = false; // Reset the flag for the next change
    update();
  }

  updateOfferPrimeDiscount(String newOfferPrimeDiscount) {
    if (offerPrimeDiscount.isNotEmpty) {
      showDiscountedPrimePrice.value = true;
    } else {
      showDiscountedPrimePrice.value = false;
    }
    offerPrimeDiscount = newOfferPrimeDiscount;
    calculateDiscountedPrice(); // Calculate discounted price for prime price
    update();
  }


  updateIsCreativeDesigned(bool updatedIsCreativeDesigned) {
    isCreativeDesigned = updatedIsCreativeDesigned;
    update();
  }

  updateIsAgreePolicies(bool updatedIsAgreePolicies) {
    isAgreePolicies = updatedIsAgreePolicies;
    update();
  }

  // updateDiscountDropDown(String selectDiscount) {
  //   discountDropDownValue = selectDiscount;
  //   update();
  // }

  updatePrimeDiscountDropDown(String selectPrimeDisType) {
    discountDropDownValue = selectPrimeDisType;
    if (!showChangeInPriceVolume) {
      showChangeInPriceVolume = true;
    }
    update();
  }

  updateDiscountTypeDropDown(String selectDisType) {
    dropDownValue = selectDisType;
    if (selectDisType == 'Price') {
      discountDropDownValue = '%';
    } else if (selectDisType == 'Volume') {
      discountDropDownValue = 'EA';
    }
    update();
  }

  Future<void> selectEndDate() async {
    final DateTime? picked = await showDatePicker(
        context: navigatorKey.currentContext!,
        initialDate: selectedStartDate,
        firstDate: selectedStartDate,
        lastDate: selectedEndDate);
    if (picked != null && picked != selectedEndDate) {
      selectedEndDate = picked;
      update();
    }
  }

  Future<void> selectStartDate() async {
    final DateTime? picked = await showDatePicker(
        context: navigatorKey.currentContext!,
        initialDate: selectedStartDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedStartDate) {
      selectedStartDate = picked;
      selectedEndDate = selectedStartDate.add(const Duration(days: 30));
      update();
    }
  }

  updateOnlyForPrime(bool onlyPrime) {
    onlyForPrime = onlyPrime;
    update();
  }

  updateOfferNameTxt(String newOfferName) {
    OfferName = newOfferName;
    update();
  }

  updatewarrantyTxt(String newwarranty) {
    warranty = newwarranty;
    update();
  }

  updaterefundTxt(String newrefund) {
    refund = newrefund;
    update();
  }

  updatedeliveryTxt(String newdelivery) {
    delivery = newdelivery;
    update();
  }

  updateCODTxt(String newCOD) {
    COD = newCOD;
    update();
  }

  updateotherTxt(String newother) {
    other = newother;
    update();
  }

  updateProductNameTxt(String newProductName) {
    productName = newProductName;
    update();
  }

  updateProductDescriptionTxt(String newProductDescription) {
    productDescription = newProductDescription;
    update();
  }

  updateregularUnitPrice(String newregularUnitPrice){
    regularUnitPrice = newregularUnitPrice;
    update();
  }

  updateprimeDiscountedPrice(String newprimeDiscountedPrice){
    primeDiscountedPrice = newprimeDiscountedPrice;
    update();
  }

  updatemaxNumClaimsTxt(String newmaxNumClaims){
    maxNumClaims = newmaxNumClaims;
    update();
  }

  // updatedescribeDealDetailsTxt (String newdescribeDealDetails ){
  //   describeDealDetails  = newdescribeDealDetails ;
  //   update();
  // }
  //
  // updatestepsToRedeemTxt(String newstepsToRedeem){
  //   stepsToRedeem = newstepsToRedeem;
  //   update();
  // }

  updateprimeUnitPrice(String newprimeUnitPrice){
    primeUnitPrice = newprimeUnitPrice;
    update();
  }

  updateofferPrimeDiscountedPrice(String newofferPrimeDiscountedPrice){
    offerPrimeDiscountedPrice =newofferPrimeDiscountedPrice;
    update();
  }
  updateprimeDiscountNumber (String newprimeDiscountNumber){
    newprimeDiscountNumber = newprimeDiscountNumber;
    update();
  }
  updateregularDiscountNumber(String newregularDiscountNumber){
    regularDiscountNumber = newregularDiscountNumber;
    update();
  }

  updateOfferPrimeOfferTxt(String newOfferPrimeOffer) {
    offerPrimeOffer = newOfferPrimeOffer;
    update();
  }

  updateOfferDescriptionTxt(String newOfferDescription) {
    offerDescription = newOfferDescription;
    update();
  }
  changeValuePolicy({required VendorPolicyColl vendorPolicy}) {
    if (selectedTCFor == 'warranty') {
      selectedTCText.text = vendorPolicy.vendorWarrantyPolicy;
    }
    if (selectedTCFor == 'refund') {
      selectedTCText.text = vendorPolicy.vendorRefundPolicy;
    }
    if (selectedTCFor == 'delivery') {
      selectedTCText.text = vendorPolicy.vendorDelivery;
    }
    if (selectedTCFor == 'COD') {
      selectedTCText.text = vendorPolicy.vendorPaymentPolicy;
    }
    if (selectedTCFor == 'other') {
      selectedTCText.text = vendorPolicy.vendorOtherPolicy;
    }
    update();
  }
  showVendorPoliciesView() async {
    vendorPolicyColl = await isar.vendorPolicyColls.where().build().findFirst();
    changeValuePolicy(vendorPolicy: vendorPolicyColl!);
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
                      Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(seconds: 1),
                          child: isPolicyAddView
                              ? SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Seller ID : ',
                                          textScaleFactor: 1.5,
                                          style: TextStyle(
                                              color: Colors.blue.shade900,
                                              fontWeight: FontWeight.bold)),
                                      Text(user?.userId ?? '',
                                          textScaleFactor: 1.5,
                                          style: TextStyle(
                                              color: Colors.blue.shade900,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Seller Name : ',
                                          textScaleFactor: 1.5,
                                          style: TextStyle(
                                              color: Colors.blue.shade900,
                                              fontWeight: FontWeight.bold)),
                                      Text(user?.userFullName ?? '',
                                          textScaleFactor: 1.5,
                                          style: TextStyle(
                                              color: Colors.blue.shade900,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text('T&C For : ',
                                        textScaleFactor: 1.5,
                                        style: TextStyle(
                                            color: Colors.blue.shade900,
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        value: selectedTCFor,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Select T&C For',
                                            labelText: 'Select T&C For'),
                                        style:
                                        TextStyle(color: Colors.blue.shade900),
                                        onChanged: (String? value) {
                                          selectedTCFor = value!;
                                          if (selectedTCFor == "warranty") {
                                            selectedTCText.text = vendorPolicyColl
                                                ?.vendorWarrantyPolicy ??
                                                "";
                                          } else if (selectedTCFor == "refund") {
                                            selectedTCText.text = vendorPolicyColl
                                                ?.vendorRefundPolicy ??
                                                "";
                                          } else if (selectedTCFor == "delivery") {
                                            selectedTCText.text =
                                                vendorPolicyColl?.vendorDelivery ??
                                                    "";
                                          } else if (selectedTCFor == "COD") {
                                            selectedTCText.text = vendorPolicyColl
                                                ?.vendorPaymentPolicy ??
                                                "";
                                          } else if (selectedTCFor == "other") {
                                            selectedTCText.text = vendorPolicyColl
                                                ?.vendorOtherPolicy ??
                                                "";
                                          }
                                          update();
                                        },
                                        items: list.map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('T&C Text : ',
                                        textScaleFactor: 1.5,
                                        style: TextStyle(
                                            color: Colors.blue.shade900,
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: TextFormField(
                                        controller: selectedTCText,
                                        maxLines: 4,
                                        autovalidateMode: AutovalidateMode.always,
                                        validator: (value) => utils.validateText(
                                            string: value.toString(),
                                            required: true),
                                        decoration: InputDecoration(
                                            labelText:
                                            'Write T&C Text for $selectedTCFor',
                                            hintText:
                                            'Write T&C Text $selectedTCFor',
                                            border: const OutlineInputBorder()),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: myWidgets.getLargeButton(
                                            bgColor: Colors.blue.shade900,
                                            title: 'Save',
                                            onPress: () => PoliciesConnect()
                                                .updateVendorPolicyByPhoneApi(
                                              selectedTCFor: selectedTCFor,
                                              selectedTCText: selectedTCText.text,
                                              profileController: this as ProfileController,
                                              vendorPolicyColl: vendorPolicyColl,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: myWidgets.getLargeButton(
                                            bgColor: Colors.blue.shade900,
                                            title: 'Cancel',
                                            onPress: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: myWidgets.getLargeButton(
                                            bgColor: Colors.blue.shade900,
                                            title: 'Export',
                                            onPress: () {},
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ]),
                                ),

                                // Text('Return & exchange policy',
                                //     textScaleFactor: 1.5,
                                //     style: TextStyle(
                                //         color: Colors.blue.shade900,
                                //         fontWeight: FontWeight.bold)),
                                // SizedBox(
                                //     width: 90.w,
                                //     height: 35.h,
                                //     child: Card(
                                //       child: SingleChildScrollView(
                                //           child: Text(
                                //               policyColl
                                //                   .returnExchangePolicy,
                                //               textScaleFactor: 1.3)),
                                //     )),
                                // Text(
                                //   'Refund or Exchange In Days : ${policyColl.refundExchangeInDaysPolicy}',
                                //   textScaleFactor: 1.3,
                                // ),
                                // Text('Warranty Policy',
                                //     textScaleFactor: 1.5,
                                //     style: TextStyle(
                                //         color: Colors.blue.shade900,
                                //         fontWeight: FontWeight.bold)),
                                // SizedBox(
                                //     width: 90.w,
                                //     height: 35.h,
                                //     child: Card(
                                //       child: SingleChildScrollView(
                                //           child: Text(
                                //               policyColl.warrantyPolicy,
                                //               textScaleFactor: 1.3)),
                                //     )),
                                // Text(
                                //     'Payment Policy : ${policyColl.paymentPolicy == 'COD' ? 'Cash on delivery' : policyColl.paymentPolicy}',
                                //     textScaleFactor: 1.3)
                              ]
                                  .map((e) => Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: e,
                              ))
                                  .toList(),
                            ),
                          )
                              : Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                      child: Text('Seller warranty policy'),
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Text(
                                          vendorPolicyColl?.vendorWarrantyPolicy ??
                                              '',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                      child: Text('Seller refund policy'),
                                    ),
                                    Expanded(
                                      child: Text(
                                        vendorPolicyColl?.vendorRefundPolicy ?? '',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                      child: Text('Seller delivery policy'),
                                    ),
                                    Expanded(
                                      child: Text(
                                        vendorPolicyColl?.vendorDelivery ?? '',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                      child: Text('Seller COD policy'),
                                    ),
                                    Expanded(
                                      child: Text(
                                        vendorPolicyColl?.vendorPaymentPolicy ?? '',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  // Add a row for "Other" policy
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                      child: Text('Seller Other policy'),
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Text(
                                          vendorPolicyColl?.vendorOtherPolicy ?? '',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                                  .map(
                                    (e) => Padding(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: e,
                                ),
                              )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
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
  }
}
