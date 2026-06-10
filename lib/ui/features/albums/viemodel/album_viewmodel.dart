import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vault/data/repositories/album/album_repository.dart';
import 'package:vault/data/repositories/asset/asset_repository.dart';
import 'package:vault/domain/album/album.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/utils/result.dart';

class AlbumViewModel extends ChangeNotifier {
  AlbumViewModel({
    required AlbumRepository albumRepository,
    required AssetRepository assetRepository,
  }) : _albumRepository = albumRepository,
       _assetRepository = assetRepository;

  final AlbumRepository _albumRepository;
  final AssetRepository _assetRepository;

  Exception? _error;
  Exception? get error => _error;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Album? _album;
  Album? get album => _album;

  bool _justEntered = true;
  bool get justEntered => _justEntered;

  Future<void> loadAlbum(
    ServerConnection serverConnection,
    String albumId,
  ) async {
    _isLoading = true;
    _justEntered = _album != null && _album!.id != albumId;
    notifyListeners();
    try {
      final albumResult = await _albumRepository.getAlbum(
        serverConnection,
        albumId,
      );
      switch (albumResult) {
        case Ok<Album>():
          _album = albumResult.value;
          _error = null;
        case Error<Album>():
          _album = null;
          _error = albumResult.error;
      }
    } on Exception catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      _justEntered = false;
      notifyListeners();
    }
  }

  Future<Result<void>> addAsset(
    String albumId,
    ServerConnection serverConnection,
  ) async {
    final picker = ImagePicker();
    List<XFile> assetFiles = await picker.pickMultiImage();

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

    final album = await _albumRepository.getAlbum(serverConnection, albumId);

    switch (album) {
      case Ok(:final value):
        {
          return _albumRepository.addAssetsToAlbum(
            serverConnection,
            value,
            assets,
          );
        }
      case Error(:final error):
        {
          return Result.error(Exception(error));
        }
    }
  }

  Future<void> removeAssetFromAlbum(
    ServerConnection serverConnection,
    Album album,
    Asset asset,
  ) async {
    await _albumRepository.removeAssetFromAlbum(serverConnection, album, asset);
    notifyListeners();
  }
}
