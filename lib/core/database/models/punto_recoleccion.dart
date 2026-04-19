class PuntoRecoleccion {
  final String idPunto;
  final String nombre;
  final String direccion;
  final double lat;
  final double lng;
  final String horario;
  final List<String> tiposAceptados;
  final bool activo;

  const PuntoRecoleccion({
    required this.idPunto,
    required this.nombre,
    required this.direccion,
    required this.lat,
    required this.lng,
    required this.horario,
    required this.tiposAceptados,
    required this.activo,
  });

  Map<String, Object?> toMap() => {
        'id_punto': idPunto,
        'nombre': nombre,
        'direccion': direccion,
        'lat': lat,
        'lng': lng,
        'horario': horario,
        'tipos_aceptados': tiposAceptados.join(','),
        'activo': activo ? 1 : 0,
      };

  factory PuntoRecoleccion.fromMap(Map<String, Object?> row) =>
      PuntoRecoleccion(
        idPunto: row['id_punto'] as String,
        nombre: row['nombre'] as String,
        direccion: row['direccion'] as String,
        lat: (row['lat'] as num).toDouble(),
        lng: (row['lng'] as num).toDouble(),
        horario: row['horario'] as String,
        tiposAceptados: (row['tipos_aceptados'] as String)
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
        activo: (row['activo'] as int) == 1,
      );
}
