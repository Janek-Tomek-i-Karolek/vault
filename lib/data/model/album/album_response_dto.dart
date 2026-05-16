import 'package:json_annotation/json_annotation.dart';
import 'package:vault/data/model/album/album_user_response_dto.dart';
import 'package:vault/data/model/asset/asset_response_dto.dart';
import 'package:vault/data/model/user/user_response_dto.dart';

part 'album_response_dto.g.dart';

// Some of the fields are ommited from the request response
// idk if we need them
@JsonSerializable()
class AlbumResponseDTO {
  final String id;
  final String albumName;
  final String? albumThumbnailAssetId;
  final List<AlbumResponseDTO> albumUsers;
  final List<AssetResponseDTO> assets;
  final String description;
  final UserResponseDTO owner;
  final String ownerId;
  final bool shared;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AlbumResponseDTO({
    required this.albumName,
    required this.albumThumbnailAssetId,
    required this.albumUsers,
    required this.assets,
    required this.createdAt,
    required this.description,
    required this.id,
    required this.owner,
    required this.ownerId,
    required this.shared,
    required this.updatedAt,
  });

  factory AlbumResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$AlbumResponseDTOFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumResponseDTOToJson(this);
}
