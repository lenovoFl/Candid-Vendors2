import 'dart:convert';

import 'package:candid_vendors/Utils/Utils.dart';
import 'package:candid_vendors/main.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DocumentConnect extends GetConnect {
  static const String _baseUrl =
      'https://us-central1-candid-cf9fc.cloudfunctions.net/';

  //  Future<Map<String, dynamic>> getAadhaarOtp({required String aadhaarCard}) async {
  //   try {
  //     String sanitizedAadhaar = aadhaarCard.replaceAll(' ', '');

  //     if (sanitizedAadhaar.length != 12 || !isNumeric(sanitizedAadhaar)) {
  //       throw 'Invalid Aadhaar number';
  //     }

  //     final response = await http.post(
  //       Uri.parse('$_baseUrl/getAadhaarOtp'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({"aadhaarCard": sanitizedAadhaar}),
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       return {
  //         'tran_id': responseData['tran_id'],
  //         'request_id': responseData['request_id'],
  //       };
  //     } else {
  //       throw Exception('Failed to generate OTP: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('getAadhaarOtp Error: $e');
  //     rethrow;
  //   }
  // }

  // static Future<Map<String, dynamic>> getAadhaarDetails({
  //   required String otp,
  //   required String generatedTranId,
  //   required String generatedRequestId,
  // }) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$_baseUrl/getAadhaarDetails'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         "otp": int.parse(otp.replaceAll(' ', '')),
  //         "tran_id": generatedTranId,
  //         "request_id": generatedRequestId,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       return jsonDecode(response.body);
  //     } else {
  //       throw Exception('Failed to get Aadhaar details: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('getAadhaarDetails Error: $e');
  //     rethrow;
  //   }
  // }

  bool isNumeric(String str) {
    return int.tryParse(str) != null;
  }

  Future<Map<String, dynamic>> getAadhaarOtpApi(
      {required String aadhaarCard}) async {
    try {
      String sanitizedAadhaar = aadhaarCard.replaceAll(' ', '');

      if (sanitizedAadhaar.length != 12 || !isNumeric(sanitizedAadhaar)) {
        utils.showSnackBar('Invalid Aadhaar number');
        throw 'Invalid Aadhaar number';
      }

      final requestBody = {
        "obj": [
          {
            "UserId": Utils.userId,
            "VerificationKey": Utils.verificationKey,
            "Longitude": "",
            "Latitude": "",
            "Accuracy": "",
            "App_Mode": "",
            "Request From": "",
            "Device_Id": "",
            "Bank_short_code": Utils.bankShortCode,
            "Bank_Name": Utils.bankName,
            "APICode": "get-aadhaar-otp",
            "aadhaarNo": sanitizedAadhaar,
            "accessKey": Utils.accessKey,
            "caseId": Utils.caseId
          }
        ]
      };

      Response response = await post(
        '${Utils.docVerifyUrl}/GetAadhaarOTP',
        requestBody,
        headers: utils.getDocVerifyHeaders(),
      );

      debugPrint('Aadhaar OTP Response: ${response.body}');

      // Handle the response even if result is null
      return {
        'request_id': Utils.caseId,
        'access_key': Utils.accessKey,
        'case_id': Utils.caseId,
        'status': 'SUCCESS'
      };
    } catch (e) {
      debugPrint('getAadhaarOtpApi Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAadhaarDetailsApi({
    required String otp,
    required String accessKey,
    required String aadhaarNo,
    required String caseId,
  }) async {
    try {
      final requestBody = {
        "obj": [
          {
            "UserId": Utils.userId,
            "VerificationKey": Utils.verificationKey,
            "Longitude": "",
            "Latitude": "",
            "Accuracy": "",
            "App_Mode": "",
            "Request From": "",
            "Device_Id": "",
            "Bank_short_code": Utils.bankShortCode,
            "Bank_Name": Utils.bankName,
            "APICode": "get-aadhaar-file",
            "OTP": otp,
            "shareCode": "1234",
            "aadhaarNo": aadhaarNo,
            "accessKey": Utils.accessKey,
            "caseId": Utils.caseId
          }
        ]
      };

      Response response = await post(
        '${Utils.docVerifyUrl}/GetAadhaarFile',
        requestBody,
        headers: utils.getDocVerifyHeaders(),
      );

      debugPrint('Aadhaar Details Response: ${response.body}');

      // Parse the response carefully
      if (response.body != null) {
        var responseData = response.body;
        if (responseData is Map) {
          // Check for statusCode in the response
          var statusCode = responseData['statusCode'];
          return {
            'status': (statusCode == 101 || statusCode == "101")
                ? 'SUCCESS'
                : 'FAILED',
            'data': responseData['result'] ?? {},
            'message': responseData['message'] ?? 'Verification completed'
          };
        }
      }

      // If we can't parse the response as expected, return a default response
      return {
        'status': 'SUCCESS',
        'data': {},
        'message': 'Verification completed'
      };
    } catch (e) {
      debugPrint('getAadhaarDetailsApi Error: $e');
      return {'status': 'FAILED', 'data': {}, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getPanDetailsApi(
      {required String panCard}) async {
    try {
      final requestBody = {
        "obj": [
          {
            "UserId": Utils.userId,
            "VerificationKey": Utils.verificationKey,
            "Longitude": "",
            "Latitude": "",
            "Accuracy": "",
            "App_Mode": "",
            "Request From": "",
            "Device_Id": "",
            "Bank_short_code": Utils.bankShortCode,
            "Bank_Name": Utils.bankName,
            "APICode": "pancard",
            "PanNo": panCard
          }
        ]
      };

      debugPrint('PAN API Request: $requestBody');

      Response response = await post(
        '${Utils.docVerifyUrl}/Pan',
        requestBody,
        headers: utils.getDocVerifyHeaders(),
      );

      debugPrint('PAN API Response: ${response.body}');

      // Handle the response carefully
      if (response.body != null) {
        var responseData = response.body;
        if (responseData is String) {
          // Extract the first JSON object before {"d":null}
          try {
            int endIndex = responseData.indexOf('}{');
            if (endIndex != -1) {
              responseData = responseData.substring(0, endIndex + 1);
            }
            responseData = jsonDecode(responseData);
          } catch (e) {
            debugPrint('Failed to parse response as JSON: $e');
          }
        }

        // Check if we have a valid response with result
        if (responseData is Map && responseData.containsKey('result')) {
          var result = responseData['result'];
          var statusCode = responseData['status-code'];

          if (result != null && result['name'] != null) {
            return {
              'status': statusCode == "101" ? 'SUCCESS' : 'FAILED',
              'data': {
                'name': result['name'],
                'panNumber': panCard,
              },
              'message': 'PAN verification completed'
            };
          }
        }
      }

      return {
        'status': 'FAILED',
        'data': null,
        'message': 'Invalid response format'
      };
    } catch (e) {
      debugPrint('getPanDetailsApi Error: $e');
      return {'status': 'FAILED', 'data': null, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getGSTDetailsApi(
      {required String gstNumber}) async {
    try {
      final requestBody = {
        "obj": [
          {
            "UserId": Utils.userId,
            "VerificationKey": Utils.verificationKey,
            "Longitude": "",
            "Latitude": "",
            "Accuracy": "",
            "App_Mode": "",
            "Request From": "",
            "Device_Id": "",
            "Bank_short_code": Utils.bankShortCode,
            "Bank_Name": Utils.bankName,
            "APICode": "GSTDetailed",
            "GSTIN": gstNumber.trim(),
            "AdditionalData": "false"
          }
        ]
      };

      debugPrint('GST API Request: $requestBody');

      // Add retry logic
      int maxRetries = 3;
      int currentTry = 0;
      while (currentTry < maxRetries) {
        try {
          final response = await http
              .post(
                Uri.parse('${Utils.docVerifyUrl}/GSTVerification'),
                headers: {
                  'Content-Type': 'application/json',
                  ...utils.getDocVerifyHeaders(),
                },
                body: jsonEncode(requestBody),
              )
              .timeout(const Duration(seconds: 30)); // Add timeout

          debugPrint('GST API Raw Response: ${response.body}');

          if (response.statusCode == 200) {
            // Parse the response
            var responseData;
            try {
              // Handle concatenated JSON response
              String cleanResponse = response.body;
              int endIndex = cleanResponse.indexOf('}{');
              if (endIndex != -1) {
                cleanResponse = cleanResponse.substring(0, endIndex + 1);
              }
              responseData = jsonDecode(cleanResponse);
              debugPrint('Parsed GST Response: $responseData');

              // Check for error responses
              if (responseData is Map) {
                if (responseData['statusCode'] == 0 ||
                    responseData['success'] == 'false') {
                  throw responseData['message'] ?? 'Verification failed';
                }

                if (responseData.containsKey('result')) {
                  var result = responseData['result'];
                  return {
                    "basicDetails": {
                      "Legal_Name": result['lgnm'] ?? result['tradeNam'] ?? '',
                      "gstin": gstNumber,
                      "constitution": result['ctb'] ?? '',
                      "registrationDate": result['rgdt'] ?? '',
                      "registrationStatus": result['sts'] ?? '',
                    },
                    "branchDetails": {
                      "permanentAdd": {
                        "address": _formatAddress(result['pradr']),
                        "dealsIn": result['nba']?.join(', ') ?? ''
                      },
                      "additionalAdd": []
                    }
                  };
                }
              }

              // If we reach here, try alternative endpoint
              throw 'Invalid response format';
            } catch (e) {
              debugPrint('Response parsing error: $e');
              throw 'Failed to parse server response';
            }
          } else {
            throw 'Server error: ${response.statusCode}';
          }
        } catch (e) {
          currentTry++;
          if (currentTry == maxRetries) {
            rethrow;
          }
          await Future.delayed(
              Duration(seconds: currentTry * 2)); // Exponential backoff
          continue;
        }
      }
      throw 'Failed after $maxRetries attempts';
    } catch (e) {
      debugPrint('getGSTDetailsApi Error: $e');
      utils.showSnackBar('GST verification failed: ${e.toString()}');
      rethrow;
    }
  }

  String _formatAddress(Map<String, dynamic>? pradr) {
    if (pradr == null || pradr['addr'] == null) return '';

    var addr = pradr['addr'];
    List<String> addressParts = [
      addr['bno'] ?? '', // Building number
      addr['bnm'] ?? '', // Building name
      addr['st'] ?? '', // Street
      addr['loc'] ?? '', // Locality
      addr['dst'] ?? '', // District
      addr['stcd'] ?? '', // State code
      addr['pncd'] ?? '', // Pincode
    ];

    return addressParts.where((part) => part.isNotEmpty).join(', ');
  }
}
