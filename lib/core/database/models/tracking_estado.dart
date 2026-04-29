import '../../../features/device_pickup/domain/entities/enums.dart';

class TrackingEstado {
  final String idTracking;
  final String idDispositivo;
  final TrackingStage etapa;
  final String? subestado;
  final DateTime fechaActualizacion;
  final String? mensajeUsuario;
  final ProcessingType procesamientoTipo;

  const TrackingEstado({
    required this.idTracking,
    required this.idDispositivo,
    required this.etapa,
    this.subestado,
    required this.fechaActualizacion,
    this.mensajeUsuario,
    required this.procesamientoTipo,
  });

  Map<String, Object?> toMap() => {
        'id_tracking': idTracking,
        'id_dispositivo': idDispositivo,
        'etapa': etapa.name,
        'subestado': subestado,
        'fecha_actualizacion':
            fechaActualizacion.toIso8601String().substring(0, 10),
        'mensaje_usuario': mensajeUsuario,
        'procesamiento_tipo': procesamientoTipo.name,
      };

  factory TrackingEstado.fromMap(Map<String, Object?> row) => TrackingEstado(
        idTracking: row['id_tracking'] as String,
        idDispositivo: row['id_dispositivo'] as String,
        etapa: TrackingStage.values.byName(row['etapa'] as String),
        subestado: row['subestado'] as String?,
        fechaActualizacion:
            DateTime.parse(row['fecha_actualizacion'] as String),
        mensajeUsuario: row['mensaje_usuario'] as String?,
        procesamientoTipo: ProcessingType.values
            .byName(row['procesamiento_tipo'] as String),
      );
}
