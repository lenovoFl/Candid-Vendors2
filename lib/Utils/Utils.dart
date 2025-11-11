import 'dart:async';
import 'dart:isolate';

import 'package:candid_vendors/Screens/AuthScreens/LoginScreen.dart';
import 'package:candid_vendors/Services/APIs/Auth/UpdateProfile.dart';
import 'package:candid_vendors/Services/Collections/App/AppDataColl.dart';
import 'package:candid_vendors/Services/Collections/City/CityColl.dart';
import 'package:candid_vendors/Services/Collections/Notification/NotificationColl.dart';
import 'package:candid_vendors/Services/Collections/Offers/OfferHistory/OfferHistoryColl.dart';
import 'package:candid_vendors/Services/Collections/Offers/OffersCat/OffersCatColl.dart';
import 'package:candid_vendors/Services/Collections/Plans/PlansColl.dart';
import 'package:candid_vendors/Services/Collections/Policy/PolicyColl.dart';
import 'package:candid_vendors/Services/Collections/State/StateColl.dart';
import 'package:candid_vendors/Services/Collections/User/VendorUserColl.dart';
import 'package:candid_vendors/Services/Collections/VendorPolicy/VendorPolicyColl.dart';
import 'package:candid_vendors/main.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../Controllers/Notification/NotificationController.dart';
import '../Services/APIs/City/CityConnect.dart';
import '../Services/APIs/Notification/NotificationConnect.dart';
import '../Services/APIs/Offers/OffersConnect.dart';
import '../Services/Collections/Account/AccountData.dart';
import '../Services/Collections/Store/StoreColl.dart';
import '../firebase_options.dart';

class Utils {
  // run command to use firebase localhost api - adb reverse tcp:5001 tcp:5001
  static String apiUrl =
      'https://us-central1-candid-cf9fc.cloudfunctions.net/app';
  static String apiUrl1 = 'https://us-central1-candid-cf9fc.cloudfunctions.net';
  static String docVerifyUrl = 'https://vpays.in/VGDocverify/VGKVerify.asmx';

  // flutter build apk --split-per-abi

  // !kDebugMode
  //     ? 'http://127.0.0.1:5001/candid-cf9fc/us-central1/app'
  //     :
  // 'https://us-central1-candid-cf9fc.cloudfunctions.net/app';

  // add state & city in profile
  // not hiding offers list in dashboard when come back to home screen / dashboard

  // GUMASTA , COMPANY'S PAN
  // CITY WISE OFFERS
  // LOCAL OR GLOBAL MARKET NEEDS TO BE CHOSEN
  // TILL THE DATE OFFER IS VALID ,AFTER THE END DATE OF THE OFFER VALIDITY OFFER CANT BE USED
  // DIFFERENT QR CODE FOR NORMAL CUSTOMERS AND PRIME CUSTOMERS

  // sending messages are done only for welcome and payment is done,
  // before 1 week when plan about to completed others are pending, sending emails are pending.

  // REPORTs for offer wallet, offerwise report, prime customer report, etc.
  // 3. BANNERS ( CITY WISE )
  // MoM - 21-06-23
  //
  // 1. In vendor onboarding, T&C should be visible.
  // 3. Product description:
  // Details about the product
  // or Call for details
  // 4. Under offer description
  // -- T&C :
  // a. Warranty
  // b. Refund
  // c. Payment
  // d. Delivery (COD)
  // e. Call for details
  // In above Product Discription points "call for details" option should be there.
  // 5. Offer ID and QR code should be generated after creating every offer.
  // 7. Preview of offer should be there with images & TC.
  // 8. UI needs to be improved.
  // 13. Wallet of vendor is not visible.
  // 14.how will vendor Recharge it's wallet.
  // 15. Reports ( offer wallet reports, prime customers reports,offer wise reports)

  // Hi Team,
  //
  //     Please find the UAT credentials to test BillDesk – Flutter SDK
  // UAT Merchant ID: V2UATBDSK
  // UAT Client ID: v2uatbdsk
  // UAT secret key: sharing separately with @'Shekhar Priyadarshi'
  //
  // Please find attached Flutter kit, comprising of the codes required to include in your Flutter folder, API Specification document for Flutter.
  // Kindly note: Please do not use the API endpoint URLs mentioned in the document, use the below mentioned:
  //
  // Create Order API: https://pguat.billdesk.io/payments/ve1_2/orders/create
  // Retrieve Transaction API: https://pguat.billdesk.io/payments/ve1_2/transactions/get
  // Create Refund API: https://pguat.billdesk.io/payments/ve1_2/refunds/create
  // Retrieve Refund API: https://pguat.billdesk.io/payments/ve1_2/refunds/get
  // Secret key: 4tYLuOm3JHGafrcbHba7szuT9q0JdpXk

