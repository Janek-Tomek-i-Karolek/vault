import 'package:flutter/material.dart';
import 'package:vault/data/repositories/album/album_repository.dart';
import 'package:vault/data/repositories/connection/connection_repository.dart';
import 'package:vault/domain/album/album_preview.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/utils/result.dart';

class AlbumsViewModel extends ChangeNotifier {
  List<AlbumPreview>? albumPreviews;
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
        albumPreviews = null;

        isLoading = false;
        notifyListeners();
        return;
    }

    albumPreviews = List.empty(growable: true);
    for (var connection in connections) {
      var previewsRes = await _albumRepository.getAlbumPreviews(connection);
      switch (previewsRes) {
        case Ok():
          albumPreviews!.addAll(previewsRes.value);
        case Error():
          albumPreviews = null;
          error = previewsRes.error;

          isLoading = false;
          notifyListeners();
          return;
      }
    }

    error = null;
    isLoading = false;
    notifyListeners();
    return;
  }
}
