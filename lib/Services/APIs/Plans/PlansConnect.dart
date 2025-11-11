import 'package:candid_vendors/Services/Collections/Plans/PlansColl.dart';
import 'package:candid_vendors/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../Utils/Utils.dart';

class PlansConnect extends GetConnect {
  Stream<String> getSelectedCityFromFirebase() {
    return FirebaseFirestore.instance
        .collection('candidVendors')
        .doc(firebaseAuth.currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.data()?['userAddressCity'] ?? '');
  }

  Future<Response> getPlanUpdatedByAdminApp() async {
    try {
      // Make the API call
      Response response = await post(
        '${Utils.apiUrl}/getVendorOnBoardingFees',
        {
          'userEmail': firebaseAuth.currentUser!.email,
          'userPhone': firebaseAuth.currentUser!.phoneNumber,
        },
        headers: await utils.getHeaders(),
      );

      // Log the response details using debugPrint
      debugPrint('API URL: ${Utils.apiUrl}/getVendorOnBoardingFees');
      debugPrint(
          'Request Body: {userPhone: ${firebaseAuth.currentUser!.phoneNumber}}');
      debugPrint('Headers: ${await utils.getHeaders()}');
      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      return response; // Return the response for further processing
    } catch (e) {
      // Log the error if the request fails using debugPrint
      debugPrint('Error in getPlanUpdatedByAdminApp: $e');
      rethrow; // Re-throw the error to handle it in the calling function
    }
  }

  Future<void> getPlansList(String selectedCityName) async {
    try {
      debugPrint('Calling getPlansList for city: $selectedCityName');
      Response res = await post(
          '${Utils.apiUrl}/getVendorSubscriptionPlans',
          {
            'userPhone': firebaseAuth.currentUser!.phoneNumber,
          },
          headers: await utils.getHeaders());

      debugPrint('API URL: ${Utils.apiUrl}/getVendorSubscriptionPlans');
      debugPrint(
          'Request Body: {userPhone: ${firebaseAuth.currentUser!.phoneNumber}}');
      debugPrint('Headers: ${await utils.getHeaders()}');
      debugPrint('Response Status Code: ${res.statusCode}');
      debugPrint('Response Body: ${res.body}');

      if (res.statusCode == 200) {
        List<PlansColl> plansList = [];
        if (res.body['plansList'] != null && res.body['plansList'] is List) {
          for (var plan in res.body['plansList']) {
            debugPrint('Processing plan: $plan');
            if (plan['planData'] != null) {
              var planData = plan['planData'];
              // Filter plans by selected city name (case-insensitive)
              if (planData['cityName'] != null &&
                  planData['cityName'].toString().toLowerCase() ==
                      selectedCityName.toLowerCase()) {
                plansList.add(PlansColl(
                  subscriptionPlanID: plan['planID'],
                  subscriptionPlanCost:
                      planData['subscriptionPlanCost'].toString(),
                  subscriptionPlanStartDate:
                      planData['subscriptionPlanStartDate'],
                  subscriptionPlanName: planData['subscriptionPlanName'],
                  subscriptionPlanEndDate: planData['subscriptionPlanEndDate'],
                  subscriptionPlanOfferCount:
                      planData['subscriptionPlanOfferCount'],
                  cityName: planData['cityName'] ?? '',
                  cityId: planData['cityId'] ?? '',
                  isSelected: false,
                ));
                debugPrint(
                    'Added plan to list: ${planData['subscriptionPlanName']}');
              } else {
                debugPrint(
                    'Plan city does not match selected city. Plan city: ${planData['cityName']}, Selected city: $selectedCityName');
              }
            } else {
              debugPrint('planData is null for plan: $plan');
            }
          }
        } else {
          debugPrint('plansList is null or not a List');
        }

        debugPrint('Plans list before Isar update: $plansList');
        await isar.writeTxn(() async {
          await isar.plansColls.clear();
          await isar.plansColls.putAll(plansList);
          debugPrint('Isar database updated with plans.');
        });
      } else {
        debugPrint('API request failed with status code: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching plans: $e');
    }
  }
}
