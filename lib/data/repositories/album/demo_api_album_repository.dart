import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:vault/data/model/album/album_response_dto.dart';
import 'package:vault/data/repositories/album/album_repository.dart';
import 'package:vault/data/services/api/demo_api_client.dart';
import 'package:vault/domain/album/album.dart';
import 'package:vault/domain/album/album_preview.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/utils/result.dart';

class DemoApiAlbumRepository extends AlbumRepository {
  static const String kAlbumId = "f0b9c2d8-e4cc-4bdb-9c36-cda764479bd0";

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
  Future<Result<Album>> getAlbum(String id) async {
    Result<AlbumResponseDTO> albumRes = await DemoApiClient().getAlbum(
      kAlbumId,
    );
    switch (albumRes) {
      case Ok<AlbumResponseDTO>():
        final AlbumResponseDTO album = albumRes.value;
        print(album);
        return Result.ok(
          Album(
            name: album.albumName ?? "Not available",
            assets: [
              for (var asset in album.assets)
                Asset(
                  id: asset.id,
                  mimeType: asset.originalMimeType ?? "",
                  isVideo: asset.type == .VIDEO,
                  width: asset.width,
                  height: asset.height,
                ),
            ],
          ),
        );
      case Error<AlbumResponseDTO>():
        return Result.error(albumRes.error);
    }
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

        return Result.ok([Album(name: "some name", assets: [])]);
      case Error<List<AlbumResponseDTO>>():
        return Result.error(albumsRes.error);
    }
  }

  void printAlbums(List<AlbumResponseDTO> albums) async {
    Result<AlbumResponseDTO> albumRes = await DemoApiClient().getAlbum(
      kAlbumId,
    );
  }
}
