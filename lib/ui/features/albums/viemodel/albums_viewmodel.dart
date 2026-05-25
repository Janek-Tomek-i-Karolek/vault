import 'package:flutter/material.dart';
import 'package:vault/data/repositories/album/album_repository.dart';
import 'package:vault/data/repositories/asset/asset_repository.dart';
import 'package:vault/domain/album/album_preview.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/utils/result.dart';

class AlbumsViewModel extends ChangeNotifier {
  List<AlbumPreview>? albumPreviews;
  Exception? error;
  bool isLoading = false;

  final AlbumRepository _albumRepository;
  final AssetRepository _assetRepository;
  AlbumsViewModel({
    required AlbumRepository albumRepository,
    required AssetRepository assetRepository,
  }) : _albumRepository = albumRepository,
       _assetRepository = assetRepository;

  Future<void> fetchPreviews(ServerConnection serverConnection) async {
    await Future.microtask(() {
      isLoading = true;
      notifyListeners();
    });

    var result = await _albumRepository.getAlbumPreviews(serverConnection);
    switch (result) {
      case Ok<List<AlbumPreview>>():
        albumPreviews = result.value;
        error = null;
      case Error<List<AlbumPreview>>():
        albumPreviews = null;
        error = result.error;
    }

    isLoading = false;
    notifyListeners();
  }
}
