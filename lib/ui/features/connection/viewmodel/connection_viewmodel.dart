import 'package:flutter/material.dart';
import 'package:vault/data/repositories/connection/connection_repository.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/l10n/vault_localizations.dart';
import 'package:vault/utils/enums/connection_status.dart';
import 'package:vault/utils/result.dart';

class ConnectionViewModel extends ChangeNotifier {
  String _serverUrl = "";
  String _apiKey = "";
  ConnectionStatus status = ConnectionStatus.loading;
  String? errorMessage;

  final ConnectionRepository _connectionRepository;

  ConnectionViewModel({required ConnectionRepository connectionRepository})
    : _connectionRepository = connectionRepository {
    _init();
  }

  // If a pair of credentials already exists and works - auto connect
  Future<void> _init() async {
    final result = await _connectionRepository.testConnection(
      connection: ServerConnection(serverUrl: _serverUrl, apiKey: _apiKey),
    );
    status = switch (result) {
      Ok() => ConnectionStatus.connected,
      Error() => ConnectionStatus.disconnected,
    };
    notifyListeners();
  }

  bool get isConnectionFormValid =>
      Uri.parse(_serverUrl).isAbsolute && _apiKey.isNotEmpty;

  void updateServerUrl(String value) {
    _serverUrl = value;
    notifyListeners();
  }

  void updateApiKey(String value) {
    _apiKey = value;
    notifyListeners();
  }

  Future<bool> connect(AppLocalizations? localizations) async {
    status = ConnectionStatus.loading;
    notifyListeners();

    final result = await _connectionRepository.connect(
      serverUrl: _serverUrl,
      apiKey: _apiKey,
    );

    switch (result) {
      case Ok(value: final connection):
        final testResult = await _connectionRepository.testConnection(
          connection: connection,
        );

        switch (testResult) {
          case Ok():
            status = ConnectionStatus.connected;
            notifyListeners();
            return true;
          case Error(error: final e):
            status = ConnectionStatus.disconnected;
            errorMessage = localizations!.failedConnectionTestMessage(
              e.toString(),
            );
        }
      case Error(error: final e):
        status = ConnectionStatus.disconnected;
        errorMessage = localizations!.failedConnectionSaveMessage(e.toString());
    }

    notifyListeners();
    return false;
  }
}
