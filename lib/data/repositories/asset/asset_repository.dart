import "../../../utils/result.dart";
import "../../../domain/asset/asset.dart";

abstract class AssetRepository {
  Future<Result<List<Asset>>> getAssets();
  Future<Result<Asset>> getAsset(String id);
  Future<Result<void>> create(Asset asset);
  Future<Result<void>> delete(Asset asset);
}
