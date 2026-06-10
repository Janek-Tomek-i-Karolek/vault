import 'package:flutter/material.dart';
import 'package:vault/data/repositories/album/album_repository.dart';
import 'package:vault/data/repositories/connection/connection_repository.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/l10n/vault_localizations.dart';
import 'package:vault/utils/result.dart';

class AddAlbumViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? newAlbumName;
  ServerConnection? newAlbumConnection;

  List<ServerConnection> serverConnections = List.empty();
  Future<void> getServerConnections() async {
    isLoading = true;
    notifyListeners();

    serverConnections = switch (await _connectionRepository.getConnections()) {
      Ok(:final value) => value,
      Error() => List<ServerConnection>.empty(),
    };

    isLoading = false;
    notifyListeners();
  }

  final AlbumRepository _albumRepository;
  final LocalConnectionRepository _connectionRepository;
  AddAlbumViewModel({
    required AlbumRepository albumRepository,
    required LocalConnectionRepository connectionRepository,
  }) : _connectionRepository = connectionRepository,
       _albumRepository = albumRepository;

  bool get isAddAlbumFormValid {
    debugPrint(
      "album name: $newAlbumName, conn: ${newAlbumConnection?.serverUrl}",
    );
    return (newAlbumName != null &&
        newAlbumName!.isNotEmpty &&
        newAlbumConnection != null);
  }

  Future<Result<void>> addAlbum(AppLocalizations localizations) async {
    if (!isAddAlbumFormValid) {
      return Result.error(
        Exception(localizations.invalidValuesErrorMessage(2)),
      );
    }

    var res = await _albumRepository.addAlbum(
      newAlbumConnection!,
      newAlbumName!,
    );

    return switch (res) {
      Ok() => Result.ok(null),
      Error(:final error) => Result.error(error),
    };
  }
}
