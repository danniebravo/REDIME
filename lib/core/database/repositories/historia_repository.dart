import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../database_helper.dart';
import '../models/historia_dispositivo.dart';
import '../schema.dart';

class HistoriaRepository {
  HistoriaRepository({DatabaseHelper? db, Uuid? uuid})
      : _db = db ?? DatabaseHelper.instance,
        _uuid = uuid ?? const Uuid();

  final DatabaseHelper _db;
  final Uuid _uuid;

  Future<Database> get _database => _db.database;

  /// Creates a story for a device. Enforces the 1:1 rule — a device can only
  /// have a single story. A second attempt raises a UNIQUE constraint error.
  Future<HistoriaDispositivo> create({
    required String idDispositivo,
    required String textoHistoria,
    String? extracto,
    String? imagenUrl,
    EstadoAprobacion estado = EstadoAprobacion.pendiente,
    bool publica = false,
  }) async {
    if (publica && estado != EstadoAprobacion.aprobada) {
      throw StateError('Una historia pública requiere estado aprobada');
    }
    final db = await _database;
    final historia = HistoriaDispositivo(
      idHistoria: _uuid.v4(),
      idDispositivo: idDispositivo,
      textoHistoria: textoHistoria,
      fechaGeneracion: DateTime.now(),
      estadoAprobacion: estado,
      extracto: extracto,
      imagenUrl: imagenUrl,
      publica: publica,
    );
    await db.insert(
      DbSchema.tableHistoria,
      historia.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    return historia;
  }

  Future<HistoriaDispositivo?> findByDispositivo(String idDispositivo) async {
    final db = await _database;
    final rows = await db.query(
      DbSchema.tableHistoria,
      where: 'id_dispositivo = ?',
      whereArgs: [idDispositivo],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return HistoriaDispositivo.fromMap(rows.first);
  }

  /// Public archive: only approved stories flagged `publica = 1`.
  Future<List<HistoriaDispositivo>> publicas() async {
    final db = await _database;
    final rows = await db.query(
      DbSchema.tableHistoria,
      where: 'publica = 1 AND estado_aprobacion = ?',
      whereArgs: [EstadoAprobacion.aprobada.wire],
      orderBy: 'fecha_generacion DESC',
    );
    return rows.map(HistoriaDispositivo.fromMap).toList();
  }

  /// Approves a story. Does NOT toggle `publica` on its own — publicación
  /// exige que exista consentimiento del usuario, que se valida aparte.
  Future<int> aprobar(String idHistoria, {bool publicar = false}) async {
    final db = await _database;
    return db.update(
      DbSchema.tableHistoria,
      {
        'estado_aprobacion': EstadoAprobacion.aprobada.wire,
        'publica': publicar ? 1 : 0,
      },
      where: 'id_historia = ?',
      whereArgs: [idHistoria],
    );
  }

  Future<int> rechazar(String idHistoria) async {
    final db = await _database;
    return db.update(
      DbSchema.tableHistoria,
      {
        'estado_aprobacion': EstadoAprobacion.rechazada.wire,
        'publica': 0,
      },
      where: 'id_historia = ?',
      whereArgs: [idHistoria],
    );
  }
}
