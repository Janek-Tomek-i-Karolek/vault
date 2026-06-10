import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/utils/result.dart';
import 'package:http/http.dart';

abstract interface class ConnectionRepository {
  Future<Result<ServerConnection>> connect({
    required String serverUrl,
    required String apiKey,
  });
  Future<Result<void>> disconnect({required String serverUrl});
  Future<Result<bool>> testConnection({required ServerConnection connection});
  Future<Result<List<String>>> getServers({required String userId});
  Future<Result<List<ServerConnection>>> getConnections();
  Future<Result<ServerConnection>> getConnectionByUrl({
    required String serverUrl,
  });
}

class LocalConnectionRepository implements ConnectionRepository {
  final _storage = const FlutterSecureStorage();
  static const _connectionsKey = 'server_connections';

  @override
  Future<Result<ServerConnection>> connect({
    required String serverUrl,
    required String apiKey,
  }) async {
    final newConnection = ServerConnection(
      serverUrl: serverUrl,
      apiKey: apiKey,
    );

    switch (await testConnection(connection: newConnection)) {
      case Error(:final error):
        return Result.error(Exception("Connection to server failed: $error"));
      case Ok():
    }

    switch (await _loadConnections()) {
      case Error(:final error):
        return Result.error(Exception("Failed to load connections: $error"));
      case Ok(:final value):
        final connections = value;

        final index = connections.indexWhere((c) => c.serverUrl == serverUrl);
        if (index >= 0) {
          connections[index] = newConnection;
        } else {
          connections.add(newConnection);
        }

        switch (await _saveConnections(connections)) {
          case Error(:final error):
            return Result.error(
              Exception("Failed to save connections: $error"),
            );
          case Ok():
        }

        return Result.ok(newConnection);
    }
  }

  @override
  Future<Result<void>> disconnect({required String serverUrl}) async {
    switch (await _loadConnections()) {
      case Error(:final error):
        return Result.error(Exception("Failed to load connections: $error"));
      case Ok(:final value):
        final connections = value..removeWhere((c) => c.serverUrl == serverUrl);
        return _saveConnections(connections);
    }
  }

  @override
  Future<Result<bool>> testConnection({
    required ServerConnection connection,
  }) async {
    final uri = Uri.parse("${connection.serverUrl}/api/users/me");

    final immichApiHeaders = {
      "Content-Type": "application/json",
      "x-api-key": connection.apiKey,
    };
    try {
      final response = await get(uri, headers: immichApiHeaders);

      if (response.statusCode != 200) {
        return Result.error(
          Exception(
            "Failed to connect to server: received status code ${response.statusCode}",
          ),
        );
      }
      return Result.ok(true);
    } catch (e) {
      return Result.error(Exception("Connection failed: $e"));
    }
  }

  @override
  Future<Result<List<ServerConnection>>> getConnections() => _loadConnections();

  @override
  Future<Result<ServerConnection>> getConnectionByUrl({
    required String serverUrl,
  }) async {
    switch (await _loadConnections()) {
      case Error(:final error):
        return Result.error(error);
      case Ok(:final value):
        try {
          final connection = value.firstWhere((c) => c.serverUrl == serverUrl);
          return Result.ok(connection);
        } catch (_) {
          return Result.error(
            Exception("No connection found for URL: $serverUrl"),
          );
        }
    }
  }

  @override
  Future<Result<List<String>>> getServers({required String userId}) async {
    switch (await _loadConnections()) {
      case Error(:final error):
        return Result.error(error);
      case Ok(:final value):
        return Result.ok(value.map((c) => c.serverUrl).toList());
    }
  }

  Future<Result<List<ServerConnection>>> _loadConnections() async {
    try {
      final raw = await _storage.read(key: _connectionsKey);
      if (raw == null) return Result.ok([]);

      final List<dynamic> decoded = jsonDecode(raw);
      final connections = decoded
          .map((e) => ServerConnection.fromJson(e as Map<String, dynamic>))
          .toList();

      return Result.ok(connections);
    } catch (e) {
      return Result.error(Exception("Failed to load connections: $e"));
    }
  }

  Future<Result<void>> _saveConnections(
    List<ServerConnection> connections,
  ) async {
    try {
      final encoded = jsonEncode(connections.map((c) => c.toJson()).toList());
      await _storage.write(key: _connectionsKey, value: encoded);
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception("Failed to save connections: $e"));
    }
  }
}
