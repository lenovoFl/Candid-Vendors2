import 'package:isar/isar.dart';

part 'StoreColl.g.dart';

@Collection()
class StoreColl {
  var id = Isar.autoIncrement;

  @Index(unique: true, type: IndexType.value)

  late String storeName;
  late String areaName;
  late String mapLocation;
  late String logoUrl;
  late String googleUrl;
  late String instagramUrl;
  late String youtubeUrl;
  late String facebookUrl;
  // Add other fields as needed

  StoreColl({
    required this.storeName,
    required this.areaName,
    required this.mapLocation,
    required this.logoUrl,
    required this.googleUrl,
    required this.instagramUrl,
    required this.youtubeUrl,
    required this.facebookUrl,
    // Add other fields as needed
  });
}