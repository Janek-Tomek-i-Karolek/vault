import 'package:json_annotation/json_annotation.dart';
import 'package:vault/data/model/album/album_user_role_enum.dart';
import 'package:vault/data/model/user/user_response_dto.dart';

part 'album_user_response_dto.g.dart';

@JsonSerializable()
class AlbumUserResponseDTO {
  final AlbumUserRole role;
  final UserResponseDTO user;

  AlbumUserResponseDTO({required this.role, required this.user});

  factory AlbumUserResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$AlbumUserResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumUserResponseDTOToJson(this);
}
