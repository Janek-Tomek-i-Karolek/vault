import 'package:flutter/material.dart';
import 'package:vault/data/repositories/connection/connection_repository.dart';
import 'package:vault/domain/server/server_connection.dart';
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

  final LocalConnectionRepository _connectionRepository;
  AddAlbumViewModel({required LocalConnectionRepository connectionRepository})
    : _connectionRepository = connectionRepository;

  bool get isAddAlbumFormValid {
    debugPrint(
      "album name: $newAlbumName, conn: ${newAlbumConnection?.serverUrl}",
    );
    return (newAlbumName != null &&
        newAlbumName!.isNotEmpty &&
        newAlbumConnection != null);
  }

  Future<Result<void>> addAlbum() async {
    debugPrint(
      "Adding album, name: $newAlbumName, conn: ${newAlbumConnection?.serverUrl}",
    );
    return Future.value(Result.error(Exception("Unimplemented")));
  }
}
