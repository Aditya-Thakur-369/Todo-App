import 'package:shared_preferences/shared_preferences.dart';

class sharedpreference {
  static Future<bool> saveCredentials(String email, String password) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("email", email);
      await prefs.setString("password", password);
      return true; // Return true if saving is successful
    } catch (e) {
      print("Error saving credentials: $e");
      return false; // Return false if an error occurs
    }
  }

  static Future<bool> authenticateUser(String email, String password) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedEmail = prefs.getString("email");
      String? savedPassword = prefs.getString("password");
      return email == savedEmail && password == savedPassword;
    } catch (e) {
      print("Error authenticating user: $e");
      return false; // Return false if an error occurs
    }
  }
}
