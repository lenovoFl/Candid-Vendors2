import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../../../Utils/Utils.dart';

class Refrelpayout {
  Future<Map<String, dynamic>> sellerRefTrans(String userUid,
      String referralId) async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final response = await http.post(
      Uri.parse('${Utils.apiUrl}/FsellerRefTrans'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userUid': userId,
        'referralId': referralId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to process referral transaction');
    }
  }
}