import 'package:isar/isar.dart';

part 'AccountData.g.dart';


@Collection()
class AccountColl {
  var id = Isar.autoIncrement;

  @Index(unique: true, type: IndexType.value)
  late String selectedOption1;
  late String selectedOption2;
  late String selectedFrequency;
  late String Likes;
  late String Saves;
  late String Reach;
  late String Prime;
  late String Shares;
  late String Opened;
  late int maxLimit;
  late int redeemed;

  // Fields for daily chart data
  late String day;
  late List<double> dailyChartData;

  AccountColl({
    required this.selectedOption1,
    required this.Likes,
    required this.Opened,
    required this.Prime,
    required this.Saves,
    required this.Shares,
    required this.Reach,
    required this.selectedOption2,
    required this.selectedFrequency,
    required this.maxLimit,
    required this.redeemed,
    required this.day,
    required this.dailyChartData,
  });
}
