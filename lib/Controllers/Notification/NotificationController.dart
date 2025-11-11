import 'package:candid_vendors/Services/APIs/Notification/NotificationConnect.dart';
import 'package:candid_vendors/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import '../../Services/Collections/Notification/NotificationColl.dart';

class NotificationController extends GetxController {
  bool isLoading = false;
  List<NotificationColl> notifications = [];
  int isNotSeenNotifications = 0;
  RxInt unreadNotificationCount = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    try {
      isar.notificationColls
          .where()
          .watch(fireImmediately: true)
          .listen((notificationList) => updateAllNotifications(notificationList));
      await fetchNotifications();
      await NotificationConnect.updateVendorNotificationsToReadAllApi(
          localSeller, localAppData);
    } catch (e) {
      debugPrint('NotificationController | onInit | CATCH | $e');
    }
  }

  void triggerOfferCreatedNotification() {
    var uuid = const Uuid();
    String notificationID = uuid.v4(); // Generate a unique ID
    NotificationColl notification = NotificationColl(
      notificationID: notificationID,
      title: 'Candid Offers',
      body: "Your offer is created successfully!",
      imageUrl: '', // Add an image URL if needed
      isSeen: false,
    );
    notifications.add(notification);
    updateAllNotifications(notifications);
    saveNotificationToDatabase(notification);
    sendNotificationToFirebase(notification);// Save to database
    update(); // Ensure the UI is updated after adding the notification
  }


  void triggerRechargeNotification() {
    var uuid = const Uuid();
    String notificationID = uuid.v4();
    NotificationColl notification = NotificationColl(
      notificationID: notificationID , // Generate a unique ID
      title: 'Candid Offers',
      body: "Recharge successfull For offer coupen will be credited your account!",
      imageUrl: '', // Add an image URL if needed
      isSeen: false,
    );
    notifications.add(notification);
    updateAllNotifications(notifications);
    saveNotificationToDatabase(notification);
    sendNotificationToFirebase(notification);
    update();
    // Save to database
  }
  void triggerAccountCreationNotification() {
    var uuid = const Uuid();
    String notificationID = uuid.v4();
    NotificationColl notification = NotificationColl(
      notificationID: notificationID , // Generate a unique ID
      title: 'Candid Offers',
      body: "Your Seller Account is Created Succesfully!",
      imageUrl: '', // Add an image URL if needed
      isSeen: false,
    );
    notifications.add(notification);
    updateAllNotifications(notifications);
    saveNotificationToDatabase(notification);
    sendNotificationToFirebase(notification);
    update();
    // Save to database
  }

  void triggerOfferLiveNotification() {
    var uuid = const Uuid();
    String notificationID = uuid.v4();
    NotificationColl notification = NotificationColl(
      notificationID: notificationID ,// Generate a unique ID
      title: 'Candid Offers',
      body: "Your offer Status set Live successfully",
      imageUrl: '', // Add an image URL if needed
      isSeen: false,
    );
    notifications.add(notification);
    updateAllNotifications(notifications);
    saveNotificationToDatabase(notification);
    sendNotificationToFirebase(notification);
    update(); // Save to database
  }

 void triggerOffergoesForReviewNotification() {
    var uuid = const Uuid();
    String notificationID = uuid.v4();
    NotificationColl notification = NotificationColl(
      notificationID: notificationID ,// Generate a unique ID
      title: 'Candid Offers',
      body: "Your offer Has been submitted For Review !",
      imageUrl: '', // Add an image URL if needed
      isSeen: false,
    );
    notifications.add(notification);
    updateAllNotifications(notifications);
    saveNotificationToDatabase(notification);
    sendNotificationToFirebase(notification);
    update(); // Save to database
  }

  void triggerRejectedOfferNotification() {
    var uuid = const Uuid();
    String notificationID = uuid.v4();
    NotificationColl notification = NotificationColl(
      notificationID: notificationID ,// Generate a unique ID
      title: 'Candid Offers',
      body: "Your offer Has Been Rejected for more info contact us",
      imageUrl: '', // Add an image URL if needed
      isSeen: false,
    );
    notifications.add(notification);
    updateAllNotifications(notifications);
    saveNotificationToDatabase(notification);
    sendNotificationToFirebase(notification);
    update(); // Save to database
  }

  void triggerOfferOutOfStockNotification() {
    var uuid = const Uuid();
    String notificationID = uuid.v4();
    NotificationColl notification = NotificationColl(
      notificationID: notificationID ,// Generate a unique ID
      title: 'Candid Offers',
      body: "Your offer are out of stock",
      imageUrl: '', // Add an image URL if needed
      isSeen: false,
    );
    notifications.add(notification);
    updateAllNotifications(notifications);
    saveNotificationToDatabase(notification);
    sendNotificationToFirebase(notification);
    update(); // Save to database
  }

  void triggerOfferReddemkNotification() {
    var uuid = const Uuid();
    String notificationID = uuid.v4();
    NotificationColl notification = NotificationColl(
      notificationID: notificationID , // Generate a unique ID
      title: 'Candid Offers',
      body: "Your offer Has been redeemed",
      imageUrl: '', // Add an image URL if needed
      isSeen: false,
    );
    notifications.add(notification);
    updateAllNotifications(notifications);
    saveNotificationToDatabase(notification);
    sendNotificationToFirebase(notification);
    update(); // Save to database
  }

  void triggerSubscriptionendNotification() {
    var uuid = const Uuid();
    String notificationID = uuid.v4();
    NotificationColl notification = NotificationColl(
      notificationID: notificationID , // Generate a unique ID
      title: 'Candid Offers',
      body: "Your plan has been expired within few days plz Reactivate your Plan",
      imageUrl: '', // Add an image URL if needed
      isSeen: false,
    );
    notifications.add(notification);
    updateAllNotifications(notifications);
    saveNotificationToDatabase(notification);
    sendNotificationToFirebase(notification);
    update(); // Save to database
  }

  void addNotification(NotificationColl notification) {
    notifications.add(notification);
    if (!notification.isSeen) {
      unreadNotificationCount.value++;
    }
    update();
  }

  void onNotificationTriggered() {
    NotificationController notificationController = Get.find<NotificationController>();
    notificationController.triggerOfferCreatedNotification();
  }

  void addHardcodedNotification(String message) {
    NotificationColl notification = NotificationColl(
      notificationID: '123', // You may generate a unique ID
      title: 'Candid Offers',
      body: message,
      imageUrl: '', // You may add an image URL if needed
      isSeen: false,
    );
    notifications.add(notification);
    updateAllNotifications(notifications);
    updateUnseenNotificationsCount();
    update();
  }

  void updateUnseenNotificationsCount() {
    // Update the count of unseen notifications
    isNotSeenNotifications = notifications.where((n) => !n.isSeen).length;
    update();
  }

  Future<void> fetchNotifications() async {
    try {
      // Fetch notifications from Firebase
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore.collection('notifications').get();
      List<NotificationColl> firebaseNotifications = querySnapshot.docs.map((doc) {
        return NotificationColl(
          notificationID: doc['notificationID'],
          title: doc['title'],
          body: doc['body'],
          imageUrl: doc['imageUrl'],
          isSeen: doc['isSeen'],
        );
      }).toList();

      // Save fetched notifications to Isar
      await isar.writeTxnSync(() async {
        isar.notificationColls.putAllSync(firebaseNotifications);
      });
      updateAllNotifications(firebaseNotifications);
      // Optionally, fetch additional notifications from Isar if needed
      // This step depends on how you manage notifications in Isar
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    }
    update();
  }


  void markNotificationAsRead(String notificationID) {
    NotificationColl notification = notifications.firstWhere(
          (n) => n.notificationID == notificationID,
      orElse: () => throw Exception('Notification not found'),
    );

    if (!notification.isSeen) {
      notification.isSeen = true;
      unreadNotificationCount.value--;
      saveNotificationToDatabase(notification);
    }
    update();
  }


  Future<void> saveNotificationToDatabase(NotificationColl notification) async {
    await isar.writeTxn<dynamic>(() async {
      await isar.notificationColls.put(notification);
      return null;
    });
    update();
  }

  Future<void> sendNotificationToFirebase(NotificationColl notification) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('notifications').add({
      'notificationID': notification.notificationID,
      'title': notification.title,
      'body': notification.body,
      'imageUrl': notification.imageUrl,
      'isSeen': notification.isSeen,
      // Add any other fields you need
    });
  }

  void updateAllNotifications(List<NotificationColl> updatedNotifications) {
    notifications = updatedNotifications;
    int count = 0;
    for (var notification in updatedNotifications) {
      if (!notification.isSeen) {
        count++;
      }
    }
    // Update the count of unread notifications
    unreadNotificationCount.value = count;
    update(); // Ensure the UI is updated
  }
}