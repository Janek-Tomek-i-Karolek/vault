import 'package:vault/data/model/asset/asset_response_dto.dart';

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
    this.serverUrl,
    required this.mimeType,
    required this.isVideo,
  });

  static Asset fromDTO({
    required AssetResponseDTO dto,
    required String serverUrl,
  }) => Asset(
    id: dto.id,
    serverUrl: serverUrl,
    mimeType: dto.originalMimeType ?? "",
    isVideo: dto.type == .VIDEO,
    width: dto.width,
    height: dto.height,
  );
}
