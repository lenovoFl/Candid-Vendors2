import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:candid_vendors/Screens/AuthScreens/CreateProfileSteps/CreateProfileStep2.dart';
import 'package:candid_vendors/Screens/AuthScreens/CreateProfileSteps/CreateProfileStep3.dart';
import 'package:candid_vendors/Services/APIs/Champion/ChampionConnect.dart';
import 'package:candid_vendors/Services/APIs/City/CityConnect.dart';
import 'package:candid_vendors/Services/APIs/Document/DocumentConnect.dart';
import 'package:candid_vendors/Services/Collections/City/CityColl.dart';
import 'package:candid_vendors/Services/Collections/Offers/OffersCat/OffersCatColl.dart';
import 'package:candid_vendors/Services/Collections/State/StateColl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sizer/sizer.dart';
import '../../BottomNavScreen.dart';
import '../../Screens/AuthScreens/CreateProfileSteps/CreateProfileStep1.dart';
import '../../Services/APIs/Auth/AuthConnect.dart';
import '../../Services/APIs/Cats/CatsConnect.dart';
import '../../Services/APIs/Payment/PaymentConnect.dart';
import '../../Services/APIs/Payment/razorpayPaymentconnect.dart';
import '../../Utils/Utils.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;
import '../../Services/AWS/aws_s3_service.dart';

