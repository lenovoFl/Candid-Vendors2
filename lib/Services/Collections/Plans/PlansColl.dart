import 'package:isar/isar.dart';

part 'PlansColl.g.dart';

// run command to generate file - flutter pub run build_runner build --delete-conflicting-outputs
// run command to use localhost api - adb reverse tcp:3636 tcp:3636
// run command to use firebase localhost api - adb reverse tcp:5001 tcp:5001

@collection
class PlansColl {
  var id = Isar.autoIncrement; // you can also use id = null to auto increment

  @Index(unique: true, type: IndexType.value)
  final String subscriptionPlanID;

  final String subscriptionPlanName,
      subscriptionPlanStartDate,
      subscriptionPlanEndDate,
      subscriptionPlanCost;

  final int subscriptionPlanOfferCount;
  final String cityName;  // Added field
  final String cityId;
  bool isSelected;

  PlansColl(
      {required this.subscriptionPlanID,
      required this.subscriptionPlanName,
      required this.subscriptionPlanStartDate,
      required this.isSelected,
        required this.cityName,
        required this.cityId,
      required this.subscriptionPlanOfferCount,
      required this.subscriptionPlanEndDate,
      required this.subscriptionPlanCost});
}
