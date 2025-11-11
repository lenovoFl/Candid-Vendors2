import 'dart:convert';
import 'dart:typed_data';

import 'package:candid_vendors/Services/APIs/Offers/OffersConnect.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../main.dart';

class QRDataScreen extends StatefulWidget {
  final List<Barcode> barcodes;
  final Uint8List? image;

  const QRDataScreen({super.key, required this.barcodes, required this.image});

  @override
  State<QRDataScreen> createState() => _QRDataScreenState();
}

class _QRDataScreenState extends State<QRDataScreen> {
  final List<Widget> barcodesDataTxt = [];
  bool isLoading = true;

  Future<void> offerRedeem({
    required String offerID,
    required String? orderID,
    required String userPhone,
  }) async {
    debugPrint('offerID : $offerID');
    debugPrint('orderID : ${orderID ?? "No Order ID provided"}');
    debugPrint('userPhone : $userPhone');

    try {
      setState(() {
        isLoading = true;
      });

      bool success = await OffersConnect().offerRedeemApi(
        offerID: offerID,
        orderID: orderID ?? 'unknown_order',
        userPhone: userPhone,
      );

      setState(() {
        isLoading = false;
      });

      if (success) {

        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('offerRedeem catch E | $e');
    }
  }


  Map<String, dynamic> parseRawValue(String rawValue) {
    Map<String, dynamic> result = {};

    // Remove any leading and trailing braces
    rawValue = rawValue.replaceAll(RegExp(r'^\{|\}$'), '');

    // Split the raw value into key-value pairs
    List<String> pairs = rawValue.split(',');

    for (String pair in pairs) {
      pair = pair.trim();

      // Split each pair into key and value
      int colonIndex = pair.indexOf(':');
      if (colonIndex != -1) {
        String key = pair.substring(0, colonIndex).trim();
        String value = pair.substring(colonIndex + 1).trim();

        // Remove any leftover braces from key or value
        key = key.replaceAll(RegExp(r'[{}]'), '');
        value = value.replaceAll(RegExp(r'[{}]'), '');

        result[key] = value;
      }
    }

    return result;
  }


  @override
  void initState() {
    super.initState();
    for (final barcode in widget.barcodes) {
      String rawValue = barcode.rawValue.toString().trim();
      debugPrint('Barcodes found! $rawValue');
      try {
        // Parsing the raw QR data
        Map<String, dynamic> map = parseRawValue(rawValue);
        String jsonString = jsonEncode(map);
        debugPrint('Parsed JSON: $jsonString');
        Map<String, dynamic> decodedMap = jsonDecode(jsonString);

        // Safely fetch values and handle null cases
        String offerName = decodedMap['offerName'] ?? 'Offer name not available';
        String userPhone = decodedMap['userPhone'] ?? 'Phone number not available';
        String orderID = decodedMap['orderID'] ?? 'Order ID not available';
        String productName = decodedMap['productName'] ?? 'Product name not available';
        String offerID = decodedMap['offerID'] ?? 'Offer ID not available';
        String storeAddress = decodedMap['StoreAddress'] ?? 'Store address not available';
        String userPrimeStatus = decodedMap['isUserPrimeMember'] == 'true'
            ? 'Prime Member'
            : 'Regular Customer';

        // Display data in a user-friendly card
        barcodesDataTxt.add(
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Offer Name: $offerName',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Product Name: $productName',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Store: $storeAddress',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Order ID: $orderID',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Offer ID: $offerID',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phone: $userPhone',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Membership: $userPrimeStatus',
                    style: TextStyle(
                      color: decodedMap['isUserPrimeMember'] == 'true'
                          ? Colors.green
                          : Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Add 'Accept Offer' button
        barcodesDataTxt.add(myWidgets.getLargeButton(
          title: 'Accept Offer',
          onPress: () => offerRedeem(
            offerID: offerID,
            orderID: orderID,
            userPhone: userPhone,
          ),
        ));

        setState(() {
          isLoading = false;
        });
      } catch (e) {
        debugPrint('QR DATA SCREEN CATCH | $e');
        setState(() {
          isLoading = false;
          barcodesDataTxt.add(const Text(
            'Error parsing QR code data',
            style: TextStyle(color: Colors.red),
          ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Data"),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
            child: FractionallySizedBox(
              widthFactor: 0.80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: barcodesDataTxt
                    .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: e,
                ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