  // Update the constants
  static const String userId = "15";
  static const String verificationKey = "CAD072015AC";
  static const String bankShortCode = "CADENCE";
  static const String bankName = "CADENCE ACADEMY NAGPUR";
  static const String accessKey = "cb427c6e-f6b9-477b-9875-2c26c15a80cb";
  static const String caseId = "13012025171958";

  Future getUser({Isar? isarDB}) async {
    if (isarDB != null) {
      return await isarDB.vendorUserColls.buildQuery().findFirst();
    }
    return await isar.vendorUserColls.buildQuery().findFirst();
  }

  void showSnackBar(String message) {
    if (Get.context != null) {
      Get.snackbar(
        'Seller Store',
        message,
        backgroundColor:
            const Color(0xFF1E1A47), // Dark blue/purple background color
        colorText: const Color(0xFF00B4D8), // Teal text color
        duration: const Duration(
            milliseconds: 3000), // Shorter duration for quicker notifications
        snackPosition: SnackPosition.BOTTOM, // Position at the bottom
        borderRadius: 8, // Rounded corners
        margin: const EdgeInsets.all(10), // Margin around the snackbar
        animationDuration:
            const Duration(milliseconds: 500), // Animation duration
        isDismissible: true, // Dismissible by swipe
        forwardAnimationCurve:
            Curves.easeOutBack, // Animation curve for appearing
        reverseAnimationCurve:
            Curves.easeInBack, // Animation curve for disappearing
        mainButton: TextButton(
          onPressed: () {
            // Handle button press
            Get.back(); // Close the snackbar
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, // Button text color
          ),
          child: const Text(
            'OK',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ), // Add a button to dismiss the snackbar
        icon: const Icon(Icons.notification_important,
            color: Colors.white), // Add an icon
      );
    } else {
      debugPrint('Context is null. Unable to show SnackBar.');
    }
  }

  validatePass(String userPass, String? userPassForConfirmPassValidation) {
    if (userPass.isEmpty) {
      return 'Password is required';
    } else if (!RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(userPass)) {
      return 'Please enter valid password with at lease 1 capital, small, digit, special symbol like (@#&)';
    } else if (userPassForConfirmPassValidation != null &&
        userPassForConfirmPassValidation.isNotEmpty) {
      if (userPass != userPassForConfirmPassValidation) {
        return 'Password and confirm password is not same';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  validateEmail(String userEmail) {
    if (userEmail.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(userEmail)) {
      return 'Please enter valid email';
    } else {
      return null;
    }
  }

  validateGSTNumber(String gstNumber) {
    if (gstNumber.isEmpty) {
      return null;
    } else if (!RegExp(
            "^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}\$")
        .hasMatch(gstNumber)) {
      return 'Please enter valid gst number';
    } else {
      return null;
    }
  }

  String? validateAadhaarNumber(String aadhaarNumber) {
    if (aadhaarNumber.isEmpty) {
      return 'Aadhaar number is required!';
    } else if (!RegExp("^[2-9]{1}[0-9]{11}\$")
        .hasMatch(aadhaarNumber.replaceAll(' ', ''))) {
      return 'Please enter valid Aadhaar number!';
    } else {
      return null;
    }
  }

  validateAadhaarotpNumber(String aadharotpNumber) {
    if (aadharotpNumber.isEmpty) {
      return 'otp is required!';
    } else if (!RegExp(r'^[0-9]{6}$').hasMatch(aadharotpNumber)) {
      return 'Please enter valid otp number!';
    } else {
      return null;
    }
  }

  validatePanNumber(String panNumber) {
    if (panNumber.isEmpty) {
      return null;
    } else if (!RegExp("[A-Z]{5}[0-9]{4}[A-Z]{1}").hasMatch(panNumber)) {
      return 'Please enter valid pan number';
    } else {
      return null;
    }
  }

  validateCompanyPan(String CompanyPan) {
    if (CompanyPan.isEmpty) {
      return null;
    } else if (!RegExp("[A-Z]{5}[0-9]{4}[A-Z]{1}").hasMatch(CompanyPan)) {
      return 'Please enter valid Company pan number';
    } else {
      return null;
    }
  }

  validateBankAccountNumber(
      String bankAccountNumber, String? bankAccountNumber1) {
    if (bankAccountNumber.isEmpty) {
      return 'Bank account number is required!';
    } else if (!RegExp("^[0-9]{9,18}\$").hasMatch(bankAccountNumber)) {
      return 'Please enter valid bank account number!';
    } else if (bankAccountNumber1 != null && bankAccountNumber1.isNotEmpty) {
      if (bankAccountNumber != bankAccountNumber1) {
        return 'Both bank account number are not same!';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  validateBankIFSCCode(String bankIFSCCode, String? bankIFSCCode1) {
    if (bankIFSCCode.isEmpty) {
      return 'Bank IFSC code is required!';
    } else if (!RegExp("^[A-Z]{4}0[A-Z0-9]{6}\$").hasMatch(bankIFSCCode)) {
      return 'Please enter valid IFSC code';
    } else if (bankIFSCCode1 != null && bankIFSCCode1.isNotEmpty) {
      if (bankIFSCCode != bankIFSCCode1) {
        return 'Both bank account number are not same!';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  validateTextAddress(String address) {
    if (address.isEmpty) {
      return 'Please enter something';
    } else if (address.length < 10) {
      return 'Minimum, Enter 10 letters required';
    }
    return null;
  }

  validateText({required String string, required bool required}) {
    if (string.isEmpty) {
      if (required) {
        return 'Please enter something';
      } else {
        return null;
      }
    } else if (string.length < 3) {
      return 'Minimum, Enter 3 letters required';
    }
    return null;
  }

  validateMobileNumber(String mobileNumber) {
    if (mobileNumber.isEmpty) {
      return 'Please enter 10 digit mobile number';
    } else if (mobileNumber.length < 10) {
      return 'Enter 10 digit';
    }
    return null;
  }

  validateOfferName(String offerName) {
    if (offerName.isEmpty) {
      return 'Please enter Offer Name';
    } else if (offerName.length < 5) {
      return 'Min five letter for Offer Name';
    }
    return null;
  }

  validatedescribeDealDetails(String describeDealDetails) {
    if (describeDealDetails.isEmpty) {
      return 'Please enter  describeDealDetails';
    } else if (describeDealDetails.length < 5) {
      return 'Min five letter for  describeDealDetails';
    }
    return null;
  }

  validatewarranty(String warranty) {
    if (warranty.isEmpty) {
      return 'Please enter warranty';
    } else if (warranty.length < 5) {
      return 'Min five letter for warranty';
    }
    return null;
  }

  validaterefund(String refund) {
    if (refund.isEmpty) {
      return 'Please enter refund';
    } else if (refund.length < 5) {
      return 'Min five letter for  refund';
    }
    return null;
  }

  validatedelivery(String delivery) {
    if (delivery.isEmpty) {
      return 'Please enter delivery';
    } else if (delivery.length < 5) {
      return 'Min five letter for delivery';
    }
    return null;
  }

  validateCOD(String COD) {
    if (COD.isEmpty) {
      return 'Please enter  COD';
    } else if (COD.length < 5) {
      return 'Min five letter for  COD';
    }
    return null;
  }

  validateother(String other) {
    if (other.isEmpty) {
      return 'Please enter other';
    } else if (other.length < 5) {
      return 'Min five letter for other';
    }
    return null;
  }

  String? validatemaxNumClaims(String maxNumClaims) {
    if (maxNumClaims.isEmpty) {
      return 'Please enter maxNumClaims';
    }
    return null;
  }

  validatestepsToRedeem(String stepsToRedeem) {
    if (stepsToRedeem.isEmpty) {
      return 'Please enter stepsToRedeem';
    } else if (stepsToRedeem.length < 5) {
      return 'Min five letter for stepsToRedeem ';
    }
    return null;
  }

  validateOfferPrimeDiscount(String offerPrimeDiscount, String offerDiscount) {
    if (offerPrimeDiscount.isEmpty) {
      return 'Please enter prime discount!';
    } else if (int.parse(offerPrimeDiscount) < int.parse(offerDiscount)) {
      return "Prime discount less then discount!";
    }
    return null;
  }

  validateOfferDiscount(String offerDiscount) {
    if (offerDiscount.isEmpty) {
      return 'Please enter discount!';
    }
    return null;
  }

  validateProductName(String productName) {
    if (productName.isEmpty) {
      return 'Please enter Product Name';
    } else if (productName.length < 5) {
      return 'Min five letter for Product Name';
    }
    return null;
  }

  validateProductDescription(String productDescription) {
    if (productDescription.isEmpty) {
      return 'Please enter Product Description';
    } else if (productDescription.length < 5) {
      return 'Min five letter for Product Description';
    }
    return null;
  }

  validateOfferPrimeOffer(String offerPrimeOffer) {
    if (offerPrimeOffer.isEmpty) {
      return 'Please enter Offer Prime';
    } else if (offerPrimeOffer.length < 5) {
      return 'Min five letter for Offer Prime';
    }
    return null;
  }

  validateOfferDescription(String offerDescription) {
    if (offerDescription.isEmpty) {
      return 'Please enter Offer Description';
    } else if (offerDescription.length < 10) {
      return 'Min ten letter Offer Description';
    }
    return null;
  }

  logOutUser() async {
    try {
      await firebaseAuth.signOut();
      await isar.writeTxn(() async => await isar.clear());
      showSnackBar('Logout Or Session got expired!');
      await Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('logOutUser: CATCH: $e');
    }
  }

  initRunCode() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Ensure Firebase is initialized
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    Get.put(NotificationController());
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // await dotenv.load(fileName: ".env");
    //Assign publishable key to flutter_stripe
    //Stripe.publishableKey = dotenv.env['STRIPE_TEST_PublishableKey']!;
    await firebaseAppCheck.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.appAttestWithDeviceCheckFallback,
        webProvider: ReCaptchaEnterpriseProvider('recaptcha-v3-site-key'));
    await firebaseCrashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
    await firebasePerformance.setPerformanceCollectionEnabled(!kDebugMode);
    FlutterError.onError = (errorDetails) {
      FlutterError.presentError(errorDetails);
      firebaseCrashlytics.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      firebaseCrashlytics.recordError(error, stack, fatal: true);
      return true;
    };
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await firebaseCrashlytics.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
        fatal: true,
      );
    }).sendPort);
    dir = (await getApplicationDocumentsDirectory());
    isar = await Isar.open([
      VendorUserCollSchema,
      OfferHistoryCollSchema,
      AccountCollSchema,
      OffersCatCollSchema,
      PlansCollSchema,
      StoreCollSchema,
      StateCollSchema,
      CityCollSchema,
      AppDataCollSchema,
      PolicyCollSchema,
      VendorPolicyCollSchema,
      NotificationCollSchema
    ], directory: !kIsWeb ? dir.path : ' ');
    try {
      if (kDebugMode) {
        // await firebaseAuth.useAuthEmulator("localhost", 9099);
        // await firebaseStorage.useStorageEmulator('10.0.2.2', 9199);
        // await utils.logOutUser();
      }
      await firebaseAuth.currentUser?.reload();
      await firebaseCrashlytics
          .setUserIdentifier(firebaseAuth.currentUser?.uid ?? "");
    } on FirebaseAuthException catch (e) {
      debugPrint('USE EMEmulator: AUTH | CATCH: E: $e');
      if (e.code == 'firebase_auth/user-not-found' ||
          e.message!.contains('There is no user record corresponding')) {
        await utils.logOutUser();
      }
    }
    try {
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      debugPrint('User granted permission: ${settings.authorizationStatus}');
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        firebaseMessaging.onTokenRefresh.listen((String token) async {
          if (firebaseAuth.currentUser != null) {
            await UpdateProfile().updateProfileApi(
                isProfileImgUpdateOnly: false,
                userData: {'firebaseMessagingToken': token});
          }
        });

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          debugPrint('Got a message whilst in the foreground!');
          debugPrint('Message data: ${message.data}');

          if (message.notification != null) {
            debugPrint(
                'Message also contained a notification: ${message.notification}');
          }
        });
        FirebaseMessaging.onBackgroundMessage(
            _firebaseMessagingBackgroundHandler);
        await runWhenInitOrLoggedIn();
      }
    } catch (e) {
      debugPrint('INIT USE EMEmulator: CATCH: E: $e');
    }
  }

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  Future<Map<String, String>> getHeaders() async {
    try {
      // Uncomment this section if you want to get the appCheckToken
      // final appCheckToken = await firebaseAppCheck.getToken(true);
      // debugPrint('appCheckToken : $appCheckToken');
    } catch (e) {
      // debugPrint('getHeaders catch | E | $e');
    }

    // Uncomment this section if you want to check appCheckToken before proceeding
    // if (appCheckToken != null) {

    // Assuming you have declared `isar` and `firebaseAuth` somewhere in your code
    List<AppDataColl> list = await isar.appDataColls.where().findAll();

    // Logging user phone number
    // debugPrint('User Phone Number: ${firebaseAuth.currentUser?.phoneNumber ?? ''}');

    // Logging session cookie if list is not empty
    // debugPrint('Session Cookie: ${list.isNotEmpty ? list[0].sessionCookie : ''}');

    // Logging userIdToken
    String? userIdToken = await firebaseAuth.currentUser?.getIdToken();
    // debugPrint('User ID Token: $userIdToken');

    // Constructing headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer $appCheckToken',
      // 'X-Firebase-AppCheck': appCheckToken,
      'userIdToken': userIdToken ?? '',
      'userPhone': firebaseAuth.currentUser?.phoneNumber ?? '',
      'sessionCookie': list.isNotEmpty ? list[0].sessionCookie : '',
      // 'appId': firebaseAuth.app.options.appId,
      'isVendor': 'true',
    };

    // Print headers
    // debugPrint('Headers:');
    headers.forEach((key, value) {
      // debugPrint('$key: $value');
    });

    return headers;
    // } else {
    //   debugPrint("Error: couldn't get an App Check token.");
    //   return {
    //     'Content-Type': 'application/json',
    //     'Accept': 'application/json',
    //     'isVendor': 'true',
    //   };
    // }
  }

