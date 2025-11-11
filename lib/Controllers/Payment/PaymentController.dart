
import 'package:candid_vendors/RazorpayKey/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../Services/APIs/Payment/PaymentConnect.dart';
import '../../Services/APIs/Payment/razorpayPaymentconnect.dart';
import '../../Services/Collections/Plans/PlansColl.dart';
import '../../Services/Collections/User/VendorUserColl.dart';
import '../../main.dart';
import '../Notification/NotificationController.dart';


class PaymentController extends GetxController {
  final Razorpay _razorpay = Razorpay();
  String razorpayKey = "rzp_live_mXMqD6Uq31IPNc";
  String razorpaySecret = "R31iM3MZyxPQdBtNmAPF4s9V";
 // final razorPayKey = dotenv.get("RAZOR_KEY");
  //final razorPaySecret = dotenv.get("RAZOR_SECRET");
  bool isPaymentDone = false,
      isLoading = true,
      isSubscriptionRecharge = true;
  String selectedPlanCost = '',
      selectedPlanDurationInDays = '',
      selectedSubscriptionPlanStartDate = '',
      selectedSubscriptionPlanEndDate = '',
      selectedSubscriptionPlanId = '';
  String selectedsubscriptionPlanCost = '';
  String savings = '';
  Map<String, dynamic>? paymentIntent;
  late VendorUserColl vendor;
  int selectedSubscriptionPlanOfferCount = 0;

  @override
  Future<void> onInit() async {
    vendor = (await utils.getUser() as VendorUserColl);
    _initializeRazorpay();
    super.onInit();
  }

  void selectPlan(PlansColl plan) {
    selectedPlanCost = (int.parse(plan.subscriptionPlanCost) * 1.18).toStringAsFixed(2);
    selectedsubscriptionPlanCost = selectedPlanCost;
    selectedSubscriptionPlanOfferCount = plan.subscriptionPlanOfferCount;
    selectedSubscriptionPlanId = plan.subscriptionPlanID;
    selectedPlanDurationInDays = ''; // Set this if needed based on your logic
    update();
  }

  void updateSelectedPlanCost(String cost) {
    selectedPlanCost = cost;
    selectedsubscriptionPlanCost = cost; // Set both properties
    debugPrint("Selected Plan Cost: $selectedPlanCost");
    update();
  }

