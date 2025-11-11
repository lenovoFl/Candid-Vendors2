import 'package:flutter/material.dart';
import 'package:candid_vendors/Controllers/Auth/CreateProfileController.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../../RazorpayKey/global.dart';
import '../../../Services/APIs/Plans/PlansConnect.dart';

class CreateProfileStep3 extends StatelessWidget {
  final CreateProfileController controller;
  const CreateProfileStep3({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.selectedStep == 2
          ? AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        child: true
            ? FutureBuilder(
          future: PlansConnect().getPlanUpdatedByAdminApp(),
          builder: (context, snapshot) {
            Response? res = snapshot.data;
            if (res?.statusCode == 200) {
              var resData = res?.body;
              int gst = int.parse(resData['percentageGST'].toString());
              String perYearAmount = (int.parse(resData['amountPerYear']) +
                  (int.parse(resData['amountPerYear']) * gst / 100))
                  .toStringAsFixed(2);
              String perMonthAmount = (int.parse(resData['amountPerMonth']) +
                  (int.parse(resData['amountPerMonth']) * gst / 100))
                  .toStringAsFixed(2);

              return Column(
                children: [
                  // Payment Method Selector with Improved Design
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPaymentOption(
                          icon: Icons.credit_card,
                          title: 'Online Payment',
                          isSelected: !controller.isChequePayment,
                          onTap: () {
                            controller.isChequePayment = false;
                            controller.update();
                          },
                        ),
                        _buildPaymentOption(
                          icon: Icons.receipt,
                          title: 'Pay by Cheque',
                          isSelected: controller.isChequePayment,
                          onTap: () {
                            controller.isChequePayment = true;
                            controller.update();
                          },
                        ),
                      ],
                    ),
                  ),

                  // Plans in Row with Improved Design
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: !controller.isPaymentDone
                              ? () {
                            controller.selectedPlanCost = perYearAmount;
                            controller.selectedPlanDurationInDays = '365';
                            controller.update();
                          }
                              : null,
                          child: _buildPlanCard(
                            title: 'Yearly Plan',
                            amount: resData['amountPerYear'],
                            gst: gst,
                            payable: perYearAmount,
                            validity: '365 days',
                            isSelected: controller.selectedPlanCost == perYearAmount,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: InkWell(
                          onTap: !controller.isPaymentDone
                              ? () {
                            controller.selectedPlanCost = perMonthAmount;
                            controller.selectedPlanDurationInDays = '30';
                            controller.update();
                          }
                              : null,
                          child: _buildPlanCard(
                            title: 'Monthly Plan',
                            amount: resData['amountPerMonth'],
                            gst: gst,
                            payable: perMonthAmount,
                            validity: '30 days',
                            isSelected: controller.selectedPlanCost == perMonthAmount,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Payable Amount with Enhanced Design
                  if (controller.selectedPlanCost.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Payable amount: ₹${controller.selectedPlanCost}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],

                  // Cheque Upload Section with Modern Design
                  if (controller.isChequePayment && controller.selectedPlanCost.isNotEmpty)
                    _buildChequeUploadSection(controller),

                  // Payment/Register Button with Gradient and Shadow
                  if (controller.selectedPlanCost.isNotEmpty && !controller.isPaymentDone)
                    AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: controller.isChequePayment
                          ? controller.chequeImage != null
                          ? _buildActionButton(
                        title: 'Register',
                        onPressed: () => controller.createProfileClickHandler(),
                        icon: Icons.check_circle,
                        color: Colors.green,
                      )
                          : const SizedBox()
                          : _buildActionButton(
                        title: 'Pay with Razorpay',
                        onPressed: () => controller.openSession(
                          amount: double.parse(controller.selectedPlanCost),
                          razorpayKey: AppConfig.razorpayKey,
                        ),
                        icon: Icons.payment,
                        color: Colors.blue,
                      ),
                    ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        )
            : const SizedBox(),
      )
          : SizedBox(height: 10.h),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        margin: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String amount,
    required int gst,
    required String payable,
    required String validity,
    required bool isSelected,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(15),
        color: isSelected ? Colors.blue.shade50 : Colors.white,
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ]
            : null,
      ),
      padding: EdgeInsets.all(2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
          SizedBox(height: 1.h),
          Text('Base amount: ₹$amount'),
          Text('GST: $gst%'),
          Text(
            'Payable amount: ₹$payable',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Validity: $validity',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChequeUploadSection(CreateProfileController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade50,
      ),
      child: Column(
        children: [
          if (controller.chequeImage == null)
            InkWell(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  controller.chequeImage = File(image.path);
                  controller.update();
                }
              },
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload,
                    size: 50,
                    color: Colors.blue.shade300,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Upload cheque for ₹${controller.selectedPlanCost}',
                    style: TextStyle(
                      color: Colors.blue.shade300,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    controller.chequeImage!,
                    height: 20.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Cheque uploaded successfully!',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 60.w,
      height: 5.h,
      margin: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 2.w),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}