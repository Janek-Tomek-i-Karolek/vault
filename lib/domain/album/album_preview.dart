import 'package:vault/domain/server/server_connection.dart';

import '../asset/asset.dart';

class AlbumPreview {
  // nullable in case it's not stored yet
  String? albumId;
  String albumName;
  ServerConnection serverConnection;
  Asset? thumbnail;

  AlbumPreview({
    this.albumId,
    required this.albumName,
    required this.serverConnection,
    required this.thumbnail,
  });
}
