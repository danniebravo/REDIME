import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../database_helper.dart';
import '../models/punto_recoleccion.dart';
import '../schema.dart';

class PuntoRepository {
  PuntoRepository({DatabaseHelper? db, Uuid? uuid})
      : _db = db ?? DatabaseHelper.instance,
        _uuid = uuid ?? const Uuid();

  final DatabaseHelper _db;
  final Uuid _uuid;

  Future<Database> get _database => _db.database;

  Future<PuntoRecoleccion> create({
    required String nombre,
    required String direccion,
    required double lat,
    required double lng,
    required String horario,
    required List<String> tiposAceptados,
    bool activo = true,
  }) async {
    final db = await _database;
    final punto = PuntoRecoleccion(
      idPunto: _uuid.v4(),
      nombre: nombre,
      direccion: direccion,
      lat: lat,
      lng: lng,
      horario: horario,
      tiposAceptados: tiposAceptados,
      activo: activo,
    );
    await db.insert(DbSchema.tablePunto, punto.toMap());
    return punto;
  }

  Future<List<PuntoRecoleccion>> activos() async {
    final db = await _database;
    final rows = await db.query(
      DbSchema.tablePunto,
      where: 'activo = 1',
      orderBy: 'nombre ASC',
    );
    return rows.map(PuntoRecoleccion.fromMap).toList();
  }

  Future<List<PuntoRecoleccion>> all() async {
    final db = await _database;
    final rows = await db.query(DbSchema.tablePunto, orderBy: 'nombre ASC');
    return rows.map(PuntoRecoleccion.fromMap).toList();
  }

  Future<PuntoRecoleccion?> findById(String id) async {
    final db = await _database;
    final rows = await db.query(
      DbSchema.tablePunto,
      where: 'id_punto = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return PuntoRecoleccion.fromMap(rows.first);
  }
}
