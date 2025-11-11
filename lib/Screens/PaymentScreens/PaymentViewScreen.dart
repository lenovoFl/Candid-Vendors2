import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../Controllers/Payment/PaymentController.dart';
import '../../RazorpayKey/global.dart';

class PaymentViewScreen extends StatefulWidget {
  const PaymentViewScreen({super.key});

  @override
  _PaymentViewScreenState createState() => _PaymentViewScreenState();
}

class _PaymentViewScreenState extends State<PaymentViewScreen> {
  final PaymentController paymentController = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Process Payment',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 20.sp
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder<PaymentController>(
          builder: (paymentController) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subscription Details Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subscription Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Amount Details',
                              style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                            // Icon(
                            //   Icons.verified_rounded,
                            //   color: Colors.green.shade600,
                            //   size: 24.sp,
                            // )
                          ],
                        ),
                        SizedBox(height: 2.h),

                        // Subscription Breakdown
                        _buildDetailRow(
                          'Offer Plan',
                          paymentController.selectedPlanCost,
                          isHighlighted: true,
                        ),
                        SizedBox(height: 1.h),
                        Divider(color: Colors.grey.shade300),
                        SizedBox(height: 1.h),

                        // Tax and Additional Charges
                        _buildDetailRow(
                          'Subtotal',
                          _calculateSubtotal(paymentController.selectedPlanCost),
                        ),
                        SizedBox(height: 1.h),
                        _buildDetailRow(
                          'Taxes (18% GST)',
                          _calculateTax(paymentController.selectedPlanCost),
                        ),
                        SizedBox(height: 1.h),
                        Divider(color: Colors.grey.shade300),
                        SizedBox(height: 1.h),

                        // Total Amount
                        _buildDetailRow(
                          'Total Amount',
                          _calculateTotalAmount(paymentController.selectedPlanCost),
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Pay Now Button
                  Center(
                    child: Container(
                      width: 80.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF548FF2),
                            const Color(0xFF548FF2).withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF548FF2).withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          double amount;
                          String cost = paymentController.selectedsubscriptionPlanCost.isNotEmpty
                              ? paymentController.selectedsubscriptionPlanCost
                              : paymentController.selectedPlanCost;

                          String cleanedCost = cost.replaceAll(RegExp(r'[^\d.]'), '');

                          try {
                            amount = double.parse(cleanedCost);
                            paymentController.openSession(
                              amount: amount,
                              razorpayKey: AppConfig.razorpayKey,
                            );
                          } catch (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Unable to process payment. Please try again.',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Proceed to Payment',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Security Notice
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_rounded,
                          color: Colors.grey.shade600,
                          size: 16.sp,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Secure Razorpay Payment Gateway',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow(
      String label,
      String value, {
        bool isHighlighted = false,
        bool isTotal = false,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: isTotal
                ? Colors.black
                : Colors.grey.shade700,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            fontSize: isTotal ? 15.sp : 13.sp,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            color: isHighlighted
                ? const Color(0xFF548FF2)
                : (isTotal ? Colors.black : Colors.grey.shade800),
            fontWeight: isTotal
                ? FontWeight.w700
                : (isHighlighted ? FontWeight.w600 : FontWeight.w500),
            fontSize: isTotal
                ? 16.sp
                : (isHighlighted ? 14.sp : 13.sp),
          ),
        ),
      ],
    );
  }

  // Utility methods for calculations
  String _calculateSubtotal(String originalCost) {
    // Remove non-numeric characters
    String cleanedCost = originalCost.replaceAll(RegExp(r'[^\d.]'), '');
    double cost = double.tryParse(cleanedCost) ?? 0.0;

    // Calculate subtotal (assuming GST is 18%)
    double subtotal = cost / 1.18;
    return '₹${subtotal.toStringAsFixed(2)}';
  }

  String _calculateTax(String originalCost) {
    String cleanedCost = originalCost.replaceAll(RegExp(r'[^\d.]'), '');
    double cost = double.tryParse(cleanedCost) ?? 0.0;

    // Calculate tax (18% GST)
    double tax = cost - (cost / 1.18);
    return '₹${tax.toStringAsFixed(2)}';
  }

  String _calculateTotalAmount(String originalCost) {
    String cleanedCost = originalCost.replaceAll(RegExp(r'[^\d.]'), '');
    double cost = double.tryParse(cleanedCost) ?? 0.0;
    return '₹${cost.toStringAsFixed(2)}';
  }
}