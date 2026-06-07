import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vault/data/repositories/album/album_repository.dart';
import 'package:vault/data/repositories/asset/asset_repository.dart';
import 'package:vault/data/repositories/connection/connection_repository.dart';
import 'package:vault/domain/album/album.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/utils/enums/connection_status.dart';
import 'package:vault/utils/result.dart';

class AddAssetViewModel extends ChangeNotifier {
  ConnectionStatus status = ConnectionStatus.loading;

  final AssetRepository _assetRepository;
  final AlbumRepository _albumRepository;

  AddAssetViewModel({
    required AssetRepository assetRepository,
    required AlbumRepository albumRepository,
  }) : _assetRepository = assetRepository,
       _albumRepository = albumRepository;

  Future<Result<void>> addAsset(
    Album album,
    List<File> assetFiles,
    ServerConnection serverConnection,
  ) async {
    List<Asset> assets = [];
    for (final asset in assetFiles) {
      final res = await _assetRepository.upload(asset, serverConnection);
      switch (res) {
        case Ok(:final value):
          {
            assets.add(value);
          }
        case Error(:final error):
          {
            return Result.error(Exception(error));
          }
      }
    }

    return _albumRepository.addAssetsToAlbum(serverConnection, album, assets);
  }
}
