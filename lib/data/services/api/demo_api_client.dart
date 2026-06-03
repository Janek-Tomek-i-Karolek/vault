import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:vault/data/model/album/album_response_dto.dart';
import 'package:vault/data/model/asset/asset_response_dto.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/utils/result.dart';

// NOTE: This is for testing only, for use with multiple requests to the same server,
// the Client object is probably better

class DemoApiClient {
  Map<String, String> demoRequestHeaders(String apiKey) => {
    "Content-Type": "application/json",
    "x-api-key": apiKey,
  };

  Future<Result<List<AlbumResponseDTO>>> getAlbums(
    ServerConnection serverConnection,
  ) async {
    final uri = Uri.parse("${serverConnection.serverUrl}/api/albums");

    final response = await get(
      uri,
      headers: demoRequestHeaders(serverConnection.apiKey),
    );

    if (response.statusCode != 200) {
      return Result.error(Exception("Failed to fetch albums"));
    }

    return Result.ok([
      for (final object in jsonDecode(response.body))
        AlbumResponseDTO.fromJson(object),
    ]);
  }

  Future<Result<AlbumResponseDTO>> getAlbum(
    ServerConnection serverConnection,
    String id,
  ) async {
    final uri = Uri.parse("${serverConnection.serverUrl}/api/albums/$id");

    final response = await get(
      uri,
      headers: demoRequestHeaders(serverConnection.apiKey),
    );
    print(response.body);

    if (response.statusCode != 200) {
      return Result.error(HttpException("Failed to fetch the album"));
    }

    return Result.ok(AlbumResponseDTO.fromJson(jsonDecode(response.body)));
  }

  Future<Result<AssetResponseDTO>> getAsset(
    ServerConnection serverConnection,
    String id,
  ) async {
    final uri = Uri.parse("${serverConnection.serverUrl}/api/assets/$id");

    final response = await get(
      uri,
      headers: demoRequestHeaders(serverConnection.apiKey),
    );

    if (response.statusCode != 200) {
      return Result.error(HttpException("Failed to fetch the asset"));
    }

    return Result.ok(AssetResponseDTO.fromJson(jsonDecode(response.body)));
  }

  Future<Result<void>> uploadAsset(
    ServerConnection serverConnection,
    File asset,
  ) async {
    final uri = Uri.parse("${serverConnection.serverUrl}/api/assets");

    final request = MultipartRequest('POST', uri);

    request.headers['x-api-key'] = serverConnection.apiKey;

    request.files.add(await MultipartFile.fromPath('assetData', asset.path));

    request.fields['deviceAssetId'] = asset.path;
    request.fields['deviceId'] = 'vault'; // TODO: add userID
    request.fields['fileCreatedAt'] = DateTime.now().toString();
    request.fields['fileModifiedAt'] = DateTime.now().toString();
    request.fields['isFavorite'] = 'false';

    final response = await request.send();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Result.ok(null);
    } else {
      final body = await response.stream.bytesToString();
      return Result.error(Exception(body));
    }
  }
}
