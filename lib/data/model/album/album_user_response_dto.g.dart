// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_user_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumUserResponseDTO _$AlbumUserResponseDTOFromJson(
  Map<String, dynamic> json,
) => AlbumUserResponseDTO(
  role: $enumDecode(_$AlbumUserRoleEnumMap, json['role']),
  user: UserResponseDTO.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AlbumUserResponseDTOToJson(
  AlbumUserResponseDTO instance,
) => <String, dynamic>{
  'role': _$AlbumUserRoleEnumMap[instance.role]!,
  'user': instance.user,
};

const _$AlbumUserRoleEnumMap = {
  AlbumUserRole.editor: 'editor',
  AlbumUserRole.viewer: 'viewer',
};
