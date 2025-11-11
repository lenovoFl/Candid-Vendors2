import 'dart:convert';
import 'package:candid_vendors/Controllers/Auth/CreateProfileController.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../Utils/Utils.dart';
import '../../../main.dart';

class ChampionConnect extends GetConnect {
  Future getChampionsListApi(
      CreateProfileController createProfileController) async {
    try {
      String endpoint =
          'https://us-central1-candid-cf9fc.cloudfunctions.net/getChampionData';
      debugPrint('Attempting to fetch data from: $endpoint');

      http.Response res = await http.post(
        Uri.parse(endpoint),
        headers: await utils.getHeaders(),
      );

      if (res.statusCode == 200) {
        if (res.body != null && res.body.isNotEmpty) {
          Map jsonResponse = jsonDecode(res.body);
          if (jsonResponse.containsKey('championData')) {
            List championData = jsonResponse['championData'];

            createProfileController.championList.clear();
            for (var champion in championData) {
              if (champion is Map &&
                  champion.containsKey('championId') &&
                  champion['championTypeTitle'] == 'Champion') {
                String id = champion['championId'].toString();
                String name = champion['championName'] ?? id;
                String mobile = champion['mobile'] ??
                    ''; // Use 'mobile' field for the number
                createProfileController.championList.add('$name|$id|$mobile');
              }
            }

            // Do not set default values here; let the dropdown selection handle it
            if (createProfileController.championList.isEmpty) {
              debugPrint('Warning: ChampionList is empty');
            }
          } else {
            debugPrint('Error: championData key not found in response');
          }
        } else {
          debugPrint('Error: Response body is null or empty');
        }
      } else if (res.statusCode == 401) {
        debugPrint('Error: Unauthorized. Please check authentication.');
        await utils.logOutUser();
      } else {
        debugPrint(
            'Error: Failed to load champions list. Status code: ${res.statusCode}');
        debugPrint('Response body: ${res.body}');
      }
    } catch (e) {
      debugPrint('Error in getChampionsListApi: $e');
    }
  }
}
