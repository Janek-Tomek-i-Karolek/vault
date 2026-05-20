class Asset {
  // nullable in case it's not stored yet
  String id;
  String? serverUrl;
  int? width;
  int? height;
  String mimeType;
  bool isVideo;
  Asset({
    this.width,
    this.height,
    required this.id,
    // required this.serverUrl,
    required this.mimeType,
    required this.isVideo,
  });
}
