import 'package:isar/isar.dart';

part 'OffersCatColl.g.dart';

// run command to generate file - flutter pub run build_runner build --delete-conflicting-outputs
// run command to use localhost api - adb reverse tcp:3636 tcp:3636
// run command to use firebase localhost api - adb reverse tcp:5001 tcp:5001

@collection
class OffersCatColl {
  var id = Isar.autoIncrement; // you can also use id = null to auto increment

  @Index(unique: true, type: IndexType.value)
  final String catID;

  final String catImg, catName, catType;

  OffersCatColl(
      {required this.catID,
      required this.catImg,
      required this.catType,
      required this.catName});
}
