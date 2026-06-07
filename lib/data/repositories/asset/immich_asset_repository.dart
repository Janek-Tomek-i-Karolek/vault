import 'dart:io';

import 'package:vault/data/model/asset/asset_media_response_dto.dart';
import 'package:vault/data/model/asset/asset_response_dto.dart';
import 'package:vault/data/services/api/demo_api_client.dart';
import 'package:vault/domain/server/server_connection.dart';

import '../../../domain/asset/asset.dart';
import '../../../utils/result.dart';
import 'asset_repository.dart';

class ImmichAssetRepository implements AssetRepository {
  @override
  Future<Result<Asset>> upload(
    File asset,
    ServerConnection serverConnection,
  ) async {
    Result<AssetMediaResponseDTO> assetRes = await DemoApiClient().uploadAsset(
      serverConnection,
      asset,
    );

    return switch (assetRes) {
      Error(:final error) => Result.error(error),
      Ok(:final value) => await getAsset(serverConnection, value.id),
    };
  }

  @override
  Future<Result<void>> delete(Asset asset) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<Asset>> getAsset(
    ServerConnection serverConnection,
    String id,
  ) async {
    Result<AssetResponseDTO> assetRes = await DemoApiClient().getAsset(
      serverConnection,
      id,
    );

    switch (assetRes) {
      case Ok<AssetResponseDTO>():
        return Result.ok(Asset.fromDTO(assetRes.value, serverConnection));
      case Error<AssetResponseDTO>():
        return Result.error(assetRes.error);
    }
  }

  @override
  Future<Result<List<Asset>>> getAssets() async {
    throw UnimplementedError();
  }
}
