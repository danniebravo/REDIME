import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../features/device_pickup/domain/entities/enums.dart';
import '../database_helper.dart';
import '../models/dispositivo.dart';
import '../schema.dart';

class DispositivoRepository {
  DispositivoRepository({DatabaseHelper? db, Uuid? uuid})
      : _db = db ?? DatabaseHelper.instance,
        _uuid = uuid ?? const Uuid();

  final DatabaseHelper _db;
  final Uuid _uuid;

  Future<Database> get _database => _db.database;

  Future<Dispositivo> create({
    required String idUsuario,
    required String marca,
    required String modelo,
    required int anoAproximado,
    required DeviceType tipoDispositivo,
    required double pesoEstimado,
    String? antiguedad,
    required bool funciona,
    required bool piezaEntera,
    String? fotoUrl,
  }) async {
    _assertYear(anoAproximado);
    if (pesoEstimado <= 0) {
      throw ArgumentError('peso_estimado debe ser > 0');
    }
    final db = await _database;
    final dispositivo = Dispositivo(
      idDispositivo: _uuid.v4(),
      idUsuario: idUsuario,
      marca: marca.trim(),
      modelo: modelo.trim(),
      anoAproximado: anoAproximado,
      tipoDispositivo: tipoDispositivo,
      pesoEstimado: pesoEstimado,
      antiguedad: antiguedad,
      funciona: funciona,
      piezaEntera: piezaEntera,
      fotoUrl: fotoUrl,
      fechaRegistro: DateTime.now(),
    );
    await db.insert(
      DbSchema.tableDispositivo,
      dispositivo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    return dispositivo;
  }

  Future<Dispositivo?> findById(String id) async {
    final db = await _database;
    final rows = await db.query(
      DbSchema.tableDispositivo,
      where: 'id_dispositivo = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Dispositivo.fromMap(rows.first);
  }

  Future<List<Dispositivo>> findByUsuario(String idUsuario) async {
    final db = await _database;
    final rows = await db.query(
      DbSchema.tableDispositivo,
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
      orderBy: 'fecha_registro DESC',
    );
    return rows.map(Dispositivo.fromMap).toList();
  }

  Future<int> delete(String id) async {
    final db = await _database;
    return db.delete(
      DbSchema.tableDispositivo,
      where: 'id_dispositivo = ?',
      whereArgs: [id],
    );
  }

  void _assertYear(int year) {
    final max = DateTime.now().year;
    if (year < 1990 || year > max) {
      throw ArgumentError('ano_aproximado debe estar entre 1990 y $max');
    }
  }
}
