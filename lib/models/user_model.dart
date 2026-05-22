class UserModel {
  final int id;
  final String nombre;
  final String apellido;
  final String nombreUsuario;
  final String email;
  final String celular;
  final String cedula;
  final String? googleId;
  final String? photoUrl;
  final bool hasPassword;

  UserModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.nombreUsuario,
    required this.email,
    required this.celular,
    required this.cedula,
    this.googleId,
    this.photoUrl,
    this.hasPassword = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      nombre: (json['nombre'] ?? '') as String,
      apellido: (json['apellido'] ?? '') as String,
      nombreUsuario: (json['nombre_usuario'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      celular: (json['celular'] ?? '') as String,
      cedula: (json['cedula'] ?? '') as String,
      googleId: json['google_id'] as String?,
      photoUrl: json['photo_url'] as String?,
      hasPassword: (json['has_password'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'nombre_usuario': nombreUsuario,
      'email': email,
      'celular': celular,
      'cedula': cedula,
    };
  }

  String get nombreCompleto => '$nombre $apellido'.trim();

  bool get isGoogleUser => googleId != null && googleId!.isNotEmpty;
}
