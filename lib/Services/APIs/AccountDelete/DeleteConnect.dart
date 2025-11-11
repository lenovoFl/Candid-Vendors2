import 'package:candid_vendors/main.dart';
import 'package:http/http.dart' as http;

import '../../../Screens/Profile/SettingsScreen.dart';
import '../../../Utils/Utils.dart';

Future<void> deleteAccount(String sessionCookie) async {
  try {
    // Construct headers including sessionCookie
    Map<String, String> headers = await utils.getHeaders();
    headers['Cookie'] = sessionCookie;

    // Make API call
    final response = await http.post(
      Uri.parse('${Utils.apiUrl}/soft-delete-user'),
      headers: headers,
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Log successful deletion
      print('Account deleted successfully');
      // aCall logout function
      await logOutUser();
    } else {
      // Log error if deletion fails
      print('Failed to delete account: ${response.statusCode}');
      // Log detailed error message if available
      print('Error response body: ${response.body}');
    }
  } catch (e) {
    // Handle any other errors
    print('Error deleting account: $e');
  }
}
