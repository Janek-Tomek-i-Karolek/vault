import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:vault/data/model/album/album_response_dto.dart';
import 'package:vault/utils/result.dart';

// NOTE: This is for testing only, for use with multiple requests to the same server,
// the Client object is probably better

class DemoApiClient {
  static const String kDemoDomain = "demo.immich.app";
  static const String kDemoApiKey = "jr3yYwZO9H2tUa0GgURTOmxIxYiIbwqccZ5CvDpyY";
  static const String kAlbumId = "0bbbcbd6-4061-4f85-97f6-7b3dc3d4b7ac";

  static final Map<String, String> demoRequestHeaders = {
    "Content-Type": "application/json",
    "x-api-key": kDemoApiKey,
  };

  Future<Result<List<AlbumResponseDTO>>> getAlbums() async {
    final uri = Uri.https(kDemoDomain, "/api/albums");

    final response = await get(uri, headers: demoRequestHeaders);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode != 200) {
      return Result.error(Exception("Failed to fetch albums"));
    }

    return Result.ok([
      for (final object in jsonDecode(response.body))
        AlbumResponseDTO.fromJson(object),
    ]);
  }

  Future<Result<AlbumResponseDTO>> getAlbum(String id) async {
    final uri = Uri.https(kDemoDomain, "/api/albums/$id");

    final response = await get(uri, headers: demoRequestHeaders);

    if (response.statusCode != 200) {
      return Result.error(HttpException("Failed to fetch the album"));
    }

    return Result.ok(AlbumResponseDTO.fromJson(jsonDecode(response.body)));
  }
}