  void updateSelectedsubscriptionPlanCost(String cost) {
    selectedPlanCost = cost;
    selectedsubscriptionPlanCost = cost; // Set both properties
    debugPrint("selectedsubscriptionPlanCost: $selectedsubscriptionPlanCost");
    update();
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
        barrierDismissible: false,  // Prevent dismissing while processing
        builder: (context) {
          Future.delayed(const Duration(milliseconds: 200), () async {
            try {
              // Ensure selectedPlanDurationInDays is a valid number
              String durationInDays;
              try {
                // If it's already a number string, use it directly
                int.parse(selectedPlanDurationInDays); // Validate the string
                durationInDays = selectedPlanDurationInDays;
              } catch (e) {
                // If parsing fails, default to a reasonable value
                debugPrint('Invalid duration format: $selectedPlanDurationInDays');
                durationInDays = '30'; // Default to 30 days or adjust as needed
              }

              // Ensure selectedSubscriptionPlanId is not empty for plan recharge
              String planId = selectedSubscriptionPlanId;
              if (!isSubscriptionRecharge && (planId.isEmpty || planId == '/')) {
                throw Exception('Invalid subscription plan ID');
              }

              // Validate paymentId
              if (response.paymentId == null || response.paymentId!.isEmpty) {
                throw Exception('Invalid payment ID received');
              }

              await PaymentConnect().paymentDoneAPI(
                selectedPlanCost: selectedPlanCost,
                userFullName: vendor.userFullName,
                paymentType: isSubscriptionRecharge ? 'subscriptionRecharge' : 'subscriptionPlanRecharge',
                paymentID: response.paymentId!,
                candidOfferSubscriptionEndDate: durationInDays,
                selectedSubscriptionPlanOfferCount: selectedSubscriptionPlanOfferCount,
                selectedSubscriptionPlanId: planId,
              );

              response.paymentId = null;
              isPaymentDone = true;
              update();

              // Show success message
              NotificationController notificationController = Get.find();
              notificationController.triggerRechargeNotification();

              // Close the loading dialog
              if (navigatorKey.currentContext != null) {
                Navigator.of(navigatorKey.currentContext!).pop(true);
              }
            } catch (e) {
              debugPrint('Payment processing error: $e');
              // Close the loading dialog
              if (navigatorKey.currentContext != null) {
                Navigator.of(navigatorKey.currentContext!).pop();
              }
              // Show error message to user
              Get.snackbar(
                'Error',
                'Payment processing failed. Please try again or contact support.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          });

          // Show loading/success dialog
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
                SizedBox(height: 10.0),
                Text(
                  "Processing your payment...",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Dialog error: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _handlePaymentError(BuildContext context, PaymentFailureResponse response) async {
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

  void _handleExternalWallet(BuildContext context, ExternalWalletResponse response) {
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
              Text("Using External Wallet: ${response.walletName ?? 'Unknown Wallet'}"),
            ],
          ),
        );
      },
    );
    _razorpay.clear();
  }

  // Future<void> openSession({required num amount, required String razorpayKey}) async {
  //   try {
  //     String orderId = await createOrder(amount: amount);
  //
  //     if (orderId.isNotEmpty) {
  //       var options = {
  //         'key': razorpayKey,
  //         'amount': ((double.parse(selectedPlanCost.isEmpty ? '0' : selectedPlanCost) +
  //             double.parse(selectedsubscriptionPlanCost.isEmpty ? '0' : selectedsubscriptionPlanCost)) * 100).round(),
  //         'name': 'Candid Offers',
  //         'order_id': orderId,
  //         'description': 'Customer wallet recharge',
  //         'timeout': 120,
  //         'prefill': {
  //           'contact': vendor.userMobile1,
  //           'email': vendor.userEmail1,
  //         },
  //         'external': {
  //           'wallets': ['googlepay'],
  //         },
  //       };
  //
  //       _razorpay.open(options);
  //     } else {
  //       throw Exception('Failed to create order');
  //     }
  //   } catch (e) {
  //     print("Error during Razorpay checkout: $e");
  //     // Handle the error appropriately, maybe show a dialog to the user
  //   }
  // }

  Future<void> openSession({required num amount, required String razorpayKey}) async {
    try {
      String orderId = await createOrder(amount: amount);

      if (orderId.isNotEmpty) {
        var options = {
          'key': razorpayKey,
          'amount': amount * 100, // Razorpay expects amount in paise
          'name': 'Candid Offers',
          'order_id': orderId,
          'description': 'Customer wallet recharge',
          'timeout': 120,
          'prefill': {
            'contact': vendor.userMobile1,
            'email': vendor.userEmail1,
          },
          'external': {
            'wallets': ['googlepay'],
          },
        };

        _razorpay.open(options);
      } else {
        throw Exception('Failed to create order: Empty order ID received');
      }
    } catch (e) {
      print("Error during Razorpay checkout: $e");
      _showErrorDialog('Failed to initiate payment: $e');
    }
  }

  Future<String> createOrder({required num amount}) async {
    try {
      final myData = await ApiServices().razorPayApi(amount, "rcp_id_1");
      print("API Response: ${json.encode(myData)}");  // Log the full API response

      if (myData["status"] == "success") {
        return myData["body"]["id"];
      } else {
        print("API Error Details: ${myData['error'] ?? 'No error details provided'}");
        throw Exception('API returned unsuccessful status: ${myData["status"]}. Error: ${myData['error'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print("Error creating order: $e");
      rethrow;  // Re-throw the exception to be caught in openSession
    }
  }
  void _showErrorDialog(String message) {
    // Implement this method to show an error dialog to the user
    // You might want to use a state management solution or pass a callback
    // to show this dialog in your UI
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }



//  void _handlePaymentSuccess(PaymentSuccessResponse response) {
  // Handle payment success
  //   print('Payment Success: ${response.paymentId}');
  // Implement your logic here
  //}
  //displayPaymentSheet() async {
//    try {
  //  debugPrint("Selected Subscription Plan Cost before payment: ${selectedsubscriptionPlanCost}");
  //   var options = {
  //     'key': razorPayKey, // Replace with your actual test API key
  ////    'amount': (double.parse(selectedPlanCost) * 100).round(),
  //    'name': 'Candid Offers',
  //    'description': 'Payment for a service',
  ////  'prefill': {
  //    'contact': vendor.userMobile1,
  //     'email': vendor.userEmail1,
  //    },
  //     'external': {
  //         'wallets': ['googlepay'],
  //   },
  //  };
  //   _razorpay.open(options);
  //  update();
  //   } catch (e) {
  //     debugPrint('$e');
  //   }
//  }

 // displayPaymentSheet() async {
 //
 //     await stripe.Stripe.instance.presentPaymentSheet().then((value) async {
 //       debugPrint('paymentIntent : $paymentIntent');
 //       showDialog(
 //           context: navigatorKey.currentContext!,
 //           builder: (context) {
 //             Future.delayed(const Duration(milliseconds: 200), () async {
 //               try {
 //                 await PaymentConnect().paymentDoneAPI(
 //                     selectedPlanCost: selectedPlanCost,
 //                     userFullName: vendor.userFullName,
 //                     paymentType: isSubscriptionRecharge
 //                         ? 'subscriptionRecharge'
 //                         : 'subscriptionPlanRecharge',
 //                     paymentID: paymentIntent!['id'],
 //                     candidOfferSubscriptionEndDate: selectedPlanDurationInDays,
 //                     selectedSubscriptionPlanOfferCount:
 //                     selectedSubscriptionPlanOfferCount,
 //                     selectedSubscriptionPlanId: selectedSubscriptionPlanId,
 //                     selectedsubscriptionPlanCost: selectedsubscriptionPlanCost);
 //                 paymentIntent = null;
 //                 isPaymentDone = true;
 //                 update();
 //                 Navigator.of(navigatorKey.currentContext!).pop(true);
 //               } catch (e) {
 //                 debugPrint('payment exp : $e');
 //               }
 //             });
 //             return const AlertDialog(
 //               content: Column(
 //                 mainAxisSize: MainAxisSize.min,
 //                 children: [
 //                   Icon(
 //                     Icons.check_circle,
 //                     color: Colors.green,
 //                     size: 100.0,
 //                   ),
 //                   SizedBox(height: 10.0),
 //                   Text("Payment Successful!"),
 //                 ],
 //               ),
 //             );
 //           });
 //     }
 //     );
 //  }
 //


  // Future<void> makePayment() async {
  //   if (!isSubscriptionRecharge &&
  //       selectedSubscriptionPlanStartDate.isNotEmpty &&
  //       selectedSubscriptionPlanStartDate.length > 1 &&
  //       selectedSubscriptionPlanEndDate.isNotEmpty &&
  //       selectedSubscriptionPlanEndDate.length > 1) {
  //     selectedPlanDurationInDays = DateTime.parse(selectedSubscriptionPlanEndDate)
  //         .difference(DateTime.parse(selectedSubscriptionPlanStartDate))
  //         .inDays
  //         .toString();
  //     update();
  //   }
  //
  //   if (selectedPlanCost.isEmpty || selectedPlanCost.length < 2) {
  //     utils.showSnackBar('Please select any plan for payment!');
  //     return;
  //   }
  //
  //   try {
  //     // Determine whether it's a subscription plan or regular plan
  //     bool isSubscriptionPlan = isSubscriptionRecharge &&
  //         selectedSubscriptionPlanStartDate.isNotEmpty &&
  //         selectedSubscriptionPlanEndDate.isNotEmpty;
  //
  //     // Get the payment amount based on the type of plan
  //     String paymentAmount = isSubscriptionPlan ? selectedsubscriptionPlanCost : selectedPlanCost;
  //     debugPrint("Payment Amount: $paymentAmount");
  //
  //     // Convert paymentAmount to a numeric type (double)
  //     double numericPaymentAmount = double.parse(paymentAmount);
  //
  //     // STEP 1: Create Payment Intent
  //     paymentIntent = await PaymentConnect().createPaymentIntent(
  //         numericPaymentAmount.toInt().toString(), 'INR', (firebaseAuth.currentUser?.email ?? vendor.userEmail1) as num, 'receiptId');
  //
  //     // STEP 2: Initialize Payment Sheet
  //     await stripe.Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: stripe.SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntent!['client_secret'],
  //         //Gotten from payment intent
  //         style: ThemeMode.system,
  //         primaryButtonLabel: 'PAY -> $paymentAmount Rs.',
  //         merchantDisplayName: 'Candid',
  //         appearance: stripe.PaymentSheetAppearance(
  //             colors: stripe.PaymentSheetAppearanceColors(primary: Colors.blue.shade900),
  //             shapes: const stripe.PaymentSheetShape(borderRadius: 20)),
  //         customerId: firebaseAuth.currentUser!.phoneNumber,
  //         billingDetails: stripe.BillingDetails(
  //             email: firebaseAuth.currentUser?.email ?? vendor.userEmail1,
  //             name: vendor.userFullName,
  //             address: stripe.Address(
  //                 city: vendor.userAddressCity,
  //                 country: 'IN',
  //                 line1: vendor.userAddress,
  //                 line2: '',
  //                 postalCode: '',
  //                 state: vendor.userAddressState),
  //             phone: firebaseAuth.currentUser!.phoneNumber),
  //         allowsDelayedPaymentMethods: true,
  //       ),
  //     );
  //     // STEP 3: Display Payment sheet
  //     await openSession(amount: numericPaymentAmount.toDouble(), razorpayKey: razorpayKey);
  //   } catch (err) {
  //     throw Exception(err);
  //   }
  // }



  //
  // double calculateSavingsForPlanSubscription(Map<String, dynamic> resData) {
  //   double amountPerYear = double.parse(resData['amountPerYear']);
  //   double amountPerMonth = double.parse(resData['amountPerMonth']);
  //   int GST = int.parse(resData['percentageGST'].toString());
  //   double perYearAmount = amountPerYear + (amountPerYear * GST / 100);
  //   double perMonthAmount = amountPerMonth + (amountPerMonth * GST / 100);
  //
  //   if (selectedPlanCost == perYearAmount.toStringAsFixed(2)) {
  //     return (amountPerMonth * 12) - perYearAmount;
  //   } else if (selectedPlanCost == perMonthAmount.toStringAsFixed(2)) {
  //     return (perYearAmount - (amountPerMonth * 12));
  //   }
  //   return 0;
  // }

//   double calculateSavingsForOfferPlan(Map<String, dynamic> resData) {
//     // Implement your calculation logic here for offer plan savings
//     return 0;
//   }
 }
