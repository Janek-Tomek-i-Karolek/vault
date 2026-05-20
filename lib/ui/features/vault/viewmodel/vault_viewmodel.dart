import 'package:flutter/material.dart';
import 'package:vault/data/repositories/vault/vault_repository.dart';
import 'package:vault/utils/result.dart';

class VaultViewModel extends ChangeNotifier {
  String _serverUrl = "";
  String _apiKey = "";

  final VaultRepository _vaultRepository;

  VaultViewModel({required VaultRepository vaultRepository})
    : _vaultRepository = vaultRepository;

  bool get isConnectionFormValid => _serverUrl.isNotEmpty && _apiKey.isNotEmpty;

  Future<void> connectToServer() async {
    debugPrint("connectToServer button pressed");
    Result<String> testResult = await _vaultRepository.testConnection();
    switch (testResult) {
      case Ok():
        {
          debugPrint(testResult.value);
        }
      case Error():
        {
          debugPrint(testResult.error.toString());
        }
    }
  }

  void updateServerUrl(String value) {
    _serverUrl = value;
    notifyListeners();
  }

  void updateApiKey(String value) {
    _apiKey = value;
    notifyListeners();
  }

  void connect() {
    _vaultRepository.saveApiKey(_apiKey);
    _vaultRepository.saveUrl(_serverUrl);
    connectToServer();
  }
}
