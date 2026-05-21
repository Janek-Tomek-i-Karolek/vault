import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vault/utils/result.dart';
import 'package:http/http.dart';

abstract interface class ConnectionRepository {
  Future<Result<void>> connect({required String url, required String apiKey});
  Future<Result<void>> disconnect({required String url});
  Future<Result<bool>> testConnection();
  Future<Result<void>> getConnections();
}

class ImmichConnectionRepository implements ConnectionRepository {
  final _storage = const FlutterSecureStorage();

  @override
  Future<Result<void>> connect({
    required String url,
    required String apiKey,
  }) async {
    if (await _saveUrl(url) case Error(:final error)) {
      return Result.error(Exception("Failed to save URL: $error"));
    }

    if (await _saveApiKey(apiKey) case Error(:final error)) {
      return Result.error(Exception("Failed to save API Key: $error"));
    }

    final testResult = await testConnection();

    if (testResult is Error) {
      await disconnect();
      return testResult;
    }

    return Result.ok(null);
  }

  @override
  Future<Result<void>> disconnect() async {
    try {
      await _storage.delete(key: 'apiKey');
      await _storage.delete(key: 'serverUrl');

      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception("Disconnection failed: $e"));
    }
  }

  @override
  Future<Result<bool>> testConnection() async {
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
        }
      case Error():
        {
          return Result.error(apiKeyResult.error);
        }
    }

    final uri = Uri.parse("$serverUrl/api/users/me");

    final Map<String, String> immichApiHeaders = {
      "Content-Type": "application/json",
      "x-api-key": apiKey,
    };
    try {
      final response = await get(uri, headers: immichApiHeaders);

      if (response.statusCode != 200) {
        return Result.error(Exception("Failed to connect to Immich server"));
      }

      return Result.ok(true);
    } catch (e) {
      return Result.error(Exception("Connection failed: $e"));
    }
  }

  @override
  Future<Result<void>> getConnections() async {
    final url = await _getUrl();
  }

  // Helper functions
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
      String? apiKey = await _storage.read(key: 'serverUrl');
      if (apiKey == null) {
        return Result.error(Exception("Failed to fetch url: Key is null"));
      } else {
        return Result.ok(apiKey);
      }
    } catch (e) {
      return Result.error(Exception("Failed to fetch url: $e"));
    }
  }
}
