import 'dart:convert';
import 'package:http/http.dart' as http;



class ApiServices {
  String razorpayKey = "rzp_live_mXMqD6Uq31IPNc";
  String razorpaySecret = "R31iM3MZyxPQdBtNmAPF4s9V";

  Future<Map<String, dynamic>> razorPayApi(num amount, String recieptId) async {
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
}


 // Future<Map<String, dynamic>> paymentFailureApi(String orderId) async {
 //   var auth = 'Basic ${base64Encode(utf8.encode('$razorpayKey:$razorpaySecret'))}';
//    var headers = {'content-type': 'application/json', 'Authorization': auth};
 //   var request = http.Request('POST', Uri.parse('https://api.razorpay.com/v1/payments/$orderId/capture'));
 //   request.body = json.encode({
  //    "amount": 0, // You might need to adjust this based on your requirements
  ////    "notes": {
  //      "reason": "Payment failed"
  //    }
 //   });
//    request.headers.addAll(headers);

 //   http.StreamedResponse response = await request.send();
  //  if (response.statusCode == 200) {
  //    return {
  //      "status": "success",
 //       "body": jsonDecode(await response.stream.bytesToString())
  //    };
  //  } else {
  //    return {"status": "fail", "message": response.reasonPhrase};
  //  }
//  }

//  Future<Map<String, dynamic>> paymentCancellationApi(String orderId) async {
//    var auth = 'Basic ${base64Encode(utf8.encode('$razorpayKey:$razorpaySecret'))}';
 //   var headers = {'content-type': 'application/json', 'Authorization': auth};
//    var request = http.Request('POST', Uri.parse('https://api.razorpay.com/v1/payments/$orderId/cancel'));
 //   request.body = json.encode({
 ////     "cancel_reason": "Payment cancelled by user"
 //   });
 //   request.headers.addAll(headers);

  //  http.StreamedResponse response = await request.send();
  //  if (response.statusCode == 200) {
 //     return {
 //       "status": "success",
 //       "body": jsonDecode(await response.stream.bytesToString())
  //    };
 //   } else {
  //    return {"status": "fail", "message": response.reasonPhrase};
  //  }
 // }
//}
