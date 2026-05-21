import 'package:flutter/material.dart';
import 'package:vault/data/repositories/connection/connection_repository.dart';
import 'package:vault/utils/enums/connection_status.dart';
import 'package:vault/utils/result.dart';

class ConnectionViewModel extends ChangeNotifier {
  String _serverUrl = "";
  String _apiKey = "";
  ConnectionStatus status = ConnectionStatus.loading;

  final ConnectionRepository _connectionRepository;

  ConnectionViewModel({required ConnectionRepository connectionRepository})
    : _connectionRepository = connectionRepository {
    _init();
  }

  // If a pair of credentials already exists and works - auto connect
  Future<void> _init() async {
    final result = await _connectionRepository.testConnection();
    status = switch (result) {
      Ok() => ConnectionStatus.connected,
      Error() => ConnectionStatus.disconnected,
    };
    notifyListeners();
  }

  bool get isConnectionFormValid => _serverUrl.isNotEmpty && _apiKey.isNotEmpty;

  void updateServerUrl(String value) {
    _serverUrl = value;
    notifyListeners();
  }

  void updateApiKey(String value) {
    _apiKey = value;
    notifyListeners();
  }

  Future<void> connect() async {
    status = ConnectionStatus.loading;
    notifyListeners();

    final result = await _connectionRepository.connect(
      url: _serverUrl,
      apiKey: _apiKey,
    );
    status = switch (result) {
      Ok() => ConnectionStatus.connected,
      Error() => ConnectionStatus.disconnected,
    };

    notifyListeners();
  }

  Future<void> disconnect() async {
    status = ConnectionStatus.loading;
    notifyListeners();

    final result = await _connectionRepository.disconnect();
    status = switch (result) {
      Ok() => ConnectionStatus.disconnected,
      Error() => ConnectionStatus.connected,
    };

    notifyListeners();
  }
}
