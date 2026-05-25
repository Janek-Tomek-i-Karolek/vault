import 'package:vault/domain/server/server_connection.dart';

import '../../../domain/asset/asset.dart';
import '../../../utils/result.dart';
import 'asset_repository.dart';

const String IMMICH_DEMO_DOMAIN = "";

class MockAssetRepository implements AssetRepository {
  @override
  Future<Result<void>> create(Asset asset) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> delete(Asset asset) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<Asset>> getAsset(String id) {
    return Future.value(Result.ok(mockAsset(id)));
  }

  @override
  Future<Result<List<Asset>>> getAssets() async {
    return Future.value(Result.ok([mockAsset("kopice"), mockAsset("grodkow")]));
  }

  @override
  Uri getOriginalUri(Asset asset) {
    return Uri.parse(
      "https://upload.wikimedia.org/wikipedia/commons/1/17/Widok_pa%C5%82acu_w_Kopicach_od_g%C5%82%C3%B3wnego_wjazdu.jpg",
    );
  }

  Asset mockAsset(String id) => Asset(
    id: id,
    mimeType: "image/jpg",
    isVideo: true,
    serverConnection: ServerConnection(serverUrl: "", apiKey: ""),
  );
}
