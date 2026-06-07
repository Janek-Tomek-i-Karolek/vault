// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_media_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetMediaResponseDTO _$AssetMediaResponseDTOFromJson(
  Map<String, dynamic> json,
) => AssetMediaResponseDTO(
  id: json['id'] as String,
  status: $enumDecode(_$AssetMediaStatusEnumMap, json['status']),
);

Map<String, dynamic> _$AssetMediaResponseDTOToJson(
  AssetMediaResponseDTO instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': _$AssetMediaStatusEnumMap[instance.status]!,
};

const _$AssetMediaStatusEnumMap = {
  AssetMediaStatus.created: 'created',
  AssetMediaStatus.replaced: 'replaced',
  AssetMediaStatus.duplicate: 'duplicate',
};
