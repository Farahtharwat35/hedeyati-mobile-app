import 'package:shared_preferences/shared_preferences.dart';

class UserCredentials {
  static Future<void> saveCredentials(String uID) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uID', uID);
  }

  static Future<String?> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    String? uID = prefs.getString('uID');
    print('------------------User ID: $uID');
    return uID;
  }

}