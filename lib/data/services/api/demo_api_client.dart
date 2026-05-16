import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:vault/data/model/album/album_response_dto.dart';
import 'package:vault/utils/result.dart';

// NOTE: This is for testing only, for use with multiple requests to the same server,
// the Client object is probably better

class DemoApiClient {
  static const String kDemoDomain = "api.immich.app";
  static final List<HeaderValue> demoRequestHeader = [
    HeaderValue("Origin", {Uri.https(kDemoDomain).origin: null}),
    HeaderValue("Referer", {Uri.https(kDemoDomain).origin: null}),
    HeaderValue("x-api-key", {
      "jr3yYwZO9H2tUa0GgURTOmxIxYiIbwqccZ5CvDpyY": null,
    }),
  ];

  Future<Result<List<AlbumResponseDTO>>> getAlbums() async {
    final uri = Uri.https(kDemoDomain, '/api/albums');

    final Map<String, String> headers = {
      for (var h in demoRequestHeader) h.value: h.parameters.toString(),
    };

    final response = await get(uri, headers: headers);

    if (response.statusCode != 200) {
      return Result.error(HttpException('Failed to fetch the albums'));
    }

    return Result.ok([
      for (var object in jsonDecode(response.body))
        AlbumResponseDTO.fromJson(object),
    ]);
  }
}
