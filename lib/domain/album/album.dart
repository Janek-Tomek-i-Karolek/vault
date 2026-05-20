import 'package:vault/domain/asset/asset.dart';

class Album {
  final String name;
  final List<Asset> assets;

  Album({required this.name, required this.assets});
}
