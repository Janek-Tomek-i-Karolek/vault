import 'package:vault/data/model/album/album_response_dto.dart';
import 'package:vault/data/model/asset/asset_response_dto.dart';
import 'package:vault/data/repositories/album/album_repository.dart';
import 'package:vault/data/services/api/demo_api_client.dart';
import 'package:vault/domain/album/album.dart';
import 'package:vault/domain/album/album_preview.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/utils/result.dart';

class DemoApiAlbumRepository extends AlbumRepository {
  @override
  Future<Result<void>> create(Album album) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> addAssetsToAlbum(
    ServerConnection serverConnection,
    Album album,
    List<Asset> assets,
  ) async {
    final assetIds = assets.map((asset) => asset.id).toList();
    return DemoApiClient().addAssetsToAlbum(
      serverConnection,
      album.id,
      assetIds,
    );
  }

  @override
  Future<Result<void>> removeAssetFromAlbum(
    ServerConnection serverConnection,
    Album album,
    Asset asset,
  ) async {
    return switch (await DemoApiClient().removeAssetsFromAlbum(
      serverConnection,
      album.id,
      [asset.id],
    )) {
      Ok() => Result.ok(null),
      Error(:final error) => Result.error(error),
    };
  }

  @override
  Future<Result<void>> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<Album>> getAlbum(
    ServerConnection serverConnection,
    String id,
  ) async {
    Result<AlbumResponseDTO> albumRes = await DemoApiClient().getAlbum(
      serverConnection,
      id,
    );
    switch (albumRes) {
      case Ok<AlbumResponseDTO>():
        return Result.ok(
          Album.fromDTO(
            dto: albumRes.value,
            serverConnection: serverConnection,
          ),
        );
      case Error<AlbumResponseDTO>():
        return Result.error(albumRes.error);
    }
  }

  @override
  Future<Result<List<AlbumPreview>>> getAlbumPreviews(
    ServerConnection serverConnection,
  ) async {
    Result<List<AlbumResponseDTO>> albumsRes = await DemoApiClient().getAlbums(
      serverConnection,
    );

    List<AlbumResponseDTO> albums;
    switch (albumsRes) {
      case Ok<List<AlbumResponseDTO>>():
        albums = albumsRes.value;
      case Error<List<AlbumResponseDTO>>():
        return Result.error(albumsRes.error);
    }

    return Result.ok(
      await Future.wait(
        albums.map((dto) async => _getAlbumPreview(serverConnection, dto)),
      ),
    );
  }

  Future<AlbumPreview> _getAlbumPreview(
    ServerConnection conn,
    AlbumResponseDTO dto,
  ) async {
    Asset? thumbnail;
    if (dto.albumThumbnailAssetId != null) {
      Result<AssetResponseDTO> thumbnailRes = await DemoApiClient().getAsset(
        conn,
        dto.albumThumbnailAssetId!,
      );

      thumbnail = switch (thumbnailRes) {
        Ok<AssetResponseDTO>() => Asset.fromDTO(thumbnailRes.value, conn),
        Error<AssetResponseDTO>() => null,
      };
    }

    return AlbumPreview(
      albumId: dto.id,
      albumName: dto.albumName ?? "Unavailable",
      serverConnection: conn,
      thumbnail: thumbnail,
    );
  }

  @override
  Future<Result<List<Album>>> getAlbums(
    ServerConnection serverConnection,
  ) async {
    Result<List<AlbumResponseDTO>> albumsRes = await DemoApiClient().getAlbums(
      serverConnection,
    );

    switch (albumsRes) {
      case Ok<List<AlbumResponseDTO>>():
        return Result.ok([
          for (final albumDto in albumsRes.value)
            Album.fromDTO(dto: albumDto, serverConnection: serverConnection),
        ]);
      case Error<List<AlbumResponseDTO>>():
        return Result.error(albumsRes.error);
    }
  }
}
