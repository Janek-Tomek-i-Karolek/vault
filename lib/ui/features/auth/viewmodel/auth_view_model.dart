import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  String _email = "";
  String _login = "";
  String _password = "";

  bool get isRegisterFormValid =>
      _email.isNotEmpty && _login.isNotEmpty && _password.length >= 6;

  bool get isLoginFormValid => _login.isNotEmpty && _password.length >= 6;

  Future<void> login() async {
    debugPrint("Login button pressed");
    debugPrint("Logging in with data: $_login, $_password");
  }

  Future<void> register() async {
    debugPrint("Register button pressed");
    debugPrint("Registering with data: $_email, $_login, $_password");
  }

  Future<void> forgotPassword() async {
    debugPrint("Forgot password button pressed");
  }

  void updateEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void updateLogin(String value) {
    _login = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }
}
