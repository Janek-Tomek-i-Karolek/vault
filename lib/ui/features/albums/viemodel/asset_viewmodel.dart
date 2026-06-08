import 'package:flutter/material.dart';
import 'package:vault/data/repositories/album/album_repository.dart';
import 'package:vault/data/repositories/asset/asset_repository.dart';
import 'package:vault/domain/album/album.dart';
import 'package:vault/domain/album/album_preview.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/utils/result.dart';

class AssetViewModel extends ChangeNotifier {
  List<AlbumPreview>? albumPreviews;
  Exception? error;
  bool isLoading = false;

  final AlbumRepository _albumRepository;
  final AssetRepository _assetRepository;
  AssetViewModel({
    required AlbumRepository albumRepository,
    required AssetRepository assetRepository,
  }) : _albumRepository = albumRepository,
       _assetRepository = assetRepository;

  Future<void> removeAssetFromAlbum(
    ServerConnection serverConnection,
    Album album,
    Asset asset,
  ) async {
    await _albumRepository.removeAssetFromAlbum(serverConnection, album, asset);
  }
}
