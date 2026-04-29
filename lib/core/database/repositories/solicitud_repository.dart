import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../features/device_pickup/domain/entities/enums.dart';
import '../database_helper.dart';
import '../models/solicitud_recogida.dart';
import '../schema.dart';

class SolicitudRepository {
  SolicitudRepository({DatabaseHelper? db, Uuid? uuid})
      : _db = db ?? DatabaseHelper.instance,
        _uuid = uuid ?? const Uuid();

  final DatabaseHelper _db;
  final Uuid _uuid;

  Future<Database> get _database => _db.database;

  Future<SolicitudRecogida> create({
    required String idUsuario,
    required String idDispositivo,
    required DeliveryMethod metodoEntrega,
    String? direccion,
    String? idPunto,
    DateTime? fechaPreferida,
    EstadoSolicitud estado = EstadoSolicitud.pendiente,
  }) async {
    if (metodoEntrega == DeliveryMethod.homePickup &&
        (direccion == null || direccion.trim().isEmpty)) {
      throw ArgumentError('homePickup requiere dirección');
    }
    if (metodoEntrega == DeliveryMethod.dropOffPoint &&
        (idPunto == null || idPunto.trim().isEmpty)) {
      throw ArgumentError('dropOffPoint requiere id_punto');
    }

    final db = await _database;
    final solicitud = SolicitudRecogida(
      idSolicitud: _uuid.v4(),
      idUsuario: idUsuario,
      idDispositivo: idDispositivo,
      idPunto: idPunto,
      fechaSolicitud: DateTime.now(),
      metodoEntrega: metodoEntrega,
      direccion: direccion,
      fechaPreferida: fechaPreferida,
      estadoSolicitud: estado,
    );
    await db.insert(
      DbSchema.tableSolicitud,
      solicitud.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    return solicitud;
  }

  Future<SolicitudRecogida?> findById(String id) async {
    final db = await _database;
    final rows = await db.query(
      DbSchema.tableSolicitud,
      where: 'id_solicitud = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return SolicitudRecogida.fromMap(rows.first);
  }

  Future<List<SolicitudRecogida>> findByUsuario(String idUsuario) async {
    final db = await _database;
    final rows = await db.query(
      DbSchema.tableSolicitud,
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
      orderBy: 'fecha_solicitud DESC',
    );
    return rows.map(SolicitudRecogida.fromMap).toList();
  }

  Future<SolicitudRecogida?> findByDispositivo(String idDispositivo) async {
    final db = await _database;
    final rows = await db.query(
      DbSchema.tableSolicitud,
      where: 'id_dispositivo = ?',
      whereArgs: [idDispositivo],
      orderBy: 'fecha_solicitud DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return SolicitudRecogida.fromMap(rows.first);
  }

  Future<int> updateEstado(String id, EstadoSolicitud estado) async {
    final db = await _database;
    return db.update(
      DbSchema.tableSolicitud,
      {'estado_solicitud': estado.wire},
      where: 'id_solicitud = ?',
      whereArgs: [id],
    );
  }
}
