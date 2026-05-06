class Asset {
  // nullable in case it's not stored yet
  String? id;
  String mimeType;
  bool isVideo;
  Asset({this.id, required this.mimeType, required this.isVideo});
}
