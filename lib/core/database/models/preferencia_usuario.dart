import '../../../features/device_pickup/domain/entities/enums.dart';

class PreferenciaUsuario {
  final String idPreferencia;
  final String idUsuario;
  final ProcessingType? tipoProcesamientoPreferido;
  final bool consentimientoPublicacion;

  const PreferenciaUsuario({
    required this.idPreferencia,
    required this.idUsuario,
    this.tipoProcesamientoPreferido,
    required this.consentimientoPublicacion,
  });

  Map<String, Object?> toMap() => {
        'id_preferencia': idPreferencia,
        'id_usuario': idUsuario,
        'tipo_procesamiento_preferido': tipoProcesamientoPreferido?.name,
        'consentimiento_publicacion': consentimientoPublicacion ? 1 : 0,
      };

  factory PreferenciaUsuario.fromMap(Map<String, Object?> row) =>
      PreferenciaUsuario(
        idPreferencia: row['id_preferencia'] as String,
        idUsuario: row['id_usuario'] as String,
        tipoProcesamientoPreferido:
            row['tipo_procesamiento_preferido'] == null
                ? null
                : ProcessingType.values.byName(
                    row['tipo_procesamiento_preferido'] as String),
        consentimientoPublicacion:
            (row['consentimiento_publicacion'] as int) == 1,
      );
}
