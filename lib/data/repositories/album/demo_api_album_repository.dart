import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:vault/data/model/album/album_response_dto.dart';
import 'package:vault/data/repositories/album/album_repository.dart';
import 'package:vault/data/services/api/demo_api_client.dart';
import 'package:vault/domain/album/album.dart';
import 'package:vault/domain/album/album_preview.dart';
import 'package:vault/utils/result.dart';

class DemoApiAlbumRepository extends AlbumRepository {
  @override
  Future<Result<void>> create(Album album) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<Album>> getAlbum(String id) {
    // TODO: implement getAlbum
    throw UnimplementedError();
  }

  @override
  Future<Result<List<AlbumPreview>>> getAlbumPreviews() {
    // TODO: implement getAlbumPreviews
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Album>>> getAlbums() async {
    Result<List<AlbumResponseDTO>> albumsRes = await DemoApiClient()
        .getAlbums();

    List<AlbumResponseDTO> albums;
    switch (albumsRes) {
      case Ok<List<AlbumResponseDTO>>():
        albums = albumsRes.value;
        printAlbums(albums);

        return Result.ok([Album()]);
      case Error<List<AlbumResponseDTO>>():
        return Result.error(albumsRes.error);
    }
  }

  void printAlbums(List<AlbumResponseDTO> albums) {
    for (var album in albums) print(album.toString());
  }
}
