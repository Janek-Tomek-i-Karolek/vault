import 'package:flutter/material.dart';
import 'package:vault/data/repositories/album/album_repository.dart';
import 'package:vault/data/repositories/asset/asset_repository.dart';
import 'package:vault/data/repositories/vault/vault_repository.dart';
import 'package:vault/domain/album/album.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/utils/result.dart';

class AlbumViewModel extends ChangeNotifier {
  AlbumViewModel({required AlbumRepository albumRepository})
    : _albumRepository = albumRepository;

  final AlbumRepository _albumRepository;

  Exception? _error;
  Exception? get error => _error;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Album? _album;
  Album? get album => _album;

  String get apiKey => "bY4Puavp8jBnCc4mxh0BtHtUfFGBSRptxq44vF1vTU";

  Future<void> loadAlbum(String albumId) async {
    await Future.microtask(() {
      _isLoading = true;
      notifyListeners();
    });
    try {
      final albumResult = await _albumRepository.getAlbum(albumId);
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
      notifyListeners();
    }
  }
}
