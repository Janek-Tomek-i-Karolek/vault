import 'package:vault/data/repositories/album/demo_api_album_repository.dart';

import '../../../domain/album/album.dart';
import '../../../domain/album/album_preview.dart';
import '../../../domain/asset/asset.dart';
import '../../../utils/result.dart';
import '../asset/mock_asset_repository.dart';
import 'album_repository.dart';

class MockAlbumRepository implements AlbumRepository {
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
  Future<Result<List<AlbumPreview>>> getAlbumPreviews() async {
    Result<List<Asset>> assetsRes = await MockAssetRepository().getAssets();

    Result<List<Album>> sth = await DemoApiAlbumRepository().getAlbums();

    List<Asset> assets;
    switch (assetsRes) {
      case Ok<List<Asset>>():
        assets = assetsRes.value;
      case Error<List<Asset>>():
        return Future.value(Result.error(assetsRes.error));
    }

    var previews = List<AlbumPreview>.empty(growable: true);
    for (int i = 0; i < 10; i++) {
      previews.add(
        AlbumPreview(
          albumId: "album-$i",
          albumName: "Album $i",
          thumbnail: assets[i % assets.length],
        ),
      );
    }

    return Future.value(Result.ok(previews));
  }

  @override
  Future<Result<List<Album>>> getAlbums() {
    // TODO: implement getAlbums
    throw UnimplementedError();
  }
}
