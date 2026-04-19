import '../../../features/device_pickup/domain/entities/enums.dart';

enum EstadoSolicitud {
  pendiente('pendiente'),
  enProceso('en_proceso'),
  completada('completada'),
  cancelada('cancelada');

  final String wire;
  const EstadoSolicitud(this.wire);

  static EstadoSolicitud fromWire(String value) =>
      EstadoSolicitud.values.firstWhere((e) => e.wire == value);
}

class SolicitudRecogida {
  final String idSolicitud;
  final String idUsuario;
  final String idDispositivo;
  final String? idPunto;
  final DateTime fechaSolicitud;
  final DeliveryMethod metodoEntrega;
  final String? direccion;
  final DateTime? fechaPreferida;
  final EstadoSolicitud estadoSolicitud;

  const SolicitudRecogida({
    required this.idSolicitud,
    required this.idUsuario,
    required this.idDispositivo,
    this.idPunto,
    required this.fechaSolicitud,
    required this.metodoEntrega,
    this.direccion,
    this.fechaPreferida,
    required this.estadoSolicitud,
  });

  Map<String, Object?> toMap() => {
        'id_solicitud': idSolicitud,
        'id_usuario': idUsuario,
        'id_dispositivo': idDispositivo,
        'id_punto': idPunto,
        'fecha_solicitud':
            fechaSolicitud.toIso8601String().substring(0, 10),
        'metodo_entrega': metodoEntrega.name,
        'direccion': direccion,
        'fecha_preferida':
            fechaPreferida?.toIso8601String().substring(0, 10),
        'estado_solicitud': estadoSolicitud.wire,
      };

  factory SolicitudRecogida.fromMap(Map<String, Object?> row) =>
      SolicitudRecogida(
        idSolicitud: row['id_solicitud'] as String,
        idUsuario: row['id_usuario'] as String,
        idDispositivo: row['id_dispositivo'] as String,
        idPunto: row['id_punto'] as String?,
        fechaSolicitud: DateTime.parse(row['fecha_solicitud'] as String),
        metodoEntrega:
            DeliveryMethod.values.byName(row['metodo_entrega'] as String),
        direccion: row['direccion'] as String?,
        fechaPreferida: row['fecha_preferida'] == null
            ? null
            : DateTime.parse(row['fecha_preferida'] as String),
        estadoSolicitud:
            EstadoSolicitud.fromWire(row['estado_solicitud'] as String),
      );

  SolicitudRecogida copyWith({
    EstadoSolicitud? estadoSolicitud,
    DateTime? fechaPreferida,
    String? direccion,
    String? idPunto,
  }) =>
      SolicitudRecogida(
        idSolicitud: idSolicitud,
        idUsuario: idUsuario,
        idDispositivo: idDispositivo,
        idPunto: idPunto ?? this.idPunto,
        fechaSolicitud: fechaSolicitud,
        metodoEntrega: metodoEntrega,
        direccion: direccion ?? this.direccion,
        fechaPreferida: fechaPreferida ?? this.fechaPreferida,
        estadoSolicitud: estadoSolicitud ?? this.estadoSolicitud,
      );
}
