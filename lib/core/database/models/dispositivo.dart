import '../../../features/device_pickup/domain/entities/enums.dart';

class Dispositivo {
  final String idDispositivo;
  final String idUsuario;
  final String marca;
  final String modelo;
  final int anoAproximado;
  final DeviceType tipoDispositivo;
  final double pesoEstimado;
  final String? antiguedad;
  final bool funciona;
  final bool piezaEntera;
  final String? fotoUrl;
  final DateTime fechaRegistro;

  const Dispositivo({
    required this.idDispositivo,
    required this.idUsuario,
    required this.marca,
    required this.modelo,
    required this.anoAproximado,
    required this.tipoDispositivo,
    required this.pesoEstimado,
    this.antiguedad,
    required this.funciona,
    required this.piezaEntera,
    this.fotoUrl,
    required this.fechaRegistro,
  });

  Map<String, Object?> toMap() => {
        'id_dispositivo': idDispositivo,
        'id_usuario': idUsuario,
        'marca': marca,
        'modelo': modelo,
        'ano_aproximado': anoAproximado,
        'tipo_dispositivo': tipoDispositivo.name,
        'peso_estimado': pesoEstimado,
        'antiguedad': antiguedad,
        'funciona': funciona ? 1 : 0,
        'pieza_entera': piezaEntera ? 1 : 0,
        'foto_url': fotoUrl,
        'fecha_registro':
            fechaRegistro.toIso8601String().substring(0, 10),
      };

  factory Dispositivo.fromMap(Map<String, Object?> row) => Dispositivo(
        idDispositivo: row['id_dispositivo'] as String,
        idUsuario: row['id_usuario'] as String,
        marca: row['marca'] as String,
        modelo: row['modelo'] as String,
        anoAproximado: (row['ano_aproximado'] as num).toInt(),
        tipoDispositivo:
            DeviceType.values.byName(row['tipo_dispositivo'] as String),
        pesoEstimado: (row['peso_estimado'] as num).toDouble(),
        antiguedad: row['antiguedad'] as String?,
        funciona: (row['funciona'] as int) == 1,
        piezaEntera: (row['pieza_entera'] as int) == 1,
        fotoUrl: row['foto_url'] as String?,
        fechaRegistro: DateTime.parse(row['fecha_registro'] as String),
      );
}
