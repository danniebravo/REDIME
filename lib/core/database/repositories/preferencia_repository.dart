import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../features/device_pickup/domain/entities/enums.dart';
import '../database_helper.dart';
import '../models/preferencia_usuario.dart';
import '../schema.dart';

class PreferenciaRepository {
  PreferenciaRepository({DatabaseHelper? db, Uuid? uuid})
      : _db = db ?? DatabaseHelper.instance,
        _uuid = uuid ?? const Uuid();

  final DatabaseHelper _db;
  final Uuid _uuid;

  Future<Database> get _database => _db.database;

  Future<PreferenciaUsuario> upsert({
    required String idUsuario,
    ProcessingType? tipoProcesamientoPreferido,
    required bool consentimientoPublicacion,
  }) async {
    final db = await _database;
    final existing = await _latest(idUsuario);
    if (existing != null) {
      await db.update(
        DbSchema.tablePreferencia,
        {
          'tipo_procesamiento_preferido':
              tipoProcesamientoPreferido?.name,
          'consentimiento_publicacion':
              consentimientoPublicacion ? 1 : 0,
        },
        where: 'id_preferencia = ?',
        whereArgs: [existing.idPreferencia],
      );
      return PreferenciaUsuario(
        idPreferencia: existing.idPreferencia,
        idUsuario: idUsuario,
        tipoProcesamientoPreferido: tipoProcesamientoPreferido,
        consentimientoPublicacion: consentimientoPublicacion,
      );
    }
    final pref = PreferenciaUsuario(
      idPreferencia: _uuid.v4(),
      idUsuario: idUsuario,
      tipoProcesamientoPreferido: tipoProcesamientoPreferido,
      consentimientoPublicacion: consentimientoPublicacion,
    );
    await db.insert(DbSchema.tablePreferencia, pref.toMap());
    return pref;
  }

  Future<PreferenciaUsuario?> findByUsuario(String idUsuario) =>
      _latest(idUsuario);

  Future<PreferenciaUsuario?> _latest(String idUsuario) async {
    final db = await _database;
    final rows = await db.query(
      DbSchema.tablePreferencia,
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return PreferenciaUsuario.fromMap(rows.first);
  }
}
