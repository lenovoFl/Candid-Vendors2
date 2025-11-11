import 'package:isar/isar.dart';

part 'PolicyColl.g.dart';

// run command to generate file - flutter pub run build_runner build --delete-conflicting-outputs
// run command to use localhost api - adb reverse tcp:3636 tcp:3636

@collection
class PolicyColl {
  Id? id; // you can also use id = null to auto increment

  final String returnExchangePolicy,
      refundExchangeInDaysPolicy,
      warrantyPolicy,
      paymentPolicy,
      otherPolicy; // Add the "Other" policy field

  PolicyColl({
    required this.returnExchangePolicy,
    required this.refundExchangeInDaysPolicy,
    required this.warrantyPolicy,
    required this.paymentPolicy,
    required this.otherPolicy, // Initialize the "Other" policy field in the constructor
  });
}
