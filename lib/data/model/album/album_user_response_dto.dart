import 'package:vault/data/model/album/album_user_role_enum.dart';
import 'package:vault/data/model/user/user_response_dto.dart';

class AlbumUserResponseDTO {
  final AlbumUserRole role;
  final UserResponseDTO user;

  AlbumUserResponseDTO({required this.role, required this.user});
}
