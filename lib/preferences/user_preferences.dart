
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../Data/models/authentication/user_model.dart';


class PreferencesKey {
  static String User = "adminusermodel";

}

class UserPreferences {

  static UserPreferences shared = UserPreferences();
  //SharedPreferences prefsObj =  SharedPreferences.getInstance();
  //final SharedPreferences asyncPrefs = SharedPreferences.getInstance() as SharedPreferences;


  /// Save an entry into persistent user storage.
  setUser(User user) async {
    String jsonData = jsonEncode(user);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PreferencesKey.User, jsonData);
  }
  /// Get/Fetch an information from persistent user storage.
  Future<User?> getUser() async {
    User userInfo = User();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString(PreferencesKey.User);
    if ( (action != null) && (action.toString().length) > 0) {
      //print("data $action");
      final jsonData = json.decode(action!);
      userInfo = User.fromJson(jsonData);
      return userInfo;
    }
    return null;
  }

  /// Removes an entry from persistent user storage.
  void removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(PreferencesKey.User);
  }


}



class SharedPrefHelper {
  // Method to save a String
  static Future<void> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Method to fetch a String
  static Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Method to save an integer
  static Future<void> setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  // Method to fetch an integer
  static Future<int?> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // Method to save a boolean
  static Future<void> setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Method to fetch a boolean
  static Future<bool?> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  // Method to save a double
  static Future<void> setDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  // Method to fetch a double
  static Future<double?> getDouble(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  // Method to remove data for a specific key
  static Future<void> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Method to clear all stored data
  static Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