class CreateProfileController extends GetxController
    with WidgetsBindingObserver {
  String generatedTranId = '';
  String generatedRequestId = '';
  File? chequeImage;
  String? chequeImageURL;

  bool isChequePayment = false;
  // final PaymentController;
  final Razorpay _razorpay = Razorpay();
  final ApiServices apiServices = ApiServices();
  String razorpayKey = "rzp_live_mXMqD6Uq31IPNc";
  String razorpaySecret = "R31iM3MZyxPQdBtNmAPF4s9V";
  RxString cityName = ''.obs;
  RxString stateName = ''.obs;
  late LatLng center;
  late Completer<GoogleMapController> googleMapController =
  Completer<GoogleMapController>();
  CameraPosition? kGooglePlex;
  CameraPosition? kOutlet;
  // final Isar isar;
  // final Utils utils;
  final RxList<OffersCatColl> categories = <OffersCatColl>[].obs;
  // final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  //Instance of razor pay
  // final razorPayKey = dotenv.get("RAZOR_KEY") ?? "fallback_key";
  // final razorPaySecret = dotenv.get("RAZOR_SECRET") ?? "fallback_secret";
  // bool isPanVerified = false;
  bool showMap = false;
  bool isRegistering = false;
  bool isImagePickerActive = false; // Flag to check if ImagePicker is active

  // late VendorUserColl vendor;
  List<GlobalKey<FormState>> createProfileFormKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  final TextEditingController referralController = TextEditingController();
  TextEditingController companyNameEditingController = TextEditingController(),
      reenterAccountNumberController = TextEditingController(),
  //  storeNameController = TextEditingController(),
      reenterIfscController = TextEditingController(),
      fullNameEditingController = TextEditingController(),
      CompanyPanEditingController = TextEditingController(),
      addressLine1EditingController = TextEditingController(),
      addressLine2EditingController = TextEditingController(),
  // addressStreetEditingController = TextEditingController(),
  // addressAreaEditingController = TextEditingController(),
      addressBuildingStreetAreaEditingController = TextEditingController(),
      gstEditingController = TextEditingController(),
      addressPinCodeEditingController = TextEditingController(),
  // addressStateEditingController = TextEditingController(),
      emailIdEditingController = TextEditingController(),
      panNoEditingController = TextEditingController(),
      aadhaarNoEditingController = TextEditingController(),
      otpEditingController = TextEditingController(),
      bankAccountHolderNameEditingController = TextEditingController(),
      bankAccountHolderAcNumberController = TextEditingController(),
      bankAccountHolderAc1NumberController = TextEditingController(),
      bankAccountHolderIFSCController = TextEditingController(),
      bankAccountHolderIFSC1Controller = TextEditingController(),
      bankAccountHolderBankNameController = TextEditingController(),
      bankAccountHolderBankBranchController = TextEditingController();

  RxBool isPanVerified = RxBool(false);
  bool _showUploadAadhaarOption = false;
  bool isLoading = false,
      isVerified = false,
      isGSTTextFieldEnabled = false,
      isGstValid = false,
      isGSTRegistered = false,
      isGSTFieldVisible = false,
      isPaymentSuccessful = false,
      isSubscriptionRecharge = true,
      acceptedTermsAndCondition = false,
      isVerifyEmailSent = false,
      isAadhaarValid = false,
      _isOtpRequested = false,
      isEmailVerified = false,
      isPaymentDone = false,
      isPanValid = false;
  // isPanVerified = false,
  // isPanValid = false,

  bool get showUploadAadhaarOption => _showUploadAadhaarOption;
  List<String> gendersList = ['Male', 'Female', 'Others'],
      typeOfCompany = [
        'LLP',
        'NGO',
        'Partnership',
        'Private Limited',
        'Public Limited',
        'Sole Proprietorship',
        'Trust',
        'HUF'
      ],
      cityList = [],
      championList = [];
  String? selectedCityOfStateID;
  String selectedTypeOfCompany = 'Private Limited',
      aadhaarCard = '',
      selectedGender = 'Male',
      message = 'Verification is done!',
      selectedPlanCost = '',
      selectedPlanDurationInDays = '',
  // selectedCityOfStateID = '',
      selectedsubscriptionPlanCost = '',
      referBy = 'Self',
      storeRating = '',
      profileStatus = '',
      selectedChampionID = '';
  String? selectedCity = '', selectedState = '';
  int selectedStep = 0;
  final String mobileNumber, countryCode;
  final User user;
  List<Step> steps = [];
  XFile? personalImage, aadhaarCardImage, panCardImage, companyLogo;
  Map<String, dynamic>? paymentIntent;
  List<Map<String, String>> catsList = [], selectedCatsList = [];
  List<Map<String, dynamic>> myOutlets = [];
  String selectedSubscriptionPlanStartDate = '',
      selectedSubscriptionPlanEndDate = '',
      selectedSubscriptionPlanId = '';
  String savings = '';
  final Set<String> completedReferralTransactions = {};

  int selectedSubscriptionPlanOfferCount = 0;
  final AWSS3Service _s3Service = AWSS3Service();

  String? selectedChampionName; // Field to store the champion name
  String? selectedChampionMobile; // Field to store the champion mobile number

  CreateProfileController( //this.PaymentController,
          {
        required this.mobileNumber,
        required this.user,
        required this.countryCode,
      });

  Future<void> getAadhaarOtpBtnClickHandler() async {
    try {
      isLoading = true;
      update();

      dynamic response = await DocumentConnect().getAadhaarOtpApi(
        aadhaarCard: aadhaarNoEditingController.text,
      );

      if (response != null && response['status'] == 'SUCCESS') {
        updateTranAndRequestIds(
          Utils.accessKey,
          Utils.caseId,
        );
        utils.showSnackBar('OTP has been sent successfully');
      } else {
        utils.showSnackBar('Failed to send OTP. Please try again.');
      }
    } catch (e) {
      debugPrint('getAadhaarOtpBtnClickHandler Error: $e');
      utils.showSnackBar('Failed to send OTP: ${e.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> verifyAadhaarOtpWithTranBtnClickHandler() async {
    try {
      isLoading = true;
      update();

      dynamic response = await DocumentConnect().getAadhaarDetailsApi(
        otp: otpEditingController.text,
        accessKey: Utils.accessKey,
        aadhaarNo: aadhaarNoEditingController.text,
        caseId: Utils.caseId,
      );

      if (response['status'] == 'SUCCESS') {
        isVerified = true;
        utils.showSnackBar(
            response['message'] ?? 'Your Aadhaar card has been verified');
      } else {
        isVerified = false;
        utils.showSnackBar(response['message'] ?? 'Verification failed');
      }
    } catch (e) {
      debugPrint('verifyAadhaarOtpWithTranBtnClickHandler Error: $e');
      isVerified = false;
      utils.showSnackBar('An error occurred during verification');
    } finally {
      isLoading = false;
      update();
    }
  }

  void updateTranAndRequestIds(String? tranId, String? requestId) {
    generatedTranId = tranId ?? '';
    generatedRequestId = requestId ?? '';
    // debugPrint('Transaction ID: $tranId');
    // debugPrint('Request ID: $generatedRequestId');
  }

  Future<void> verifyReferral(BuildContext context) async {
    final String referralId = referralController.text.trim();
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    debugPrint("refrelid: $referralId");
    debugPrint("userid: $userId");

    if (referralId.isEmpty) {
      // Handle empty referral ID case
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a referral ID.")),
      );
      return;
    }

    // Check if this referral transaction has already been made
    if (completedReferralTransactions.contains(referralId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
            Text("Referral transaction already happened for this ID.")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'https://candidoffers.com:3636/api/firebase/sellers/referral-transaction'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userUid': userId,
          'referralId': referralId,
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful API response
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Referral ID verified successfully.")),
        );

        // Mark this referralId as completed by adding to the set
        completedReferralTransactions.add(referralId);
      } else {
        // Parse the error response and extract the message
        final errorResponse = jsonDecode(response.body);
        final errorMessage =
            errorResponse['message'] ?? 'Failed to verify referral ID.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error verifying referral ID: $e")),
      );
    }
  }

  void handleGSTYes() {
    isGSTFieldVisible = true;
    isGSTRegistered = true;
    isGstValid = false; // Reset validation
    isGSTTextFieldEnabled = true; // Enable the text field
    gstEditingController.text = ''; // Clear any existing text
    update(); // Important: Trigger UI update
  }

  void handleGSTNo() {
    isGSTFieldVisible = false;
    isGSTRegistered = false;
    isGstValid = false; // Reset validation
    isGSTTextFieldEnabled = false; // Disable the text field
    gstEditingController.clear(); // Clear any existing GST number
    update(); // Important: Trigger UI update
  }

  void validatePanBtnClickHandler() async {
    try {
      isLoading = true;
      update();

      Map<String, dynamic> response = await DocumentConnect().getPanDetailsApi(
        panCard: panNoEditingController.text,
      );

      debugPrint('PAN Verification Response: $response');

      if (response['status'] == 'SUCCESS' && response['data'] != null) {
        String name = response['data']['name'] ?? '';
        if (name.isNotEmpty) {
          isPanVerified.value = true;
          fullNameEditingController.text = name;
          isPanValid = true;
          utils.showSnackBar('PAN verified successfully');
        } else {
          utils.showSnackBar('Invalid PAN number or name not found');
          isPanValid = false;
          isPanVerified.value = false;
        }
      } else {
        utils.showSnackBar(response['message'] ?? 'Failed to verify PAN');
        isPanValid = false;
        isPanVerified.value = false;
      }
    } catch (e) {
      debugPrint('validatePanBtnClickHandler Error: $e');
      utils.showSnackBar('Failed to verify PAN: ${e.toString()}');
      isPanValid = false;
      isPanVerified.value = false;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> validateGSTBtnClickHandler() async {
    try {
      isLoading = true;
      update();

      if (gstEditingController.text.trim().isEmpty) {
        throw 'Please enter GST number';
      }

      Map<String, dynamic> gstData = await DocumentConnect()
          .getGSTDetailsApi(gstNumber: gstEditingController.text);

      if (gstData.containsKey('basicDetails')) {
        Map<String, dynamic> basicDetails = gstData['basicDetails'];
        companyNameEditingController.text = basicDetails['Legal_Name'] ?? '';
        isGstValid = true;
        isGSTTextFieldEnabled =
        false; // Disable the GST field after successful validation
        gstEditingController.text = gstEditingController.text
            .toUpperCase(); // Ensure GST number is in uppercase
        utils.showSnackBar('GST verification successful');
      } else {
        throw 'Invalid GST details received';
      }
    } catch (e) {
      debugPrint('validateGSTBtnClickHandler Error: $e');
      isGstValid = false;
      isGSTTextFieldEnabled = true;
      utils.showSnackBar(e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  createProfileClickHandler() async {
    isLoading = true;
    update();

    Map<String, dynamic> userData = {
      // ...existing code...
      // 'tshirtSize': selectedTshirtSize, // Add T-shirt size to API payload
      // ...existing code...
      'userBusinessName': companyNameEditingController.text.trim().isNotEmpty
          ? companyNameEditingController.text.trim()
          : '',
      'bankAccountHolderName':
      bankAccountHolderNameEditingController.text.trim().isNotEmpty
          ? bankAccountHolderNameEditingController.text.trim()
          : '',
      'bankAccountHolderAcNumber':
      bankAccountHolderAcNumberController.text.trim().isNotEmpty
          ? bankAccountHolderAcNumberController.text.trim()
          : '',
      'bankAccountHolderAc1Number':
      bankAccountHolderAc1NumberController.text.trim().isNotEmpty
          ? bankAccountHolderAc1NumberController.text.trim()
          : '',
      'bankAccountHolderIFSC1':
      bankAccountHolderIFSC1Controller.text.trim().isNotEmpty
          ? bankAccountHolderIFSC1Controller.text.trim()
          : '',
      'bankAccountHolderIFSC':
      bankAccountHolderIFSCController.text.trim().isNotEmpty
          ? bankAccountHolderIFSCController.text.trim()
          : '',
      'bankAccountHolderBankName':
      bankAccountHolderBankBranchController.text.trim().isNotEmpty
          ? bankAccountHolderBankBranchController.text.trim()
          : '',
      'bankAccountHolderBankBranch':
      bankAccountHolderBankNameController.text.trim().isNotEmpty
          ? bankAccountHolderBankNameController.text.trim()
          : '',
      'userFullName': fullNameEditingController.text.trim().isNotEmpty
          ? fullNameEditingController.text.trim()
          : '',
      'userSelectedTypeOfCompany': selectedTypeOfCompany ?? 'Individual',
      'userPanNo': panNoEditingController.text.trim().isNotEmpty
          ? panNoEditingController.text.trim()
          : '',
      'CompanyPan': CompanyPanEditingController.text.trim().isNotEmpty
          ? CompanyPanEditingController.text.trim()
          : '',
      'aadhaarNo': aadhaarNoEditingController.text.trim().isNotEmpty
          ? aadhaarNoEditingController.text.trim()
          : '',
      'userGstNo': gstEditingController.text.trim().isNotEmpty
          ? gstEditingController.text.trim()
          : '',
      'userGender': selectedGender ?? 'Not Specified',
      'userAddressLine1': addressLine1EditingController.text.trim(),
      'userAddressLine2': addressLine2EditingController.text.trim(),
      'userAddressStreet':
      addressBuildingStreetAreaEditingController.text.trim(),
      'userAddressPinCode': addressPinCodeEditingController.text.trim(),
      'userAddressState': selectedState?.toString() ?? '',
      'storeRating': storeRating?.toString() ?? '0.0',
      'profileStatus': profileStatus?.toString() ?? 'incomplete',
      'userAddressCity': selectedCity?.toString() ?? '',
      'userAddress': '${addressLine1EditingController.text.trim()}, '
          '${addressLine2EditingController.text.trim()}, '
          '${addressBuildingStreetAreaEditingController.text.trim()}, '
          '${addressPinCodeEditingController.text.trim()}, '
          '${selectedCity?.toString()?.trim() ?? ""}, '
          '${selectedState?.toString()?.trim() ?? ""}',
      'mobileCode': countryCode ?? '+91',
      'userEmail1': emailIdEditingController.text.trim().isNotEmpty
          ? emailIdEditingController.text.trim()
          : '',
      'userJoinedSince':
      user.metadata.creationTime?.toString() ?? DateTime.now().toString(),
      'userLastSignInTime':
      user.metadata.lastSignInTime?.toString() ?? DateTime.now().toString(),
      'userMobile1': mobileNumber,
      'referredBy':
      referBy == 'Self' ? 'Candid-Offers' : selectedChampionID ?? '',
      'championName': selectedChampionName ?? '', // Include champion name
      'championMobile':
      selectedChampionMobile ?? '', // Include champion mobile number
      'userLastRefreshTime': "",
      'selectedCatsList': selectedCatsList ?? [],
      'userToken': "",
      'allowedModules': [],
      'currentSelectionData': [],
      'userEmail2': "",
      'userGroupId': "",
      'userGroupLevel': "",
      'userGroupName': "",
      'userMobile2': "",
      'userAuthToken': "",
      'candidOfferSubscriptionStartDate': DateTime.now().toString(),
      'candidOfferSubscriptionEndDate': DateTime.now()
          .add(Duration(days: int.parse(selectedPlanDurationInDays ?? '30')))
          .toString(),
      'myOutlets': myOutlets ?? [],
      'offerCount': 0,
    };

    // Get current location - keeping original implementation
    try {
      List<Location> locations =
      await locationFromAddress(userData['userAddress']);
      if (locations.isNotEmpty) {
        //   Location location = locations.first;
        userData['userLatitude'] = center.latitude;
        userData['userLongitude'] = center.longitude;
      }
    } catch (e) {}

    if (myOutlets.isEmpty) {
      myOutlets.add({
        'userstoreName': companyNameEditingController.text,
        'lat': center.latitude, // Keeping original latitude
        'long': center.longitude, // Keeping original longitude
        'userOutletAddress1': addressLine1EditingController.text,
        'userOutletAddress2': addressLine2EditingController.text,
        'userOutletAddressBuildingStreetArea':
        addressBuildingStreetAreaEditingController.text,
        'userOutletAddressCity': selectedCity.toString(),
        'userOutletAddressPinCode': addressPinCodeEditingController.text,
        'userOutletAddressState': selectedState
      });
    }

    try {
      // Upload files to S3 with logging
      if (personalImage != null) {
        String path =
            'vendorDocuments/${firebaseAuth.currentUser!.uid}/personalImage.${personalImage!.path.split('.').last}';
        print('Attempting to upload personal image...');
        print('Path: $path');
        print('File exists: ${await File(personalImage!.path).exists()}');
        print('File size: ${await File(personalImage!.path).length()} bytes');

        try {
          userData['userProfilePic'] =
          await _s3Service.uploadFile(File(personalImage!.path), path);
          print('Successfully uploaded personal image');
          print('URL: ${userData['userProfilePic']}');
        } catch (e) {
          print('Failed to upload personal image: $e');
        }
      }

      if (companyLogo != null) {
        String path =
            'vendorDocuments/${firebaseAuth.currentUser!.uid}/companyLogo.${companyLogo!.path.split('.').last}';
        print('Attempting to upload company logo...');
        print('Path: $path');
        print('File exists: ${await File(companyLogo!.path).exists()}');
        print('File size: ${await File(companyLogo!.path).length()} bytes');

        try {
          userData['userCompanyLogo'] =
          await _s3Service.uploadFile(File(companyLogo!.path), path);
          print('Successfully uploaded company logo');
          print('URL: ${userData['userCompanyLogo']}');
        } catch (e) {
          print('Failed to upload company logo: $e');
        }
      }

      if (isChequePayment && chequeImage != null) {
        String path =
            'vendorDocuments/${firebaseAuth.currentUser!.uid}/chequeImage.${chequeImage!.path.split('.').last}';
        print('Attempting to upload cheque image...');
        print('Path: $path');
        print('File exists: ${await chequeImage!.exists()}');
        print('File size: ${await chequeImage!.length()} bytes');

        try {
          chequeImageURL = await _s3Service.uploadFile(chequeImage!, path);
          print('Successfully uploaded cheque image');
          print('URL: $chequeImageURL');
          userData['chequeImageURL'] = chequeImageURL;
          userData['paymentMethod'] = 'cheque';
          userData['paymentStatus'] = 'pending';
        } catch (e) {
          print('Failed to upload cheque image: $e');
        }
      } else {
        userData['paymentMethod'] = 'online';
        userData['paymentStatus'] = isPaymentDone ? 'completed' : 'pending';
      }

      if (aadhaarCardImage != null) {
        String path =
            'vendorDocuments/${firebaseAuth.currentUser!.uid}/aadhaarCardImage.${aadhaarCardImage!.path.split('.').last}';
        print('Attempting to upload Aadhaar card image...');
        print('Path: $path');
        print('File exists: ${await File(aadhaarCardImage!.path).exists()}');
        print(
            'File size: ${await File(aadhaarCardImage!.path).length()} bytes');

        try {
          userData['aadhaarCardImage'] =
          await _s3Service.uploadFile(File(aadhaarCardImage!.path), path);
          print('Successfully uploaded Aadhaar card image');
          print('URL: ${userData['aadhaarCardImage']}');
        } catch (e) {
          print('Failed to upload Aadhaar card image: $e');
        }
      }

      if (panCardImage != null) {
        String path =
            'vendorDocuments/${firebaseAuth.currentUser!.uid}/panCardImage.${panCardImage!.path.split('.').last}';
        print('Attempting to upload PAN card image...');
        print('Path: $path');
        print('File exists: ${await File(panCardImage!.path).exists()}');
        print('File size: ${await File(panCardImage!.path).length()} bytes');

        try {
          userData['panCardImage'] =
          await _s3Service.uploadFile(File(panCardImage!.path), path);
          print('Successfully uploaded PAN card image');
          print('URL: ${userData['panCardImage']}');
        } catch (e) {
          print('Failed to upload PAN card image: $e');
        }
      }

      print('All file uploads completed. Proceeding with profile creation...');

      await AuthConnect().loginRegisterAccount(
          mobileNumber: mobileNumber.isEmpty
              ? firebaseAuth.currentUser!.phoneNumber!
              : mobileNumber,
          isSignUp: true,
          message: message,
          userData: userData);

      print('Profile created successfully');
      isLoading = false;
      update();

      if (isChequePayment) {
        utils.showSnackBar(
            'Registration successful! Cheque payment under review.');
      }
      await Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => const BottomNavScreen()),
            (route) => false,
      );
    } catch (e) {
      print('Profile creation error: $e');
      print('Stack trace: ${StackTrace.current}');
      isLoading = false;
      update();
    }
  }

  Future<void> pickChequeImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Compress image
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (image != null) {
        chequeImage = File(image.path);
        update();
      }
    } catch (e) {
      print('Image picking error: $e');
      utils.showSnackBar('Error selecting image. Please try again.');
    }
  }

  // Add method to reset payment method
  void resetPaymentMethod() {
    isChequePayment = false;
    chequeImage = null;
    chequeImageURL = null;
    update();
  }

  onGoogleMapTap(LatLng latLng) async {
    center = latLng;
    kGooglePlex = CameraPosition(
      target: center,
      zoom: 14.4746,
    );
    kOutlet = CameraPosition(target: center, zoom: 19.151926040649414);

    // Check if the Completer is already completed before completing it
    if (!googleMapController.isCompleted) {
      googleMapController.complete(await getGoogleMapController());
    }
    update();
  }

  Future<GoogleMapController> getGoogleMapController() async {
    final GoogleMapController controller = await googleMapController.future;
    return controller;
  }

  Future<void> changeSelectedState(String stateName) async {
    selectedState = stateName;
    var localState =
    await isar.stateColls.filter().stateNameEqualTo(stateName).findFirst();

    if (localState == null) {
      print("No state found with name: $stateName");
      return;
    }

    cityList.clear();
    var cities = await isar.cityColls
        .filter()
        .cityOfStateIDEqualTo(localState.stateID)
        .findAll();

    for (var city in cities) {
      cityList.add(city.cityName);
    }

    if (cityList.isNotEmpty) {
      selectedCity = cityList.first;
      selectedCityOfStateID = localState.stateID;
    } else {
      print("No cities found for state: $stateName");
      selectedCity = null;
      selectedCityOfStateID = null;
    }

    update();
  }

  changeSelectedCity(String city) async {
    selectedCity = city;
    update();
  }

  getStepper() {
    steps.clear();
    steps.add(Step(
        title: const Text('Personal Details'),
        subtitle: const Text('Write personal details in this section!'),
        content: Column(
          children: [
            CreateProfileStep1(
              controller: this,
              mobileNumber: '',
              countryCode: '+91',
              user: user,
            )
          ],
        ),
        state: selectedStep == 0 ? StepState.editing : StepState.complete,
        isActive: selectedStep >= 0));
    steps.add(Step(
        title: const Text('Kyc details'),
        subtitle: const Text('Write your Kyc details'),
        content: Column(
          children: [CreateProfileStep2(controller: this)],
        ),
        state: selectedStep == 1
            ? StepState.editing
            : selectedStep > 1
            ? StepState.complete
            : StepState.disabled,
        isActive: selectedStep >= 1));
    steps.add(Step(
        title: const Text('Payment'),
        subtitle: const Text(
            'You can complete payment in this section to register successfully!'),
        content: Column(
          children: [CreateProfileStep3(controller: this)],
        ),
        state: selectedStep == 2
            ? StepState.editing
            : selectedStep >= 2
            ? StepState.editing
            : StepState.disabled,
        isActive: selectedStep == 2));
    Future.delayed(
      const Duration(seconds: 1),
          () => update(),
    );
  }

  changeSelectedCompanyType(String companyType) {
    selectedTypeOfCompany = companyType;
    update();
  }

  changeSelectedGender(String gender) {
    selectedGender = gender;
    update();
  }

  // void changeSelectedTshirtSize(String? size) {
  //   selectedTshirtSize = size;
  //   update();
  // }

  onStepCancel() {
    if (selectedStep > 0) {
      selectedStep--;
      update();
    }
  }

  Future<void> onStepContinue() async {
    print('Current step: $selectedStep');
    print('Is loading: $isLoading');
    print('Email verified: ${firebaseAuth.currentUser!.emailVerified}');

    if (selectedStep < 2) {
      // Step 0 validations remain the same
      if (selectedStep == 0) {
        print('Checking step 0 validations');
        if (personalImage == null) {
          print('Personal image missing');
          utils.showSnackBar('Please attach passport size photo');
          return;
        }

        if (!firebaseAuth.currentUser!.emailVerified) {
          print('Email not verified');
          utils.showSnackBar(isVerifyEmailSent
              ? 'Open email and click on verify link!'
              : 'Send verification email and verify it!');
          return;
        }

        if (selectedCatsList.isEmpty) {
          print('Categories not selected');
          utils.showSnackBar('Category is not selected!');
          return;
        }
      }
      // Modified Step 1 validations
      if (selectedStep == 1) {
        print('Checking step 1 validations');

        // Check if GST is unregistered
        if (!isGSTRegistered) {
          // Both Aadhaar and PAN are mandatory for unregistered GST
          if (aadhaarNoEditingController.text.isEmpty ||
              aadhaarCardImage == null ||
              panNoEditingController.text.isEmpty ||
              panCardImage == null) {
            utils.showSnackBar(
                'Both Aadhaar and PAN with images are mandatory for unregistered GST');
            return;
          }
        } else {
          // For GST registered users, either Aadhaar or PAN is optional
          if (isGSTRegistered && gstEditingController.text.isEmpty) {
            utils.showSnackBar('Please enter GST number');
            return;
          }
          // Optional validation for Aadhaar/PAN if provided
          if (aadhaarNoEditingController.text.isNotEmpty &&
              aadhaarCardImage == null) {
            utils.showSnackBar('Please upload Aadhaar card image');
            return;
          }
          if (panNoEditingController.text.isNotEmpty && panCardImage == null) {
            utils.showSnackBar('Please upload PAN card image');
            return;
          }
        }
      }

      print('Progressing to next step');
      selectedStep++;
      print('New step: $selectedStep');
      isLoading = false;
      update();
    } else if (selectedStep == 2) {
      print('Handling payment step');
      if (selectedPlanCost.isEmpty) {
        utils.showSnackBar('Please select a payment plan');
        return;
      }

      if (isChequePayment) {
        if (chequeImage == null) {
          utils.showSnackBar('Please upload cheque image');
          return;
        }
      } else {
        // Online payment validation
        if (!isPaymentDone && selectedPlanCost.isNotEmpty) {
          utils.showSnackBar('Please complete the payment');
          return;
        }
      }

      isLoading = true;
      update();
      await createProfileClickHandler();
    }
  }

  onStepTapped(int index) {
    print('Attempting to tap step: $index');
    print(
        'Current form key valid: ${createProfileFormKeys[selectedStep].currentState!.validate()}');
    print('Email verified: ${firebaseAuth.currentUser!.emailVerified}');

    if (createProfileFormKeys[selectedStep].currentState!.validate() &&
        firebaseAuth.currentUser!.emailVerified) {
      selectedStep = index;
      isLoading = false; // Reset loading state on step change
      update();
      print('Successfully moved to step: $selectedStep');
    } else {
      print('Failed to move to step: $index');
    }
  }

  void sendVerificationEmail() async {
    if (emailIdEditingController.text.isEmpty) {
      utils.showSnackBar('Please enter an email address');
      return;
    }

    if (firebaseAuth.currentUser != null) {
      try {
        isLoading = true;
        update();

        // Update email only if it's different from the current email
        if (emailIdEditingController.text != firebaseAuth.currentUser?.email) {
          await firebaseAuth.currentUser
              ?.updateEmail(emailIdEditingController.text);
        }

        // Reload user to get updated email verification status
        await firebaseAuth.currentUser?.reload();

        // Check if email is already verified
        if (firebaseAuth.currentUser!.emailVerified) {
          utils.showSnackBar('Email is already verified.');
          isEmailVerified = true;
          isVerifyEmailSent = false; // Reset the flag for email sent
        } else if (isVerifyEmailSent) {
          // Check if verification email is already sent
          utils.showSnackBar(
              'Verification email already sent. Please verify your email.');
        } else {
          // Send verification email if it hasn't been sent yet
          await firebaseAuth.currentUser?.sendEmailVerification();
          utils.showSnackBar('Successfully sent verification email!');
          isVerifyEmailSent = true;
          isEmailVerified = false; // Email is not verified yet
        }
      } on FirebaseAuthException catch (e) {
        debugPrint('sendVerificationEmail catch | e | ${e.message}');
        utils.showSnackBar(e.message ?? '');
        // Handle specific error requiring recent authentication
        if (e.message != null &&
            e.message!
                .contains('sensitive and requires recent authentication')) {
          await utils.logOutUser();
        }
      } catch (e) {
        debugPrint('sendVerificationEmail catch | e | $e');
      } finally {
        isLoading = false;
        update();
      }
    }
  }

  capturePersonalImage({required bool fromCamera}) async {
    if (fromCamera) {
      personalImage = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      personalImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }

  void enableGSTTextField(bool isEnabled) {
    isGSTTextFieldEnabled = isEnabled;
    update();
    //  notifyListeners();
  }

  void updateBankAccountDetails(
      String accountNumber,
      String ifscCode,
      String bankAccountHolderAcNumber,
      String bankAccountHolderBankBranch,
      String bankAccountHolderIFSC1,
      String bankAccountHolderName) {
    bankAccountHolderAc1NumberController.text = accountNumber;
    bankAccountHolderIFSCController.text = ifscCode;
    bankAccountHolderAcNumberController.text = bankAccountHolderAcNumber;
    bankAccountHolderBankBranchController.text = bankAccountHolderBankBranch;
    bankAccountHolderIFSC1Controller.text = bankAccountHolderIFSC1;
    bankAccountHolderNameEditingController.text = bankAccountHolderName;
    update();
  }

  updatebankAccountHolderAc1NumberTxt(String bankAccountHolderAc1Number) {
    bankAccountHolderAc1Number = bankAccountHolderAc1Number;
    update();
  }

  updatebankAccountHolderIFSCTxt(String bankAccountHolderIFSC) {
    bankAccountHolderIFSC = bankAccountHolderIFSC;
    update();
  }

  updatebankAccountHolderAcNumberTxt(String bankAccountHolderAcNumber) {
    bankAccountHolderAcNumber = bankAccountHolderAcNumber;
    update();
  }

  updatebankAccountHolderBankBranchTxt(String bankAccountHolderBankBranch) {
    bankAccountHolderBankBranch = bankAccountHolderBankBranch;
    update();
  }

  updatebankAccountHolderIFSC1Txt(String bankAccountHolderIFSC1) {
    bankAccountHolderIFSC1 = bankAccountHolderIFSC1;
    update();
  }

  updatebankAccountHolderNameTxt(String bankAccountHolderName) {
    bankAccountHolderName = bankAccountHolderName;
    update();
  }

  selectPersonalImage({required bool fromCamera}) async {
    if (fromCamera) {
      personalImage = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      personalImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }

  selectOrCaptureAadhaarCardImage({required bool fromCamera}) async {
    if (fromCamera) {
      aadhaarCardImage =
      await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      aadhaarCardImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }

  Future<void> selectCompanyLogo({required bool fromCamera}) async {
    if (isImagePickerActive) {
      return; // If already active, do nothing
    }

    isImagePickerActive = true; // Set flag to active

    try {
      if (fromCamera) {
        companyLogo = await ImagePicker().pickImage(source: ImageSource.camera);
      } else {
        companyLogo =
        await ImagePicker().pickImage(source: ImageSource.gallery);
      }

      // Do something with the selected image, e.g., update UI
      update(); // Update the state
    } catch (e) {
      print("Error selecting image: $e");
    } finally {
      isImagePickerActive = false; // Reset the flag after completion
    }
  }

  selectOrCapturePanCardImage({required bool fromCamera}) async {
    if (fromCamera) {
      panCardImage = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      panCardImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }

  onAadhaarNumberChange(String aadhaarNumber) {
    if (aadhaarNumber.length == 12) {
      String aadhaarNum =
          "${aadhaarNumber.substring(0, 4)} ${aadhaarNumber.substring(4, 8)} ${aadhaarNumber.substring(8, aadhaarNumber.length)}";
      aadhaarNoEditingController.value = TextEditingValue(
          text: aadhaarNum,
          selection: TextSelection.fromPosition(
              TextPosition(offset: aadhaarNum.length)));
    } else {
      aadhaarNumber.replaceAll(" ", "");
      aadhaarNoEditingController.value = TextEditingValue(
          text: aadhaarNumber.trim(),
          selection: TextSelection.fromPosition(
              TextPosition(offset: aadhaarNumber.trim().length)));
    }
  }

  void handlePaymentSuccess() {
    isPaymentSuccessful = true;
    update(); // Update UI
  }

  void handlePaymentFailure() {
    isPaymentSuccessful = false;
    update(); // Update UI
  }

  void handlePaymentCancellation() {
    isPaymentSuccessful = false;
    update(); // Update UI
  }

  void _initializeRazorpay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          Future.delayed(const Duration(milliseconds: 200), () async {
            try {
              await PaymentConnect().paymentDoneAPI(
                selectedPlanCost: selectedPlanCost,
                userFullName: user.displayName.toString(),
                paymentType: isSubscriptionRecharge
                    ? 'subscriptionRecharge'
                    : 'subscriptionPlanRecharge',
                paymentID: response.paymentId.toString(),
                candidOfferSubscriptionEndDate: selectedPlanDurationInDays,
                selectedSubscriptionPlanOfferCount:
                selectedSubscriptionPlanOfferCount,
                selectedSubscriptionPlanId: selectedSubscriptionPlanId,
                // selectedsubscriptionPlanCost: selectedsubscriptionPlanCost,
              );
              response.paymentId = null;
              isPaymentDone = true;
              update();
              Navigator.of(navigatorKey.currentContext!).pop(true);
            } catch (e) {
              debugPrint('payment exp : $e');
            }
          });
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100.0,
                ),
                SizedBox(height: 10.0),
                Text("Payment Successful!"),
              ],
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('$e');
    }
  }

  void _handlePaymentError(
      BuildContext context, PaymentFailureResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message ?? ''),
      ),
    );
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 100.0,
              ),
              SizedBox(height: 10.0),
              Text("Payment Failed!"),
            ],
          ),
        );
      },
    );
  }

  void _handleExternalWallet(
      BuildContext context, ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.walletName ?? ''),
      ),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: Colors.blue,
                size: 100.0,
              ),
              const SizedBox(height: 10.0),
              Text(
                  "Using External Wallet: ${response.walletName ?? 'Unknown Wallet'}"),
            ],
          ),
        );
      },
    );
    _razorpay.clear();
  }

  openSession({required num amount, required String razorpayKey}) {
    createOrder(amount: amount).then((orderId) {
      if (orderId.toString().isNotEmpty) {
        var options = {
          'key': razorpayKey, // Razorpay API Key
          'amount': (amount * 100).round(),
          'name': 'Candid Offers',
          'order_id': orderId,
          'description': 'Seller Onboarding',
          'timeout': 120,
          'prefill': {
            'contact': '9978977484',
            'email': 'shekhar.priyadarshi@gmail.com',
          }
        };
        _razorpay.open(options);
      } else {
        // Handle empty orderId
      }
    });
  }

  createOrder({
    required num amount,
  }) async {
    final myData = await ApiServices().razorPayApi(amount, "rcp_id_1");
    if (myData["status"] == "success") {
      return myData["body"]["id"];
    } else {
      handlePaymentFailure(); // Handle payment failure here
      return "";
    }
  }

  @override
  Future<void> onInit() async {
    print('Controller initialized');
    print('Initial step: $selectedStep');
    // Initialize Razorpay
    _initializeRazorpay();
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    try {
      // Get current position for map
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

    isLoading = true;
    update();

    try {
      // Fetch city list, champions list, and categories in order
      await CityConnect.getCityListApi();
      await fetchChampionList();
      await CatsConnect().getCatsList();

//    storeNameController.text = '';
      companyNameEditingController.text = '';
      fullNameEditingController.text = '';
      addressLine1EditingController.text = '';
      otpEditingController.text = '';
      addressLine2EditingController.text = '';
      CompanyPanEditingController.text = '';
      addressBuildingStreetAreaEditingController.text = '';
      addressPinCodeEditingController.text = '';
      emailIdEditingController.text = '';
      panNoEditingController.text = '';
      aadhaarNoEditingController.text = '';
      gstEditingController.text = '';
      bankAccountHolderNameEditingController.text = '';
      bankAccountHolderAcNumberController.text = '';
      bankAccountHolderAc1NumberController.text = '';
      bankAccountHolderIFSCController.text = '';
      bankAccountHolderIFSC1Controller.text = '';
      bankAccountHolderBankNameController.text = '';
      bankAccountHolderBankBranchController.text = '';
      // }
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
      await changeSelectedCity(cityList.first);

      for (var category in (await isar.offersCatColls
          .filter()
          .catIDIsNotEmpty()
          .build()
          .findAll())) {
        var contain =
        catsList.where((element) => element['catName'] == category.catName);
        if (contain.isEmpty &&
            !category.catName.toLowerCase().contains('Popular'.toLowerCase())) {
          catsList.add({
            'catName': category.catName,
            'catID': category.catID,
            'catImg': category.catImg,
            'catType': category.catType
          });
        }
      }

      getStepper();
    } catch (e) {
      debugPrint('API call failed: $e');
      utils.showSnackBar('Failed to fetch data. Please try again later.');
    } finally {
      isLoading = false;
      update();
    }

    // Add listeners for validation
    panNoEditingController.addListener(() {
      if (isPanValid) {
        isPanValid = false;
        update();
      }
    });
    gstEditingController.addListener(() {
      if (isGstValid) {
        isGstValid = false;
        update();
      }
    });
  }

  Future<void> fetchChampionList() async {
    await ChampionConnect().getChampionsListApi(this);

    // Ensure a valid default value is set for selectedChampionID
    if (championList.isNotEmpty) {
      final firstChampion = championList[0].split('|');
      if (firstChampion.length >= 3) {
        selectedChampionID = firstChampion[1]; // Set default champion ID
        selectedChampionName = firstChampion[0]; // Set default champion name
        selectedChampionMobile =
        firstChampion[2]; // Set default champion mobile
      }
    }
    update();
  }

  Future<void> initializeApp() async {
    isLoading = true;
    try {
      await initializeLocation();
      await fetchData();
    } catch (e) {
      utils.showSnackBar('Error initializing app: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> initializeLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      center = LatLng(position.latitude, position.longitude);
      kGooglePlex = CameraPosition(target: center, zoom: 14.4746);
      kOutlet = CameraPosition(target: center, zoom: 19.151926040649414);
      showMap;
    } catch (e) {
      debugPrint('Permission for location catch | $e');
      utils.showSnackBar('Error getting location: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      await CityConnect.getCityListApi();
      await fetchChampionList();
      await fetchCategories();
      await CatsConnect().getCatsList();
      if (cityList.isNotEmpty) {
        await changeSelectedCity(cityList.first);
      }
    } catch (e) {
      debugPrint('API call failed: $e');
      utils.showSnackBar('Failed to fetch data. Please try again later.');
    }
  }

  Future<void> fetchCategories() async {
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        await CatsConnect().getCatsList();
        await loadCategoriesFromLocal();
        if (catsList.isNotEmpty) {
          break;
        }
        retryCount++;
      } catch (e) {
        debugPrint('Error fetching categories (Attempt ${retryCount + 1}): $e');
        await Future.delayed(
            Duration(seconds: 2 * retryCount)); // Exponential backoff
      }
    }

    if (catsList.isEmpty) {
      utils.showSnackBar(
          'Unable to load categories. Please check your internet connection and try again.');
    }
  }

  Future<void> loadCategoriesFromLocal() async {
    catsList.clear();
    var localCategories =
    await isar.offersCatColls.filter().catIDIsNotEmpty().build().findAll();
    for (var category in localCategories) {
      if (!category.catName.toLowerCase().contains('Popular'.toLowerCase())) {
        catsList.add({
          'catName': category.catName,
          'catID': category.catID,
          'catImg': category.catImg,
          'catType': category.catType
        });
      }
    }
  }

  clearOrDispose() {
    WidgetsBinding.instance.removeObserver(this);
//    storeNameController.dispose();
    companyNameEditingController.dispose();
    reenterAccountNumberController.dispose();
    reenterIfscController.dispose();
    fullNameEditingController.dispose();
    addressLine1EditingController.dispose();
    addressLine2EditingController.dispose();
    addressBuildingStreetAreaEditingController.dispose();
    gstEditingController.dispose();
    otpEditingController.dispose();
    addressPinCodeEditingController.dispose();
    emailIdEditingController.dispose();
    panNoEditingController.dispose();
    CompanyPanEditingController.dispose();
    aadhaarNoEditingController.dispose();
    bankAccountHolderNameEditingController.dispose();
    bankAccountHolderAcNumberController.dispose();
    bankAccountHolderAc1NumberController.dispose();
    bankAccountHolderIFSCController.dispose();
    bankAccountHolderIFSC1Controller.dispose();
    bankAccountHolderBankNameController.dispose();
    bankAccountHolderBankBranchController.dispose();
  }

  @override
  void dispose() {
    clearOrDispose();
    super.dispose();
  }

  @override
  void onClose() {
    clearOrDispose();
    super.onClose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        try {
          if (firebaseAuth.currentUser?.emailVerified == false) {
            isLoading = true;
            update();
            await firebaseAuth.currentUser!.reload();
            isLoading = false;
            update();
          }
        } catch (e) {
          debugPrint('didChangeAppLifecycleState | CATCH | $e');
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  List<Map<String, String>> filteredCatsList = [];

  void catsItemChange(Map<String, String> itemValue, bool isSelected,
      StateSetter setState, List<Map<String, String>> currentCatList) {
    currentCatList = selectedCatsList;
    if (isSelected) {
      currentCatList.add(itemValue);
    } else {
      currentCatList.remove(itemValue);
    }
    setState(() {});
  }

  void _cancel(StateSetter setState, List<Map<String, String>> currentCatList) {
    currentCatList = selectedCatsList;
    setState(() {});
    Navigator.pop(navigatorKey.currentContext!);
  }

  void _submit(StateSetter setState, List<Map<String, String>> currentCatList) {
    selectedCatsList = currentCatList;
    update();
    setState(() {});
    Navigator.pop(navigatorKey.currentContext!, selectedCatsList);
  }

  Future<void> showMultiSelect() async {
    if (catsList.isEmpty) {
      utils.showSnackBar(
          'No categories available. Trying to fetch categories...');
      await fetchCategories();
      if (catsList.isEmpty) {
        utils.showSnackBar(
            'Still no categories available. Please try again later.');
        return;
      }
    }
    List<Map<String, String>> currentCatList = List.from(selectedCatsList);
    int maxSelection = 4;
    final List<Map<String, String>>? results = await showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        String searchQuery = '';
        List<Map<String, String>> filteredCatsList = List.from(catsList);
        String selectedType = 'Both';
        List<String> types = ['Product', 'Service', 'Both'];

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Header
                        Container(
                          height: 20.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50.0,
                                height: 30.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFF971D),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: SizedBox(
                                  height: 60.0,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Vendor Categories",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Dropdown for selecting type
                        DropdownButtonFormField<String>(
                          value: selectedType,
                          decoration: const InputDecoration(
                            labelText: 'Select Type',
                            hintText: 'Select Type',
                            border: OutlineInputBorder(),
                          ),
                          items: types.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedType = value.toString();
                              filteredCatsList = catsList.where((item) {
                                return (selectedType == 'Both' ||
                                    item['catType'].toString().toLowerCase() ==
                                        selectedType.toString().toLowerCase());
                              }).toList();
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          onChanged: (query) {
                            setState(() {
                              searchQuery = query;
                              filteredCatsList = catsList.where((item) {
                                final catName = item['catName']!.toLowerCase();
                                return catName
                                    .contains(searchQuery.toLowerCase()) &&
                                    (selectedType == 'Both' ||
                                        item['catType']
                                            .toString()
                                            .toLowerCase() ==
                                            selectedType
                                                .toString()
                                                .toLowerCase());
                              }).toList();
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Search here!',
                            hintText: 'Search here!',
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Vendor Category',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Column(
                              children: filteredCatsList.map((item) {
                                final bool isSelected =
                                currentCatList.contains(item);
                                return CheckboxListTile(
                                  value: isSelected,
                                  title: Text(
                                    item['catName']!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  controlAffinity:
                                  ListTileControlAffinity.leading,
                                  onChanged: (isChecked) {
                                    setState(() {
                                      if (isChecked != null) {
                                        if (isChecked) {
                                          if (currentCatList.length <
                                              maxSelection) {
                                            currentCatList.add(item);
                                          } else {
                                            // Show alert or message indicating the maximum selection limit
                                          }
                                        } else {
                                          currentCatList.remove(item);
                                        }
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                            // Action buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      _cancel(setState, currentCatList),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      _submit(setState, currentCatList),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: const Text('Submit'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (results != null) {
      selectedCatsList = results;
      update();
    }
  }

  // Add a computed property to get only Champion type champions
  List<String> get championTypeChampions {
    return championList.where((champion) {
      final parts = champion.split('|');
      // Assuming the champion type is stored in the name part
      // You might need to adjust this based on your actual data structure
      return parts.length > 0 && parts[0].contains('Champion');
    }).toList();
  }

  // Modify the method that handles champion selection
  void onChampionSelected(String championId) {
    // Find the selected champion from the list
    final champion = championList.firstWhere(
          (c) => c.split('|')[1] == championId, // Match by ID
      orElse: () => '',
    );

    if (champion.isNotEmpty) {
      // Split the selected champion data
      final parts = champion.split('|');
      if (parts.length >= 3) {
        selectedChampionID = parts[1]; // Set the champion ID
        selectedChampionName = parts[0]; // Set the champion name
        selectedChampionMobile = parts[2]; // Set the champion mobile number
        update(); // Trigger UI update
      } else {
        utils.showSnackBar('Invalid champion data. Please try again.');
      }
    } else {
      utils.showSnackBar('Champion not found. Please select a valid champion.');
    }
  }
}
