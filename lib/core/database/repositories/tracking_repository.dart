import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../features/device_pickup/domain/entities/enums.dart';
import '../database_helper.dart';
import '../models/tracking_estado.dart';
import '../schema.dart';

class TrackingRepository {
  TrackingRepository({DatabaseHelper? db, Uuid? uuid})
      : _db = db ?? DatabaseHelper.instance,
        _uuid = uuid ?? const Uuid();

  final DatabaseHelper _db;
  final Uuid _uuid;

  Future<Database> get _database => _db.database;

  Future<TrackingEstado> addEvent({
    required String idDispositivo,
    required TrackingStage etapa,
    String? subestado,
    String? mensajeUsuario,
    required ProcessingType procesamientoTipo,
  }) async {
    final db = await _database;
    final event = TrackingEstado(
      idTracking: _uuid.v4(),
      idDispositivo: idDispositivo,
      etapa: etapa,
      subestado: subestado,
      fechaActualizacion: DateTime.now(),
      mensajeUsuario: mensajeUsuario,
      procesamientoTipo: procesamientoTipo,
    );
    await db.insert(DbSchema.tableTracking, event.toMap());
    return event;
  }

  Future<List<TrackingEstado>> findByDispositivo(String idDispositivo) async {
    final db = await _database;
    final rows = await db.query(
      DbSchema.tableTracking,
      where: 'id_dispositivo = ?',
      whereArgs: [idDispositivo],
      orderBy: 'fecha_actualizacion ASC',
    );
    return rows.map(TrackingEstado.fromMap).toList();
  }

  Future<TrackingEstado?> latestFor(String idDispositivo) async {
    final db = await _database;
    final rows = await db.query(
      DbSchema.tableTracking,
      where: 'id_dispositivo = ?',
      whereArgs: [idDispositivo],
      orderBy: 'fecha_actualizacion DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return TrackingEstado.fromMap(rows.first);
  }
}
