import 'dart:convert';

import 'package:http/http.dart';
import 'package:vault/data/model/album/album_response_dto.dart';
import 'package:vault/utils/result.dart';

// NOTE: This is for testing only, for use with multiple requests to the same server,
// the Client object is probably better

class DemoApiClient {
  static const String kDemoDomain = "demo.immich.app";

  static const String _demoApiKey = "jr3yYwZO9H2tUa0GgURTOmxIxYiIbwqccZ5CvDpyY";

  static final Map<String, String> demoRequestHeaders = {
    "Content-Type": "application/json",
    "x-api-key": _demoApiKey,
  };

  Future<Result<List<AlbumResponseDTO>>> getAlbums() async {
    final uri = Uri.https(kDemoDomain, "/api/albums");

    final response = await get(uri, headers: demoRequestHeaders);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode != 200) {
      return Result.error(Exception("Failed to fetch the albums"));
    }

    return Result.ok([
      for (final object in jsonDecode(response.body))
        AlbumResponseDTO.fromJson(object),
    ]);
  }
}
