import 'package:json_annotation/json_annotation.dart';
import 'package:vault/data/model/asset/asseta_media_status_enum.dart';

part 'asset_media_response_dto.g.dart';

@JsonSerializable()
class AssetMediaResponseDTO {
  final String id;
  final AssetMediaStatus status;

  AssetMediaResponseDTO({required this.id, required this.status});

  factory AssetMediaResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$AssetMediaResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AssetMediaResponseDTOToJson(this);
}
