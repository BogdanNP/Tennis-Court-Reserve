import 'dart:convert';

import 'package:court_reserve_app/models/token.dart';
import 'package:court_reserve_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  Future<bool> setToken(Token token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("token", jsonEncode(token.toJson()));
  }

  Future<Token> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String tokenEncoded = prefs.getString("token") ?? "";
    return Token.fromJson(jsonDecode(tokenEncoded));
  }

  Future<bool> setUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("user", jsonEncode(user.toJson()));
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userEncoded = prefs.getString("user") ?? "";
    return User.fromJson(jsonDecode(userEncoded));
  }

  Future<bool> setUserId(int userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt("userId", userId);
  }

  Future<int> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userId") ?? 0;
  }

  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
