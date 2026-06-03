import 'dart:io';

import 'package:http/http.dart';
import 'package:vault/data/services/api/demo_api_client.dart';
import 'package:vault/domain/server/server_connection.dart';

import '../../../domain/asset/asset.dart';
import '../../../utils/result.dart';
import 'asset_repository.dart';

const String IMMICH_DEMO_DOMAIN = "";

class ImmichAssetRepository implements AssetRepository {
  @override
  Future<Result<void>> upload(
    File asset,
    ServerConnection serverConnection,
  ) async {
    Result<void> assetRes = await DemoApiClient().uploadAsset(
      serverConnection,
      asset,
    );

    return switch (assetRes) {
      Error(:final error) => Result.error(error),
      _ => Result.ok(null),
    };
  }

  @override
  Future<Result<void>> delete(Asset asset) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<Asset>> getAsset(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Asset>>> getAssets() async {
    throw UnimplementedError();
  }
}
