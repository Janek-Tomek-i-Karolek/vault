import 'dart:async';

import 'package:fuzzy/fuzzy.dart';
import 'package:flutter/material.dart';
import 'package:vault/data/repositories/album/album_repository.dart';
import 'package:vault/data/repositories/connection/connection_repository.dart';
import 'package:vault/domain/album/album_preview.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/utils/result.dart';

class AlbumsViewModel extends ChangeNotifier {
  List<AlbumPreview>? _albumPreviews;

  // TODO: think of a different way to handle this
  Timer? _filterDebounceTimer;
  static const Duration _filterDebounceDuration = Duration(milliseconds: 300);
  List<AlbumPreview>? filteredAlbumPreviews;
  Fuzzy<AlbumPreview>? _fuzzy;

  Exception? error;
  bool isLoading = false;

  final AlbumRepository _albumRepository;
  final LocalConnectionRepository _connectionRepository;
  AlbumsViewModel({
    required AlbumRepository albumRepository,
    required LocalConnectionRepository connectionRepository,
  }) : _albumRepository = albumRepository,
       _connectionRepository = connectionRepository;

  Future<void> fetchPreviews() async {
    if (isLoading) return;

    await Future.microtask(() {
      isLoading = true;
      notifyListeners();
    });

    var connectionsRes = await _connectionRepository.getConnections();
    List<ServerConnection> connections;
    switch (connectionsRes) {
      case Ok():
        connections = connectionsRes.value;
        error = null;
      case Error():
        error = connectionsRes.error;
        _albumPreviews = null;

        isLoading = false;
        notifyListeners();
        return;
    }

    _albumPreviews = List.empty(growable: true);
    for (var connection in connections) {
      var previewsRes = await _albumRepository.getAlbumPreviews(connection);
      switch (previewsRes) {
        case Ok():
          _albumPreviews!.addAll(previewsRes.value);
        case Error():
          _albumPreviews = null;
          error = previewsRes.error;

          isLoading = false;
          notifyListeners();
          return;
      }
    }

    filteredAlbumPreviews = _albumPreviews;
    _fuzzy = Fuzzy<AlbumPreview>(
      _albumPreviews!,
      options: FuzzyOptions(
        threshold: 0.4,
        keys: [
          WeightedKey(
            name: 'albumName',
            getter: (AlbumPreview prev) => prev.albumName,
            weight: 1.0,
          ),
        ],
      ),
    );
    error = null;
    isLoading = false;
    notifyListeners();
    return;
  }

  void filterPreviews(String search) {
    if (_filterDebounceTimer?.isActive ?? false) {
      _filterDebounceTimer!.cancel();
    }

    _filterDebounceTimer = Timer(_filterDebounceDuration, () {
      _runFilter(search);
    });
  }

  void _runFilter(String search) {
    if (_fuzzy == null || _albumPreviews == null) {
      return;
    }

    if (search.isEmpty) {
      filteredAlbumPreviews = _albumPreviews;
      notifyListeners();
      return;
    }

    final results = _fuzzy!.search(search);

    final Set<String> seenNames = {};
    filteredAlbumPreviews = results
        .map((result) => result.item)
        .where((album) => seenNames.add(album.albumName))
        .toList();
    notifyListeners();
  }
}
