import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';

import '../../Services/Collections/Offers/OfferHistory/OfferHistoryColl.dart';
import '../../main.dart';

class RedeemedOffersScreen extends StatefulWidget {
  const RedeemedOffersScreen({super.key});

  @override
  State<RedeemedOffersScreen> createState() => _RedeemedOffersScreenState();
}

class _RedeemedOffersScreenState extends State<RedeemedOffersScreen> {
  // Set to keep track of offer IDs for which the pop-up has been shown
  final Set<String> shownOfferIds = {};

  void showNewOfferPopup(BuildContext context, Map<String, dynamic> offer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: Colors.green.shade800,
        duration: const Duration(seconds: 4),
        content: Row(
          children: [
            const Icon(
              Icons.local_offer_rounded,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'New Offer Redeemed!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Aileron',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Offer: ${offer['offerName']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Aileron',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Redeemed Offers',
          style: GoogleFonts.poppins(
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

      body: StreamBuilder<List<OfferHistoryColl>>(
        stream: isar.offerHistoryColls
            .where()
            .offerIDIsNotEmpty()
            .build()
            .watch(fireImmediately: true),
        builder: (context, offerHistorySnapshot) {
          if (!offerHistorySnapshot.hasData || offerHistorySnapshot.data!.isEmpty) {
            return const Center(child: Text('No redeemed offers found'));
          }

          List<String> myOfferIds = offerHistorySnapshot.data!.map((e) => e.offerID).toList();

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('availedOffers')
                .where('offerID', whereIn: myOfferIds)
                .snapshots(),
            builder: (context, availedOffersSnapshot) {
              if (!availedOffersSnapshot.hasData || availedOffersSnapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No redeemed offers found'));
              }

              final redeemedOffers = availedOffersSnapshot.data!.docs;

              // Check and show the pop-up only for new, unshown offers
              WidgetsBinding.instance.addPostFrameCallback((_) {
                for (var offer in redeemedOffers) {
                  try {
                    Map<String, dynamic> offerData = offer.data() as Map<String, dynamic>;
                    bool isOfferRedeemed = offerData['isOfferRedeemed'] ?? false;
                    String offerID = offerData['offerID'] ?? '';

                    if (isOfferRedeemed && !shownOfferIds.contains(offerID)) {
                      showNewOfferPopup(context, offerData);
                      shownOfferIds.add(offerID);
                    }
                  } catch (e) {
                    print('Error processing offer: $e');
                  }
                }
              });

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: redeemedOffers.length,
                itemBuilder: (context, index) {
                  final offer = redeemedOffers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.local_offer_rounded,
                                  color: Colors.green,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      offer['productName'] ?? 'Product',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Aileron',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Offer: ${offer['offerName']}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Aileron',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            'Order ID',
                            offer['orderID'] ?? 'N/A',
                            Icons.receipt_long_rounded,
                          ),
                          _buildDetailRow(
                            'Phone',
                            offer['userPhone'] ?? 'N/A',
                            Icons.phone_rounded,
                          ),
                          _buildDetailRow(
                            'Store',
                            offer['StoreAddress'] ?? 'N/A',
                            Icons.store_rounded,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildStatusChip(
                                'Prime Member',
                                offer['isUserPrimeMember'] ?? false,
                                Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              _buildStatusChip(
                                'Redeemed',
                                offer['isOfferRedeemed'] ?? false,
                                Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontFamily: 'Aileron',
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: 'Aileron',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, bool status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status ? color.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status ? color : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: status ? color : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: status ? color : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Aileron',
            ),
          ),
        ],
      ),
    );
  }
}