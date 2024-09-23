import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> signIn(String email, String password) async {
    // TODO: Implement actual authentication logic
    await Future.delayed(Duration(seconds: 2)); // Simulating network request
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    // TODO: Implement actual sign out logic
    await Future.delayed(Duration(seconds: 1)); // Simulating network request
    _isAuthenticated = false;
    notifyListeners();
  }
}
