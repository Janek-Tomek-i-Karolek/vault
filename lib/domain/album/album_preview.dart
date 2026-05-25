import '../asset/asset.dart';

class AlbumPreview {
  // nullable in case it's not stored yet
  String? albumId;
  String albumName;
  Asset? thumbnail;

  AlbumPreview({
    this.albumId,
    required this.albumName,
    required this.thumbnail,
  });
}
