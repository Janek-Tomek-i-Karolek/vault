import "dart:io";

import "package:vault/domain/server/server_connection.dart";

import "../../../utils/result.dart";
import "../../../domain/asset/asset.dart";

abstract class AssetRepository {
  Future<Result<List<Asset>>> getAssets();
  Future<Result<Asset>> getAsset(ServerConnection serverConnection, String id);
  Future<Result<Asset>> upload(File asset, ServerConnection serverConnection);
  Future<Result<void>> delete(Asset asset);
}
