import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vault/utils/result.dart';
import 'package:http/http.dart';

abstract interface class VaultRepository {
  Future<Result<void>> saveApiKey(String apiKey);
  Future<Result<String>> getApiKey();
  Future<Result<void>> saveUrl(String url);
  Future<Result<String>> getUrl();
  // Return the body of response
  Future<Result<String>> testConnection();
}

class ImmichVaultRepository implements VaultRepository {
  final _storage = const FlutterSecureStorage();

  @override
  Future<Result<void>> saveApiKey(String apiKey) async {
    try {
      await _storage.write(key: 'apiKey', value: apiKey);
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception("Failed to save api key: $e"));
    }
  }

  @override
  Future<Result<String>> getApiKey() async {
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

  @override
  Future<Result<void>> saveUrl(String url) async {
    try {
      await _storage.write(key: 'serverUrl', value: url);
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception("Failed to save server url: $e"));
    }
  }

  @override
  Future<Result<String>> getUrl() async {
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

  @override
  Future<Result<String>> testConnection() async {
    final Result<String> serverUrlResult = await getUrl();
    final Result<String> apiKeyResult = await getApiKey();

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

      return Result.ok(response.body);
    } catch (e) {
      return Result.error(Exception("Connection failed: $e"));
    }
  }
}
