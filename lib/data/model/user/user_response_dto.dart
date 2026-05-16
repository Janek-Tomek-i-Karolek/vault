import 'package:json_annotation/json_annotation.dart';

part 'user_response_dto.g.dart';

@JsonSerializable()
class UserResponseDTO {
  final String id;
  final String email;
  final String name;
  final String profileImagePath;

  UserResponseDTO({
    required this.id,
    required this.email,
    required this.name,
    required this.profileImagePath,
  });

  factory UserResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$UserResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseDTOToJson(this);
}
