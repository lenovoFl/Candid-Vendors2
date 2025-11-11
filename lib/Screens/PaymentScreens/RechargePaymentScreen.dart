import 'package:candid_vendors/Controllers/Payment/PaymentController.dart';
import 'package:candid_vendors/Screens/PaymentScreens/PaymentViewScreen.dart';
import 'package:candid_vendors/Services/Collections/Plans/PlansColl.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Services/APIs/Plans/PlansConnect.dart';
import '../../main.dart';

class RechargePaymentScreen extends StatelessWidget {
  const RechargePaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Buy Offers',
          style: GoogleFonts.workSans(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder(
        future: PlansConnect().getPlanUpdatedByAdminApp(),
        builder: (context, snapshot) {
          Response? res = snapshot.data;
          if (res?.statusCode == 200) {
            var resData = res?.body;
            int GST = int.parse(resData['percentageGST'].toString());
            String perYearAmount = (int.parse(resData['amountPerYear']) +
                (int.parse(resData['amountPerYear']) * GST / 100))
                .toStringAsFixed(2);
            String perMonthAmount = (int.parse(resData['amountPerMonth']) +
                (int.parse(resData['amountPerMonth']) * GST / 100))
                .toStringAsFixed(2);
            return GetBuilder(
              init: PaymentController(),
              builder: (PaymentController controller) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildWarningBanner(),
                      _buildToggleButton(controller),
                      _buildInfoCard(),
                      const SizedBox(height: 20),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: controller.isSubscriptionRecharge
                            ? _buildSubscriptionPlans(controller, perYearAmount,
                            perMonthAmount, GST, resData)
                            : _buildOfferPlans(controller, GST),
                      ),
                      const Divider(thickness: 1, color: Colors.grey),
                      _buildPayableAmount(controller),
                      const SizedBox(height: 20),
                      _buildPaymentButton(context, controller),
                      SizedBox(height: 20.h),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        'Consume all your offers before subscription end date. They cannot be carried forward.',
        style: GoogleFonts.workSans(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// ✅ UPDATED: Modern Gradient Animated Toggle Button
  Widget _buildToggleButton(PaymentController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GestureDetector(
        onTap: () {
          controller.isSubscriptionRecharge = !controller.isSubscriptionRecharge;
          controller.selectedPlanCost = '';
          controller.selectedsubscriptionPlanCost = '';
          controller.selectedPlanDurationInDays = '';
          controller.update();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          height: 55,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: controller.isSubscriptionRecharge
                  ? [Colors.blue.shade900, Colors.blueAccent]
                  : [Colors.green.shade700, Colors.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: controller.isSubscriptionRecharge
                    ? Colors.blue.shade200
                    : Colors.green.shade200,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  controller.isSubscriptionRecharge
                      ? Icons.account_balance_wallet_rounded
                      : Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    controller.isSubscriptionRecharge
                        ? 'Switch to Recharge Wallet'
                        : 'Switch to Subscription Mode',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.workSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    controller.isSubscriptionRecharge
                        ? Icons.toggle_on_rounded
                        : Icons.toggle_off_rounded,
                    key: ValueKey<bool>(controller.isSubscriptionRecharge),
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'After selecting a plan, scroll down to make payment!',
          style: GoogleFonts.workSans(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSubscriptionPlans(PaymentController controller,
      String perYearAmount, String perMonthAmount, int GST, dynamic resData) {
    return Column(
      children: [
        _buildPlanCard(
          controller,
          perYearAmount,
          '365',
          'Yearly Plan',
          resData['amountPerYear'],
          GST,
        ),
        const SizedBox(height: 10),
        _buildPlanCard(
          controller,
          perMonthAmount,
          '30',
          'Monthly Plan',
          resData['amountPerMonth'],
          GST,
        ),
        const SizedBox(height: 20),
        _buildSubscriptionEndDate(controller),
      ],
    );
  }

  Widget _buildPlanCard(PaymentController controller, String amount,
      String days, String title, String baseAmount, int GST) {
    bool isSelected = controller.selectedPlanCost == amount;
    return GestureDetector(
      onTap: () {
        if (controller.selectedPlanCost != amount) {
          controller.selectedPlanCost = amount;
          controller.selectedPlanDurationInDays = days;
          controller.update();
        }
      },
      child: Card(
        elevation: isSelected ? 10 : 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: isSelected ? Colors.blue.shade900 : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.workSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Base amount: $baseAmount ₹',
                  style: GoogleFonts.workSans(fontSize: 14)),
              Text('GST: $GST%', style: GoogleFonts.workSans(fontSize: 14)),
              Text(
                'Total: $amount ₹',
                style: GoogleFonts.workSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferPlans(PaymentController controller, int GST) {
    return StreamBuilder<String>(
      stream: PlansConnect().getSelectedCityFromFirebase(),
      builder: (context, citySnapshot) {
        if (citySnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (citySnapshot.hasError) {
          return const Text('Error loading city data');
        }

        final selectedCityName = citySnapshot.data ?? '';

        if (selectedCityName.isEmpty) {
          return Center(
            child: Text('Please select a city first',
                style: GoogleFonts.workSans(fontSize: 14)),
          );
        }

        PlansConnect().getPlansList(selectedCityName);

        return StreamBuilder(
          stream: isar.plansColls
              .where()
              .filter()
              .cityNameEqualTo(selectedCityName, caseSensitive: false)
              .build()
              .watch(fireImmediately: true),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong.',
                  style: GoogleFonts.workSans());
            }

            if (snapshot.hasData) {
              var plansList = snapshot.data as List<PlansColl>;
              if (plansList.isEmpty) {
                return Center(
                  child: Text('No plans found for your city.',
                      style: GoogleFonts.workSans(fontSize: 16)),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: plansList.length,
                itemBuilder: (context, index) {
                  var plan = plansList[index];
                  var amount = int.parse(plan.subscriptionPlanCost);
                  var cost = (amount + (amount * GST / 100)).toStringAsFixed(2);
                  return _buildOfferPlanCard(controller, plan, amount, cost, GST);
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  Widget _buildOfferPlanCard(PaymentController controller, PlansColl plan,
      int amount, String cost, int GST) {
    bool isSelected = controller.selectedsubscriptionPlanCost == cost;
    return GestureDetector(
      onTap: () {
        if (controller.selectedsubscriptionPlanCost != cost) {
          controller.selectPlan(plan);
        }
      },
      child: Card(
        elevation: isSelected ? 8 : 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: isSelected ? Colors.blue.shade900 : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(plan.subscriptionPlanName,
                  style: GoogleFonts.workSans(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('City: ${plan.cityName}',
                  style: GoogleFonts.workSans(fontSize: 14)),
              Text('Offer count: ${plan.subscriptionPlanOfferCount}',
                  style: GoogleFonts.workSans(fontSize: 14)),
              Text(
                'Validity: ${DateFormat('MM/dd').format(DateTime.parse(plan.subscriptionPlanEndDate))}',
                style: GoogleFonts.workSans(fontSize: 14, color: Colors.red),
              ),
              Text('Base amount: $amount ₹',
                  style: GoogleFonts.workSans(fontSize: 14)),
              Text('GST: $GST%', style: GoogleFonts.workSans(fontSize: 14)),
              Text('Total: $cost ₹',
                  style: GoogleFonts.workSans(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionEndDate(PaymentController controller) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('candidVendors')
          .doc(firebaseAuth.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}',
              style: GoogleFonts.workSans(fontSize: 14));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text('No data found',
              style: GoogleFonts.workSans(fontSize: 14));
        }
        var subscriptionEndDate =
        snapshot.data!.get('candidOfferSubscriptionEndDate');
        DateTime endDate = DateTime.parse(subscriptionEndDate);
        String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
        DateTime currentDate = DateTime.now();
        int daysDifference = endDate.difference(currentDate).inDays;

        Color textColor = daysDifference <= 0 ? Colors.red : Colors.orange;
        String message = daysDifference <= 0
            ? 'Your Subscription has expired!'
            : 'Your Subscription End Date: $formattedEndDate';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              message,
              style: GoogleFonts.workSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPayableAmount(PaymentController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        'Payable amount: ${controller.selectedPlanCost.isEmpty ? '' : controller.selectedPlanCost}',
        style: GoogleFonts.workSans(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPaymentButton(
      BuildContext context, PaymentController controller) {
    if (!controller.isPaymentDone &&
        (controller.selectedPlanCost.length > 2 ||
            controller.selectedsubscriptionPlanCost.length > 2)) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PaymentViewScreen()),
          );
        },
        child: Text(
          'Proceed to Payment',
          style: GoogleFonts.workSans(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
