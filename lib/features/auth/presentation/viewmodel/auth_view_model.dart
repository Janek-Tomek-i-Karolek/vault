import 'package:flutter/foundation.dart';

class AuthViewModel extends ChangeNotifier {
  String _email = "";
  String _login = "";
  String _password = "";

  Future<void> login() async {
    debugPrint("Login button pressed");
  }

  Future<void> register() async {
    debugPrint("Register button pressed");
  }

  void updateEmail(String value) {
    _email = value;
  }

  void updateLogin(String value) {
    _login = value;
  }

  void updatePassword(String value) {
    _password = value;
  }
}
