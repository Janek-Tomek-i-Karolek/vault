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
}
