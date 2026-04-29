enum EstadoAprobacion {
  pendiente('pendiente'),
  aprobada('aprobada'),
  rechazada('rechazada');

  final String wire;
  const EstadoAprobacion(this.wire);

  static EstadoAprobacion fromWire(String value) =>
      EstadoAprobacion.values.firstWhere((e) => e.wire == value);
}

class HistoriaDispositivo {
  final String idHistoria;
  final String idDispositivo;
  final String textoHistoria;
  final DateTime fechaGeneracion;
  final EstadoAprobacion estadoAprobacion;
  final String? extracto;
  final String? imagenUrl;
  final bool publica;

  const HistoriaDispositivo({
    required this.idHistoria,
    required this.idDispositivo,
    required this.textoHistoria,
    required this.fechaGeneracion,
    required this.estadoAprobacion,
    this.extracto,
    this.imagenUrl,
    required this.publica,
  });

  Map<String, Object?> toMap() => {
        'id_historia': idHistoria,
        'id_dispositivo': idDispositivo,
        'texto_historia': textoHistoria,
        'fecha_generacion':
            fechaGeneracion.toIso8601String().substring(0, 10),
        'estado_aprobacion': estadoAprobacion.wire,
        'extracto': extracto,
        'imagen_url': imagenUrl,
        'publica': publica ? 1 : 0,
      };

  factory HistoriaDispositivo.fromMap(Map<String, Object?> row) =>
      HistoriaDispositivo(
        idHistoria: row['id_historia'] as String,
        idDispositivo: row['id_dispositivo'] as String,
        textoHistoria: row['texto_historia'] as String,
        fechaGeneracion: DateTime.parse(row['fecha_generacion'] as String),
        estadoAprobacion:
            EstadoAprobacion.fromWire(row['estado_aprobacion'] as String),
        extracto: row['extracto'] as String?,
        imagenUrl: row['imagen_url'] as String?,
        publica: (row['publica'] as int) == 1,
      );
}
