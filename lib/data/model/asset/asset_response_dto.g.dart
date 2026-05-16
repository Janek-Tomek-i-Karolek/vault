// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetResponseDTO _$AssetResponseDTOFromJson(Map<String, dynamic> json) =>
    AssetResponseDTO(
      id: json['id'] as String,
      exifInfo: json['exifInfo'] == null
          ? null
          : ExifResponseDTO.fromJson(json['exifInfo'] as Map<String, dynamic>),
      fileCreatedAt: DateTime.parse(json['fileCreatedAt'] as String),
      fileModifiedAt: DateTime.parse(json['fileModifiedAt'] as String),
      hasMetadata: json['hasMetadata'] as bool,
      height: (json['height'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      isFavorite: json['isFavorite'] as bool,
      originalFileName: json['originalFileName'] as String,
      originalMimeType: json['originalMimeType'] as String?,
      originalPath: json['originalPath'] as String,
      owner: json['owner'] == null
          ? null
          : UserResponseDTO.fromJson(json['owner'] as Map<String, dynamic>),
      ownerId: json['ownerId'] as String,
      thumbhash: json['thumbhash'] as String?,
      type: $enumDecode(_$AssetTypeEnumEnumMap, json['type']),
      duration: json['duration'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AssetResponseDTOToJson(AssetResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'exifInfo': instance.exifInfo,
      'fileCreatedAt': instance.fileCreatedAt.toIso8601String(),
      'fileModifiedAt': instance.fileModifiedAt.toIso8601String(),
      'hasMetadata': instance.hasMetadata,
      'height': instance.height,
      'width': instance.width,
      'isFavorite': instance.isFavorite,
      'originalFileName': instance.originalFileName,
      'originalMimeType': instance.originalMimeType,
      'originalPath': instance.originalPath,
      'owner': instance.owner,
      'ownerId': instance.ownerId,
      'thumbhash': instance.thumbhash,
      'type': _$AssetTypeEnumEnumMap[instance.type]!,
      'duration': instance.duration,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$AssetTypeEnumEnumMap = {
  AssetTypeEnum.IMAGE: 'IMAGE',
  AssetTypeEnum.VIDEO: 'VIDEO',
};
