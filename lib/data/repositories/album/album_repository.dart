import "package:vault/domain/asset/asset.dart";
import "package:vault/domain/server/server_connection.dart";

import "../../../domain/album/album.dart";
import "../../../domain/album/album_preview.dart";
import "../../../utils/result.dart";

abstract class AlbumRepository {
  Future<Result<List<AlbumPreview>>> getAlbumPreviews(
    ServerConnection serverConnection,
  );
  Future<Result<Album>> addAlbum(
    ServerConnection serverConnection,
    String albumName,
  );
  Future<Result<List<Album>>> getAlbums(ServerConnection serverConnection);
  Future<Result<Album>> getAlbum(ServerConnection serverConnection, String id);
  Future<Result<void>> addAssetsToAlbum(
    ServerConnection serverConnection,
    Album album,
    List<Asset> assets,
  );
  Future<Result<void>> removeAssetFromAlbum(
    ServerConnection serverConnection,
    Album album,
    Asset asset,
  );
  Future<Result<void>> delete(String id);
}
