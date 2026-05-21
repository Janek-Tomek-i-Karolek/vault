import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/utils/result.dart';
import 'package:http/http.dart';
import 'package:pair/pair.dart';

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

  @override
  Future<Result<ServerConnection>> connect({
    required String serverUrl,
    required String apiKey,
  }) async {
    final newConnection = ServerConnection(
      serverUrl: serverUrl,
      apiKey: apiKey,
    );

    final testResult = await testConnection(connection: newConnection);

    if (testResult case Error(:final error)) {
      return Result.error(Exception("Connection to server failed: $error"));
    }

    if (await _saveUrl(serverUrl) case Error(:final error)) {
      return Result.error(Exception("Failed to save URL: $error"));
    }
    if (await _saveApiKey(apiKey) case Error(:final error)) {
      return Result.error(Exception("Failed to save API Key: $error"));
    }

    return Result.ok(newConnection);
  }

  @override
  Future<Result<void>> disconnect({required String serverUrl}) async {
    try {
      await _storage.delete(key: 'apiKey');
      await _storage.delete(key: 'serverUrl');

      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception("Disconnection failed: $e"));
    }
  }

  @override
  Future<Result<bool>> testConnection({
    required ServerConnection connection,
  }) async {
    final uri = Uri.parse("${connection.serverUrl}/api/users/me");

    final Map<String, String> immichApiHeaders = {
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
  Future<Result<List<ServerConnection>>> getConnections() async {
    final credentials = await _getCredentials();

    late final String serverUrl;
    late final String apiKey;

    switch (credentials) {
      case Ok():
        {
          serverUrl = credentials.value.key;
          apiKey = credentials.value.value;

          return Result.ok([
            ServerConnection(serverUrl: serverUrl, apiKey: apiKey),
          ]);
        }
      case Error():
        {
          return Result.error(credentials.error);
        }
    }
  }

  @override
  Future<Result<ServerConnection>> getConnectionByUrl({
    required String serverUrl,
  }) async {
    return switch (await _getApiKey()) {
      Error(:final error) => Result.error(error),
      Ok(:final value) => Result.ok(
        ServerConnection(serverUrl: serverUrl, apiKey: value),
      ),
    };
  }

  @override
  Future<Result<List<String>>> getServers({required String userId}) async {
    return switch (await _getUrl()) {
      Error(:final error) => Result.error(error),
      Ok(:final value) => Result.ok([value]),
    };
  }

  // Helper functions
  Future<Result<Pair<String, String>>> _getCredentials() async {
    final Result<String> serverUrlResult = await _getUrl();
    final Result<String> apiKeyResult = await _getApiKey();

    late final String serverUrl;
    late final String apiKey;

    switch (serverUrlResult) {
      case Ok():
        {
          serverUrl = serverUrlResult.value;
        }
      case Error():
        {
          return Result.error(serverUrlResult.error);
        }
    }

    switch (apiKeyResult) {
      case Ok():
        {
          apiKey = apiKeyResult.value;
          return Result.ok(Pair(serverUrl, apiKey));
        }
      case Error():
        {
          return Result.error(apiKeyResult.error);
        }
    }
  }

  Future<Result<void>> _saveApiKey(String apiKey) async {
    try {
      await _storage.write(key: 'apiKey', value: apiKey);
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception("Failed to save api key: $e"));
    }
  }

  Future<Result<String>> _getApiKey() async {
    try {
      String? apiKey = await _storage.read(key: 'apiKey');
      if (apiKey == null) {
        return Result.error(Exception("Failed to fetch api key: Key is null"));
      } else {
        return Result.ok(apiKey);
      }
    } catch (e) {
      return Result.error(Exception("Failed to fetch api key: $e"));
    }
  }

  Future<Result<void>> _saveUrl(String url) async {
    try {
      await _storage.write(key: 'serverUrl', value: url);
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception("Failed to save server url: $e"));
    }
  }

  Future<Result<String>> _getUrl() async {
    try {
      String? url = await _storage.read(key: 'serverUrl');
      if (url == null) {
        return Result.error(Exception("Failed to fetch url: Key is null"));
      } else {
        return Result.ok(url);
      }
    } catch (e) {
      return Result.error(Exception("Failed to fetch url: $e"));
    }
  }
}
