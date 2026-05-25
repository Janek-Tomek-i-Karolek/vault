import 'package:vault/data/model/album/album_response_dto.dart';
import 'package:vault/data/model/album/album_user_response_dto.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/domain/server/server_connection.dart';

class Album {
  final String name;
  final List<Asset> assets;
  final ServerConnection serverConnection;

  Album({
    required this.name,
    required this.assets,
    required this.serverConnection,
  });

  static Album fromDTO({
    required AlbumResponseDTO dto,
    required ServerConnection serverConnection,
  }) => Album(
    name: dto.albumName ?? "Not available",
    assets: [
      for (final assetDto in dto.assets)
        Asset.fromDTO(assetDto, serverConnection),
    ],
    serverConnection: serverConnection,
  );
}
