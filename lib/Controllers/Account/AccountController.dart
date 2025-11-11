import 'package:isar/isar.dart';


import '../../Services/Collections/Account/AccountData.dart'; // Import your Isar collection model

class AccountController {
  static Future<AccountColl?> fetchAccountData(int accountId) async {
    try {
      final isar = Isar.getInstance();
      return isar?.accountColls.get(accountId); // Assuming the ID of the account data you want to retrieve is passed as an argument
    } catch (e) {
      return null;
    }
  }
}
