import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:candid_vendors/Services/Collections/Offers/OffersCat/OffersCatColl.dart';
import 'package:candid_vendors/Utils/Utils.dart';
import 'package:candid_vendors/main.dart';
import 'package:get/get.dart';

class CatsConnect extends GetConnect {

  Future<void> getCatsList() async {
    try {
      final response = await http.post(
        Uri.parse('${Utils.apiUrl}/getCatsList'),
        body: json.encode({'userPhone': firebaseAuth.currentUser!.phoneNumber}),
        headers: await Utils().getHeaders(),
      ).timeout(const Duration(seconds: 10)); // Add a timeout

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        List<OffersCatColl> catsList = [];
        for (var cat in responseData['catsList']) {
          var catData = cat['catsData'];
          catsList.add(OffersCatColl(
            catID: cat['id'],
            catImg: catData['catImg'],
            catType: catData['catType'],
            catName: catData['catName'],
          ));
        }
        await isar.writeTxn(() async {
          await isar.offersCatColls.clear();
          await isar.offersCatColls.putAll(catsList);
        });
      } else if (response.statusCode == 401) {
        utils.showSnackBar('Session expired!');
        // await Utils().logOutUser();
      } else {
        throw HttpException('Failed to fetch categories: ${response.statusCode}');
      }
    } on TimeoutException {
      throw TimeoutException('Connection timed out. Please check your internet and try again.');
    } on SocketException {
      throw const SocketException('No internet connection. Please check your network and try again.');
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}