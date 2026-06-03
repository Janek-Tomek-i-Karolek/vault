import "dart:io";

import "package:vault/domain/server/server_connection.dart";

import "../../../utils/result.dart";
import "../../../domain/asset/asset.dart";

abstract class AssetRepository {
  Future<Result<List<Asset>>> getAssets();
  Future<Result<Asset>> getAsset(String id);
  Future<Result<void>> upload(File asset, ServerConnection connection);
  Future<Result<void>> delete(Asset asset);
}
