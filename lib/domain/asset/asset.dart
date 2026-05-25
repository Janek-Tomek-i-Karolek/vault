import 'package:vault/data/model/asset/asset_response_dto.dart';
import 'package:vault/domain/server/server_connection.dart';

class Asset {
  // nullable in case it's not stored yet
  String id;
  ServerConnection serverConnection;
  int? width;
  int? height;
  String mimeType;
  bool isVideo;
  Asset({
    this.width,
    this.height,
    required this.id,
    required this.serverConnection,
    required this.mimeType,
    required this.isVideo,
  });

  static Asset fromDTO(
    AssetResponseDTO dto,
    ServerConnection serverConnection,
  ) => Asset(
    id: dto.id,
    serverConnection: serverConnection,
    mimeType: dto.originalMimeType ?? "",
    isVideo: dto.type == .VIDEO,
    width: dto.width,
    height: dto.height,
  );

  String get thumbnailUri =>
      "${serverConnection.serverUrl}/api/assets/$id/thumbnail";
}
