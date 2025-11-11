import 'package:isar/isar.dart';

part 'NotificationColl.g.dart';

// run command to generate file - flutter pub run build_runner build
// run command to use localhost api - adb reverse tcp:3636 tcp:3636
// run command to use firebase localhost api - adb reverse tcp:5001 tcp:5001

@collection
class NotificationColl {
  var id = Isar.autoIncrement; // you can also use id = null to auto increment

  @Index(unique: true, replace: true)
  final String notificationID, title, body, imageUrl;

  bool isSeen;

  NotificationColl(
      {required this.notificationID,
        required this.title,
        required this.body,
        required this.imageUrl,
        required this.isSeen});


}
