import 'package:flutter/material.dart';
import 'package:vault/data/repositories/album/album_repository.dart';
import 'package:vault/data/repositories/asset/asset_repository.dart';
import 'package:vault/data/repositories/connection/connection_repository.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/utils/enums/connection_status.dart';
import 'package:vault/utils/result.dart';

class AddAssetViewmodel extends ChangeNotifier {
  ConnectionStatus status = ConnectionStatus.loading;

  final AssetRepository _assetRepository;
  final AlbumRepository _albumRepository;

  AddAssetViewmodel({required AssetRepository assetRepository, required AlbumRepository albumRepository})
    : _assetRepository = assetRepository, _albumRepository = albumRepository

  Future<Result<void>> addAsset(Album album){
	_assetRepository.upload(asset, connection)
	_albumRepository.addAssetToAlbum(album, assetId)

  }

}
