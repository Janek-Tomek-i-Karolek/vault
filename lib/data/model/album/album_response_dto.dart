import 'package:vault/data/model/asset/asset_response_dto.dart';
import 'package:vault/data/model/user/user_response_dto.dart';

// Some of the fields are ommited from the request response
// idk if we need them
class AlbumResponseDto {
  final String id;
  final String albumName;
  final String? albumThumbnailAssetId;
  final List<AlbumResponseDto> albumUsers;
  final List<AssetResponseDTO> assets;
  final String description;
  final UserResponseDTO owner;
  final String ownerId;
  final bool shared;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AlbumResponseDto({
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
}
