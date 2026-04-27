import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  String _email = "";
  String _login = "";
  String _password = "";
  Color _buttonColor = Colors.grey;

  Color get buttonColor => _buttonColor;

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
    checkButton();
  }

  void updateLogin(String value) {
    _login = value;
    checkButton();
  }

  void updatePassword(String value) {
    _password = value;
    checkButton();
  }

  // TODO: Add some more advanced validation logic (regex and stuff)
  void checkButton() {
    if ((_email != "" || _login != "") && _password != "") {
      _buttonColor = Colors.green;
    } else {
      _buttonColor = Colors.grey;
    }
    notifyListeners();
  }
}
