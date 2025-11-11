import 'package:isar/isar.dart';

part 'StateColl.g.dart';

// run command to generate file - flutter pub run build_runner build --delete-conflicting-outputs
// run command to use localhost api - adb reverse tcp:3636 tcp:3636

@collection
class StateColl {
  Id? id; // you can also use id = null to auto increment

  @Index(unique: true, replace: true)
  final String stateID, stateName;

  StateColl({
    required this.stateID,
    required this.stateName,
  });
}
