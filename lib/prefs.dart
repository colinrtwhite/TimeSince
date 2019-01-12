///
/// Copyright (C) 2018 Andrious Solutions
///
/// This program is free software; you can redistribute it and/or
/// modify it under the terms of the GNU General Public License
/// as published by the Free Software Foundation; either version 3
/// of the License, or any later version.
///
/// You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  05 Jun 2018
///
library prefs;

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Prefs {

  static SharedPreferences _instance;

  /// Initialize the SharedPreferences object in the State object's iniState() function.
  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  /// Returns all keys in the persistent storage.
  static Set<String> getKeys() => _instance.getKeys();

  /// Reads a value of any type from persistent storage.
  static dynamic get(String key) => _instance.get(key);

  static bool getBool(String key, [bool fallback = false]) {
    return _instance.getBool(key) ?? fallback;
  }

  static int getInt(String key, [int fallback = 0]) {
    return _instance.getInt(key) ?? fallback;
  }

  static double getDouble(String key, [double fallback = 0.0]) {
    return _instance.getDouble(key) ?? fallback;
  }

  static String getString(String key, [String fallback = ""]) {
    return _instance.getString(key) ?? fallback;
  }

  static List<String> getStringList(String key) {
    return _instance.getStringList(key) ?? [];
  }

  /// Saves a boolean [value] to persistent storage in the background.
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  static Future<bool> setBool(String key, bool value) {
    return _instance.setBool(key, value);
  }

  /// Saves an integer [value] to persistent storage in the background.
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  static Future<bool> setInt(String key, int value) {
    return _instance.setInt(key, value);
  }

  /// Saves a double [value] to persistent storage in the background.
  /// Android doesn't support storing doubles, so it will be stored as a float.
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  static Future<bool> setDouble(String key, double value) {
    return _instance.setDouble(key, value);
  }

  /// Saves a string [value] to persistent storage in the background.
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  static Future<bool> setString(String key, String value) {
    return _instance.setString(key, value);
  }

  /// Saves a list of strings [value] to persistent storage in the background.
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  static Future<bool> setStringList(String key, List<String> value) {
    return _instance.setStringList(key, value);
  }

  /// Removes an entry from persistent storage.
  static Future<bool> remove(String key) => _instance.remove(key);

  /// Completes with true once the user preferences for the app has been cleared.
  static Future<bool> clear() => _instance.clear();
}
