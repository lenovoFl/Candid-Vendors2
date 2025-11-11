import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

class PassbookScreen extends StatefulWidget {
  const PassbookScreen({Key? key}) : super(key: key);

  @override
  State<PassbookScreen> createState() => _PassbookScreenState();
}

class _PassbookScreenState extends State<PassbookScreen> {
  late Stream<List<DocumentSnapshot<Map<String, dynamic>>>> combinedStream;

  @override
  void initState() {
    super.initState();
    final currentUserUid = firebaseAuth.currentUser?.uid ?? '';

    final subscriptionRechargeStream = FirebaseFirestore.instance
        .collection('candidVendors')
        .doc(currentUserUid)
        .collection('subscriptionRechargePaymentHistory')
        .snapshots()
        .map((snapshot) => snapshot.docs);

    final subscriptionPlanRechargeStream = FirebaseFirestore.instance
        .collection('candidVendors')
        .doc(currentUserUid)
        .collection('subscriptionPlanRechargePaymentHistory')
        .snapshots()
        .map((snapshot) => snapshot.docs);

    combinedStream = Rx.combineLatest2<
        List<QueryDocumentSnapshot<Map<String, dynamic>>>,
        List<QueryDocumentSnapshot<Map<String, dynamic>>>,
        List<DocumentSnapshot<Map<String, dynamic>>>>(
      subscriptionRechargeStream,
      subscriptionPlanRechargeStream,
          (rechargeDocs, planDocs) => [...rechargeDocs, ...planDocs],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
      stream: combinedStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: GoogleFonts.workSans(),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Passbook Transaction',
                style: GoogleFonts.workSans(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: Colors.black87, size: 20.sp),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: Container(
                width: 95.w,
                padding: EdgeInsets.all(20.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.hourglass_empty,
                      size: 50.sp,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 20.sp),
                    Text(
                      'Your Payment is Under Review',
                      style: GoogleFonts.workSans(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.sp),
                    Text(
                      'Please wait while we process your payment. This may take a few moments.',
                      style: GoogleFonts.workSans(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          List<DocumentSnapshot<Map<String, dynamic>>> documents =
          snapshot.data!;
          documents = documents.reversed.toList();

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Passbook Transaction',
                style: GoogleFonts.workSans(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: Colors.black87, size: 20.sp),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 95.w,
                  height: 90.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final doc = documents[index];
                      String selectedPlanCost = doc.data() != null &&
                          (doc.data() as Map<String, dynamic>)
                              .containsKey('selectedPlanCost')
                          ? doc.get('selectedPlanCost').toString()
                          : 'N/A';
                      String paymentId = doc.data() != null &&
                          (doc.data() as Map<String, dynamic>)
                              .containsKey('paymentID')
                          ? doc.get('paymentID').toString()
                          : 'No Payment ID';

                      return TransactionItem(
                        amount: selectedPlanCost,
                        paymentId: paymentId,
                        status: 'PAID',
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String amount;
  final String paymentId;
  final String status;

  const TransactionItem({
    Key? key,
    required this.amount,
    required this.paymentId,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor = const Color(0xFFB4FFB2);
    String statusText = 'PAID';

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status container and Amount below it
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: GoogleFonts.workSans(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                amount,
                style: GoogleFonts.workSans(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Payment Id and Pay Mode
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Id',
                    style: GoogleFonts.workSans(
                      color: Colors.grey.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    paymentId,
                    style: GoogleFonts.workSans(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Pay Mode',
                    style: GoogleFonts.workSans(
                      color: Colors.grey.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    status,
                    style: GoogleFonts.workSans(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
