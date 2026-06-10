import 'package:flutter/material.dart';
import 'package:flutter_thumbhash/flutter_thumbhash.dart';
import 'package:vault/data/model/asset/asset_response_dto.dart';
import 'package:vault/domain/asset/details.dart';
import 'package:vault/domain/server/server_connection.dart';

class Asset {
  // nullable in case it's not stored yet
  final String id;
  final ServerConnection serverConnection;
  final int? width;
  final int? height;
  final String mimeType;
  final bool isVideo;
  final Details details;
  final ImageProvider? thumbImageProvider;
  Asset({
    this.width,
    this.height,
    required this.id,
    required this.serverConnection,
    required this.mimeType,
    required this.isVideo,
    required this.details,
    this.thumbImageProvider,
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
    details: Details.fromDTO(dto.exifInfo, serverConnection),
    thumbImageProvider: dto.thumbhash != null
        ? ThumbHash.fromBase64(dto.thumbhash!).toImage()
        : null,
  );

  String _makeUri({required String suffix}) =>
      "${serverConnection.serverUrl}/api/assets/$id/$suffix";

  String get originalUri => _makeUri(suffix: "original");
  String get thumbnailUri => _makeUri(suffix: "thumbnail?size=thumbnail");
  String get previewUri => _makeUri(suffix: "thumbnail?size=preview");

  Map<String, String> get headers {
    return {
      "x-api-key": serverConnection.apiKey,
      "content-type": "application/json",
    };
  }
}
