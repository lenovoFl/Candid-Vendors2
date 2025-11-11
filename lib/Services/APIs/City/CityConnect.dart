import 'dart:isolate';

import 'package:candid_vendors/Services/Collections/App/AppDataColl.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

import '../../../Utils/Utils.dart';
import '../../../main.dart';
import '../../Collections/City/CityColl.dart';
import '../../Collections/State/StateColl.dart';

class CityConnect extends GetConnect {
  // run command to use localhost api - adb reverse tcp:5001 tcp:5001
  static getCityListApi() async {
    ReceivePort myReceivePort = ReceivePort();
    getCityListApiIsolate(List list) async {
      SendPort sendPort = list[0];
      final isar = await Isar.open(
        [StateCollSchema, CityCollSchema, AppDataCollSchema],
        directory: list[1].path,
      );
      Map<String, String> emptyBody = {};
      try {
        Response response = await GetConnect().post(
          '${Utils.apiUrl}/getStateCityList',
          emptyBody,
          headers: await Utils.getHeaders1(isar, list[2], list[3], list[4]),
        );
        debugPrint('getCityListApiIsolate | ${response.statusCode}');
        debugPrint('getCityListApiIsolate | ${response.body}');
        if (response.statusCode == 401) {
          utils.showSnackBar('session expired!');
          await utils.logOutUser();
          return sendPort.send(response.body.toString());
        } else if (response.statusCode == 200) {
          List<CityColl> cityList = [];
          List<StateColl> stateList = [];
          for (var city in response.body['data']) {
            var cityData = city['cityData'];
            cityList.add(CityColl(
                cityID: city['cityID'],
                cityName: cityData['cityName'],
                cityOfStateID: cityData['cityOfStateID']));
          }
          for (var state in response.body['stateList']) {
            var stateData = state['stateData'];
            stateList.add(StateColl(
              stateID: state['stateID'],
              stateName: stateData['stateName'],
            ));
          }
          await isar.writeTxn(() async {
            await isar.stateColls.putAll(stateList);
            await isar.cityColls.putAll(cityList);
          });
          return sendPort.send(response.body.toString());
        }
      } catch (e) {
        debugPrint('getCityListApiIsolate | catch | $e');
        return sendPort.send(e.toString());
      }
    }

    try {
      Isolate isolate = await Isolate.spawn(getCityListApiIsolate,
          [myReceivePort.sendPort, dir, null, await Utils.getToken(), localAppData]);
      debugPrint('DDD DATA getCityListApi : ${await myReceivePort.first}');
      isolate.kill();
    } catch (e) {
      debugPrint('getCityListApi CATCH: ${await myReceivePort.first}');
      debugPrint('getCityListApi CATCH: $e');
    } finally {
      debugPrint('getCityListApi finally called!');
      myReceivePort.close();
    }
  }
}
