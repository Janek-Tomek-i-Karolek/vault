// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumResponseDTO _$AlbumResponseDTOFromJson(Map<String, dynamic> json) =>
    AlbumResponseDTO(
      albumName: json['albumName'] as String,
      albumThumbnailAssetId: json['albumThumbnailAssetId'] as String?,
      albumUsers: (json['albumUsers'] as List<dynamic>)
          .map((e) => AlbumResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      assets: (json['assets'] as List<dynamic>)
          .map((e) => AssetResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      description: json['description'] as String,
      id: json['id'] as String,
      owner: UserResponseDTO.fromJson(json['owner'] as Map<String, dynamic>),
      ownerId: json['ownerId'] as String,
      shared: json['shared'] as bool,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AlbumResponseDTOToJson(AlbumResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'albumName': instance.albumName,
      'albumThumbnailAssetId': instance.albumThumbnailAssetId,
      'albumUsers': instance.albumUsers,
      'assets': instance.assets,
      'description': instance.description,
      'owner': instance.owner,
      'ownerId': instance.ownerId,
      'shared': instance.shared,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
