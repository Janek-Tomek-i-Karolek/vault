import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:vault/data/model/album/album_response_dto.dart';
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
}
