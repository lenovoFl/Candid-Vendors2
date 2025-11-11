import 'package:candid_vendors/Controllers/Notification/NotificationController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../Services/Collections/Notification/NotificationColl.dart';

class NotificationCard extends StatelessWidget {
  final String headline, description, notificationID;
  final bool isSeen;
  final VoidCallback? onTap;

  const NotificationCard({
    Key? key,
    required this.headline,
    required this.description,
    required this.notificationID,
    required this.isSeen,
    this.onTap,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 320,
        height: 120,
        child: Center(
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 320,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 42,
                child: SizedBox(
                  width: 278,
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Aileron',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.02,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 15,
                child: Text(
                  headline,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Aileron',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.02,
                  ),
                ),
              ),
              Positioned(
                left: 15,
                top: 90,
                child: Visibility(
                  visible: !isSeen,
                  child: const SizedBox(
                    width: 144,
                    height: 15,
                    child: Text(
                      'Mark as Read',
                      style: TextStyle(
                        color: Color(0xFF727173),
                        fontSize: 12,
                        fontFamily: 'Aileron',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.02,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 294,
                top: 16,
                child: Visibility(
                  visible: !isSeen,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text(
          'Notifications',
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
      body: GetBuilder<NotificationController>(
        init: NotificationController(),
        builder: (controller) {
          return controller.notifications.isEmpty
              ? const Center(child: Text('No notifications'))
              : Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.builder(
                  itemCount: controller.notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Start from the beginning of the notifications list
                    NotificationColl notification = controller.notifications[index];
                    return Center(
                      child: NotificationCard(
                        headline: notification.title,
                        description: notification.body,
                        notificationID: notification.notificationID, // Pass the notificationID
                        isSeen: notification.isSeen,
                        onTap: () {
                          if (!notification.isSeen) {
                            controller.markNotificationAsRead(notification.notificationID); // Use notificationID here
                          }
                        },
                      ),

                    );
                  },
                )
            ),
          );
        },
      ),
    );
  }
}