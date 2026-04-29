enum TipoUsuario {
  donante('donante'),
  visitante('visitante'),
  administrador('administrador');

  final String wire;
  const TipoUsuario(this.wire);

  static TipoUsuario fromWire(String value) =>
      TipoUsuario.values.firstWhere((e) => e.wire == value);
}

class Usuario {
  final String idUsuario;
  final String nombre;
  final String apellido;
  final String correo;
  final String telefono;
  final String? direccion;
  final String documentoIdentidad;
  final TipoUsuario tipoUsuario;
  final DateTime fechaRegistro;
  final String passwordHash;

  const Usuario({
    required this.idUsuario,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.telefono,
    this.direccion,
    required this.documentoIdentidad,
    required this.tipoUsuario,
    required this.fechaRegistro,
    required this.passwordHash,
  });

  String get nombreCompleto => '$nombre $apellido';

  Map<String, Object?> toMap() => {
        'id_usuario': idUsuario,
        'nombre': nombre,
        'apellido': apellido,
        'correo': correo,
        'telefono': telefono,
        'direccion': direccion,
        'documento_identidad': documentoIdentidad,
        'tipo_usuario': tipoUsuario.wire,
        'fecha_registro':
            fechaRegistro.toIso8601String().substring(0, 10),
        'password_hash': passwordHash,
      };

  factory Usuario.fromMap(Map<String, Object?> row) => Usuario(
        idUsuario: row['id_usuario'] as String,
        nombre: row['nombre'] as String,
        apellido: row['apellido'] as String,
        correo: row['correo'] as String,
        telefono: row['telefono'] as String,
        direccion: row['direccion'] as String?,
        documentoIdentidad: row['documento_identidad'] as String,
        tipoUsuario: TipoUsuario.fromWire(row['tipo_usuario'] as String),
        fechaRegistro: DateTime.parse(row['fecha_registro'] as String),
        passwordHash: row['password_hash'] as String,
      );

  Usuario copyWith({
    String? idUsuario,
    String? nombre,
    String? apellido,
    String? correo,
    String? telefono,
    String? direccion,
    String? documentoIdentidad,
    TipoUsuario? tipoUsuario,
    DateTime? fechaRegistro,
    String? passwordHash,
  }) =>
      Usuario(
        idUsuario: idUsuario ?? this.idUsuario,
        nombre: nombre ?? this.nombre,
        apellido: apellido ?? this.apellido,
        correo: correo ?? this.correo,
        telefono: telefono ?? this.telefono,
        direccion: direccion ?? this.direccion,
        documentoIdentidad: documentoIdentidad ?? this.documentoIdentidad,
        tipoUsuario: tipoUsuario ?? this.tipoUsuario,
        fechaRegistro: fechaRegistro ?? this.fechaRegistro,
        passwordHash: passwordHash ?? this.passwordHash,
      );
}
