import "dart:io";

import "package:vault/domain/server/server_connection.dart";

import "../../../domain/album/album.dart";
import "../../../domain/album/album_preview.dart";
import "../../../utils/result.dart";

abstract class AlbumRepository {
  Future<Result<List<AlbumPreview>>> getAlbumPreviews(
    ServerConnection serverConnection,
  );
  Future<Result<List<Album>>> getAlbums(ServerConnection serverConnection);
  Future<Result<Album>> getAlbum(ServerConnection serverConnection, String id);
  Future<Result<void>> addAssetToAlbum(Album album, String assetId);
  Future<Result<void>> create(Album album);
  Future<Result<void>> delete(String id);
}