  static getHeaders1(Isar isar, VendorUserColl? localSeller, String token,
      AppDataColl localAppData) async {
    // List<AppDataColl> list = await isar.appDataColls.where().findAll();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer $appCheckToken',
      // 'X-Firebase-AppCheck': appCheckToken,
      'userPhone': localSeller?.userMobile1 ?? "",
      'sessionCookie': localAppData.sessionCookie ?? '',
      'userIdToken': token,
      // 'appId': firebaseAuth.app.options.appId,
      'isVendor': 'true',
    };
  }

  static getToken() async {
    return (await firebaseAuth.currentUser?.getIdToken()) ?? '';
  }

  runWhenInitOrLoggedIn() async {
    debugPrint('firebaseAuth.currentUser +== : ${firebaseAuth.currentUser}');
    try {
      firebaseAuth.authStateChanges().listen((User? user) async {
        if (user != null) {
          debugPrint('firebaseAuth.authStateChanges CALLED!');
          try {
            localSeller = (await isar.vendorUserColls
                .filter()
                .userIdEqualTo(firebaseAuth.currentUser!.uid)
                .build()
                .findFirst())!;
            localAppData =
                (await isar.appDataColls.where().build().findFirst())!;
            OffersConnect.getOfferHistoryApi();

            NotificationConnect.getVendorNotificationsApi(
                localSeller, localAppData);
          } catch (e) {
            debugPrint('firebaseAuth.authStateChanges TRY CATCH | $e');
          }
          CityConnect.getCityListApi();
          isar.vendorUserColls
              .filter()
              .userIdEqualTo(firebaseAuth.currentUser!.uid)
              .build()
              .watch(fireImmediately: true)
              .listen((users) {
            if (users.isNotEmpty) {
              localSeller = users.first;
            }
          });
          isar.appDataColls
              .where()
              .watch(fireImmediately: true)
              .listen((appDataList) {
            if (appDataList.isNotEmpty) {
              localAppData = appDataList.first;
            }
          });
          debugPrint('runWhenInitOrLoggedIn TRY DONE!');
        }
      });
    } catch (e) {
      return throw e.toString();
    }
  }

  getDocVerifyHeaders() {
    return {
      'Content-Type': 'application/json',
    };
  }

  Map<String, String> extractLocationAndAddress(String address) {
    final parts = address.split(', ');

    final locationInfo = {
      'city': parts[parts.length - 3],
      'state': parts[parts.length - 2],
      'pinCode': parts[parts.length - 1],
    };

    final addressInfo = {
      'addressLine1': parts[0],
      'addressLine2': parts[1],
      'addressLine3': parts.sublist(4, parts.length - 3).join(', '),
    };

    locationInfo.addAll(addressInfo);
    return locationInfo;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  debugPrint("Handling a background message: ${message.messageId}");
}

extension Utility on BuildContext {
  void nextEditableTextFocus() {
    do {
      FocusScope.of(this).nextFocus();
    } while (
        FocusScope.of(this).focusedChild?.context?.widget is! EditableText);
  }
}
