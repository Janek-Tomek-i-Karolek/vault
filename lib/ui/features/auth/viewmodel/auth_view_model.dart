import 'package:flutter/material.dart';
import 'package:vault/domain/user/user.dart';

class AuthViewModel extends ChangeNotifier {
  String _email = "";
  String _login = "";
  String _password = "";

  bool get isRegisterFormValid =>
      User.email.isNotEmpty &&
      User.username.isNotEmpty &&
      _password.length >= 6;

  bool get isLoginFormValid =>
      User.username.isNotEmpty && _password.length >= 6;

  Future<void> login() async {
    debugPrint("Login button pressed");
    debugPrint("Logging in with data: ${User.username}, $_password");
  }

  Future<void> register() async {
    debugPrint("Register button pressed");
    debugPrint(
      "Registering with data: ${User.email}, ${User.username}, $_password",
    );
  }

  Future<void> forgotPassword() async {
    debugPrint("Forgot password button pressed");
  }

  void updateEmail(String value) {
    User.email = value;
    notifyListeners();
  }

  void updateLogin(String value) {
    User.username = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }
}
