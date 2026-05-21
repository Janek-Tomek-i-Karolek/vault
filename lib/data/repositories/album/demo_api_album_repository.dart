import 'package:vault/data/model/album/album_response_dto.dart';
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
        final AlbumResponseDTO album = albumRes.value;
        return Result.ok(
          Album(
            name: album.albumName ?? "Not available",
            assets: [
              for (var asset in album.assets)
                Asset(
                  id: asset.id,
                  serverUrl: serverConnection.serverUrl,
                  mimeType: asset.originalMimeType ?? "",
                  isVideo: asset.type == .VIDEO,
                  width: asset.width,
                  height: asset.height,
                ),
            ],
            serverConnection: serverConnection,
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
  Future<Result<List<Album>>> getAlbums(
    ServerConnection serverConnection,
  ) async {
    Result<List<AlbumResponseDTO>> albumsRes = await DemoApiClient().getAlbums(
      serverConnection,
    );

    List<AlbumResponseDTO> albums;
    switch (albumsRes) {
      case Ok<List<AlbumResponseDTO>>():
        albums = albumsRes.value;
        print(albums);

        return Result.ok([
          Album(
            name: "some name",
            assets: [],
            serverConnection: serverConnection,
          ),
        ]);
      case Error<List<AlbumResponseDTO>>():
        return Result.error(albumsRes.error);
    }
  }
}
