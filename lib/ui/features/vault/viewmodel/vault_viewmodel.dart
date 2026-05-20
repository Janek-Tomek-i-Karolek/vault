import 'package:flutter/material.dart';
import 'package:vault/data/repositories/vault/vault_repository.dart';
import 'package:vault/utils/enums/connection_status.dart';
import 'package:vault/utils/result.dart';

class VaultViewModel extends ChangeNotifier {
  String _serverUrl = "";
  String _apiKey = "";
  ConnectionStatus status = ConnectionStatus.loading;

  final VaultRepository _vaultRepository;

  VaultViewModel({required VaultRepository vaultRepository})
    : _vaultRepository = vaultRepository {
    _init();
  }

  Future<void> _init() async {
    final result = await _vaultRepository.testConnection();
    status = switch (result) {
      Ok() => ConnectionStatus.connected,
      Error() => ConnectionStatus.disconnected,
    };
    notifyListeners();
  }

  bool get isConnectionFormValid => _serverUrl.isNotEmpty && _apiKey.isNotEmpty;

  Future<void> connectToServer() async {
    debugPrint("connectToServer button pressed");
    Result<bool> testResult = await _vaultRepository.testConnection();
    switch (testResult) {
      case Ok():
        {
          debugPrint("Connected");
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
