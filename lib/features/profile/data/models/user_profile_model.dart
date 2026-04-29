import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.id,
    required super.nombres,
    required super.apellidos,
    required super.celular,
    required super.correo,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      celular: json['celular'] ?? '',
      correo: json['correo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombres': nombres,
        'apellidos': apellidos,
        'celular': celular,
        'correo': correo,
      };
}