import 'package:flutter/material.dart';
import 'package:vault/data/repositories/connection/connection_repository.dart';
import 'package:vault/domain/album/server_connection.dart';
import 'package:vault/utils/result.dart';

class ServersViewModel extends ChangeNotifier {
  List<ServerConnection> servers = [];

  final ConnectionRepository _connectionRepository;

  ServersViewModel({required ConnectionRepository connectionRepository})
    : _connectionRepository = connectionRepository {
    _loadServers();
  }

  Future<void> _loadServers() async {
    final result = await _connectionRepository.getConnections();

    switch (result) {
      case Ok(value: final loadedServers):
        servers = loadedServers;

      case Error():
        servers = [];
    }

    notifyListeners();
    await refreshServers();
  }

  Future<void> refreshServers() async {
    await _loadServers();
  }

  Future<void> disconnect(String serverUrl) async {
    await _connectionRepository.disconnect(serverUrl: serverUrl);
    await _loadServers();
  }
}
