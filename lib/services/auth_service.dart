import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mock authentication layer supporting username and pseudo Google login.
class AuthService extends ChangeNotifier {
  static const _usernameKey = 'mindmirror_username';

  String? _username;
  bool get isAuthenticated => _username != null;
  String get username => _username ?? 'MindMirror';

  /// Loads persisted username from [SharedPreferences].
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString(_usernameKey);
    notifyListeners();
  }

  /// Simulates username based login.
  Future<void> loginWithUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    _username = username;
    notifyListeners();
  }

  /// Provides a playful mock google login storing placeholder name.
  Future<void> loginWithGoogle() async {
    await loginWithUsername('Lavanta Kullanıcısı');
  }

  /// Clears local user session.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    _username = null;
    notifyListeners();
  }
}
