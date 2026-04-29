class UserProfileEntity {
  final String id;
  final String nombres;
  final String apellidos;
  final String celular;
  final String correo;

  const UserProfileEntity({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.celular,
    required this.correo,
  });

  UserProfileEntity copyWith({
    String? nombres,
    String? apellidos,
    String? celular,
    String? correo,
  }) {
    return UserProfileEntity(
      id: id,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      celular: celular ?? this.celular,
      correo: correo ?? this.correo,
    );
  }
}