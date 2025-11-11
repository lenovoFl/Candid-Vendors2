import 'package:isar/isar.dart';

part 'VendorPolicyColl.g.dart';

// run command to generate file - flutter pub run build_runner build --delete-conflicting-outputs
// run command to use localhost api - adb reverse tcp:3636 tcp:3636

@collection
class VendorPolicyColl {
  Id? id;

  String vendorWarrantyPolicy;
  String vendorRefundPolicy;
  String vendorDelivery;
  String vendorPaymentPolicy;
  String vendorOtherPolicy;

  VendorPolicyColl({
    required this.vendorWarrantyPolicy,
    required this.vendorRefundPolicy,
    required this.vendorDelivery,
    required this.vendorPaymentPolicy,
    required this.vendorOtherPolicy,
  });
}
