import 'package:vault/data/model/asset/ExifResponseDto.dart';
import 'package:vault/data/model/asset/asset_type_enum.dart';
import 'package:vault/data/model/user/user_response_dto.dart';

class AssetResponseDTO {
  final String id;
  final ExifResponseDTO? exifInfo;
  final DateTime fileCreatedAt;
  final DateTime fileModifiedAt;
  final bool hasMetadata;
  final int? height;
  final int? width;
  final bool isFavorite;
  final String originalFileName;
  final String? originalMimeType;
  final String originalPath;
  final UserResponseDTO? owner;
  final String ownerId;
  final String? thumbhash; // can be usefull for thumbnails, idk for now
  final AssetTypeEnum type;
  final String duration;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssetResponseDTO({
    required this.id,
    required this.exifInfo,
    required this.fileCreatedAt,
    required this.fileModifiedAt,
    required this.hasMetadata,
    required this.height,
    required this.width,
    required this.isFavorite,
    required this.originalFileName,
    required this.originalMimeType,
    required this.originalPath,
    required this.owner,
    required this.ownerId,
    required this.thumbhash,
    required this.type,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
  });
}
