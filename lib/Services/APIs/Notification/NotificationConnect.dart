import 'dart:isolate';

import 'package:candid_vendors/Services/Collections/Notification/NotificationColl.dart';
import 'package:candid_vendors/Services/Collections/User/VendorUserColl.dart';
import 'package:candid_vendors/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../Utils/Utils.dart';
import '../../Collections/App/AppDataColl.dart';

class NotificationConnect extends GetConnect {
  static getVendorNotificationsApi(
      VendorUserColl localSeller, AppDataColl localAppData) async {
    ReceivePort myReceivePort = ReceivePort();
    getVendorNotificationsApiIsolate(List list) async {
      SendPort sendPort = list[0];

      // Ensure the binary messenger is initialized
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase in the isolate
      await Firebase.initializeApp();

      final isar = await Isar.open(
        [NotificationCollSchema, AppDataCollSchema],
        directory: list[1].path,
      );
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot =
          await firestore.collection('notifications').get();
      List<NotificationColl> firebaseNotifications =
          querySnapshot.docs.map((doc) {
        return NotificationColl(
          notificationID: doc['notificationID'],
          title: doc['title'],
          body: doc['body'],
          imageUrl: doc['imageUrl'],
          isSeen: doc['isSeen'],
        );
      }).toList();

      Response res = await GetConnect().post(
          '${Utils.apiUrl}/getVendorNotifications', {},
          headers: await Utils.getHeaders1(
              isar, localSeller, list[3], localAppData));
      debugPrint('getVendorNotificationsApi | ${res.statusCode}');
      debugPrint('getVendorNotificationsApi | ${res.body}');

      debugPrint(
          'getVendorNotificationsApi headers | ${await Utils.getHeaders1(isar, list[2], list[3], list[4])}');

      if (res.statusCode != 200) {
        return sendPort.send(res.body.toString());
        // return throw res.body.toString();
      }
      if (res.body.containsKey("vendorNotificationList")) {
        List<NotificationColl> list = [];
        for (var notification in res.body['vendorNotificationList'] ?? []) {
          list.add(NotificationColl(
              notificationID: notification['notificationID'],
              title: notification['title'],
              body: notification['body'],
              imageUrl: notification['imageUrl'],
              isSeen: notification['isSeen']));
        }
        await isar.writeTxnSync(() async {
          isar.notificationColls.putAllSync(firebaseNotifications);
        });
        return sendPort.send(res.body.toString());
      } else {
        return sendPort.send(res.body.toString());
        // return throw res.body.toString();
      }
    }

    try {
      Isolate isolate = await Isolate.spawn(getVendorNotificationsApiIsolate, [
        myReceivePort.sendPort,
        dir,
        localSeller,
        await Utils.getToken(),
        localAppData
      ]);
      debugPrint('DDD DATA: ${await myReceivePort.first}');
      isolate.kill();
    } catch (e) {
      debugPrint(
          'getVendorNotificationsApi CATCH: ${await myReceivePort.first}');
      debugPrint('getVendorNotificationsApi CATCH: $e');
    } finally {
      myReceivePort.close();
    }
  }

  static updateVendorNotificationsToReadAllApi(
      VendorUserColl localSeller, AppDataColl localAppData) async {
    ReceivePort myReceivePort = ReceivePort();
    updateVendorNotificationsToReadAllApiIsolate(List list) async {
      SendPort sendPort = list[0];

      // Ensure the binary messenger is initialized
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase in the isolate
      await Firebase.initializeApp();

      final isar = await Isar.open(
        [AppDataCollSchema, NotificationCollSchema],
        directory: list[1],
      );
      Map<String, String> emptyBody = {};
      try {
        Response response = await GetConnect().post(
          '${Utils.apiUrl}/updateVendorNotificationsToReadAll',
          emptyBody,
          headers: await Utils.getHeaders1(isar, list[2], list[3], list[4]),
        );
        debugPrint(
            'updateVendorNotificationsToReadAllApiIsolate | ${response.statusCode}');
        debugPrint('updateVendorNotificationsToReadAll | ${response.body}');
        if (response.statusCode == 401) {
          utils.showSnackBar('session expired!');
          await utils.logOutUser();
          return sendPort.send(response.body.toString());
        } else if (response.statusCode == 200) {
          List<NotificationColl> notificationList = await isar.notificationColls
              .filter()
              .isSeenEqualTo(false)
              .build()
              .findAll();
          for (var notification in notificationList) {
            notification.isSeen = true;
          }
          isar.writeTxnSync(
              () => isar.notificationColls.putAllSync(notificationList));
          return sendPort.send(response.body.toString());
        }
      } catch (e) {
        debugPrint('updateVendorNotificationsToReadAllApiIsolate | $e');
        return sendPort.send(e.toString());
      }
    }

    try {
      Isolate isolate =
          await Isolate.spawn(updateVendorNotificationsToReadAllApiIsolate, [
        myReceivePort.sendPort,
        dir.path,
        localSeller,
        await Utils.getToken(),
        localAppData
      ]);
      debugPrint(
          'DDD DATA updateVendorNotificationsToReadAllApi : ${await myReceivePort.first}');
      isolate.kill();
    } catch (e) {
      debugPrint(
          'updateVendorNotificationsToReadAllApi CATCH: ${await myReceivePort.first}');
      debugPrint('updateVendorNotificationsToReadAllApi CATCH: $e');
    } finally {
      debugPrint('updateVendorNotificationsToReadAllApi finally called!');
      myReceivePort.close();
    }
  }
}
