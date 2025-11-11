import 'dart:convert';
import 'package:candid_vendors/Services/Collections/User/VendorUserColl.dart';
import 'package:candid_vendors/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:http/http.dart' as http;
import '../../../Utils/Utils.dart';

class PaymentConnect extends GetConnect {
  String razorpayKey = "rzp_live_mXMqD6Uq31IPNc";
  String razorpaySecret = "R31iM3MZyxPQdBtNmAPF4s9V";

  createPaymentIntent(String currency, String email, num amount,
      String recieptId) async {
    debugPrint('amount : $amount');
    var auth = 'Basic ${base64Encode(
        utf8.encode('$razorpayKey:$razorpaySecret'))}';
    var headers = {'content-type': 'application/json', 'Authorization': auth};
    var request = http.Request(
        'POST', Uri.parse('https://api.razorpay.com/v1/orders'));
    request.body = json.encode({
      "amount": amount * 100,
      "currency": "INR",
      "receipt": recieptId
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return {
        "status": "success",
        "body": jsonDecode(await response.stream.bytesToString())
      };
    } else {
      return {"status": "fail", "message": response.reasonPhrase};
    }
  }

  paymentDoneAPI(
      {required String selectedPlanCost,
        required String userFullName,
        required String paymentType,
        required paymentID,
        required String candidOfferSubscriptionEndDate,
        int? selectedSubscriptionPlanOfferCount,
        required String selectedSubscriptionPlanId}) async {
    var user =
    (await isar.vendorUserColls.filter().userIdIsNotEmpty().build().findFirst());

    debugPrint('paymentType : $paymentType');
    debugPrint('selectedSubscriptionPlanOfferCount: $selectedSubscriptionPlanOfferCount');
    debugPrint('candidOfferSubscriptionEndDate: $candidOfferSubscriptionEndDate');
    debugPrint('paymentID : $paymentID');
    debugPrint('selectedSubscriptionPlanId: $selectedSubscriptionPlanId');
    debugPrint('userFullName: $userFullName');
    debugPrint('selectedPlanCost: $selectedPlanCost');

    var response = await post(
      '${Utils.apiUrl}/paymentDone',
      {
        'selectedPlanCost': selectedPlanCost,
        'userFullName': userFullName,
        'paymentType': paymentType,

        'paymentID': paymentID,
        'offerSubscriptionEndDate': paymentType == 'subscriptionRecharge'
            ? user?.candidOfferSubscriptionEndDate
            .add(Duration(days: int.parse(candidOfferSubscriptionEndDate.toString())))
            .toIso8601String()
            : paymentType == 'firstTimeSubscriptionRecharge'
            ? DateTime.now()
            .add(Duration(
            days: int.parse(candidOfferSubscriptionEndDate.toString())))
            .toIso8601String()
            : '',
        'selectedSubscriptionPlanOfferCount': selectedSubscriptionPlanOfferCount,
        'selectedSubscriptionPlanId': selectedSubscriptionPlanId
      },
      headers: await utils.getHeaders(),
    );

    debugPrint('paymentDoneAPI response statusCode: ${response.statusCode}');
    debugPrint('paymentDoneAPI response body: ${response.body}');
    if (response.statusCode == 401) {
      await utils.logOutUser();
    } else if (response.statusCode == 400) {
      try {
        utils.showSnackBar(response.body['message']);
      } catch (e) {
        utils.showSnackBar('Something is wrong!');
      }
    } else if (response.statusCode == 200) {
      debugPrint(response.body['message']);
      if (response.body.containsKey('offerCount')) {
        user?.offerCount = response.body['offerCount'];
      }
      if (paymentType == 'subscriptionRecharge' ||
          paymentType == 'firstTimeSubscriptionRecharge') {
        user?.candidOfferSubscriptionEndDate =
            DateTime.parse(response.body['offerSubscriptionEndDate'] ?? '');
      }
      await isar.writeTxn(() async {
        if (user != null) {
          await isar.vendorUserColls.put(user);
          Navigator.of(navigatorKey.currentContext!).pop();
        }
      });
    }
  }
}