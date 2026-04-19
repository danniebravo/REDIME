import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../database_helper.dart';
import '../models/usuario.dart';
import '../password_hasher.dart';
import '../schema.dart';

class UsuarioRepository {
  UsuarioRepository({DatabaseHelper? db, Uuid? uuid})
      : _db = db ?? DatabaseHelper.instance,
        _uuid = uuid ?? const Uuid();

  final DatabaseHelper _db;
  final Uuid _uuid;

  Future<Database> get _database => _db.database;

  Future<Usuario> create({
    required String nombre,
    required String apellido,
    required String correo,
    required String telefono,
    String? direccion,
    required String documentoIdentidad,
    TipoUsuario tipoUsuario = TipoUsuario.donante,
    required String password,
  }) async {
    final db = await _database;
    final usuario = Usuario(
      idUsuario: _uuid.v4(),
      nombre: nombre.trim(),
      apellido: apellido.trim(),
      correo: correo.trim().toLowerCase(),
      telefono: telefono.trim(),
      direccion: direccion?.trim().isEmpty == true ? null : direccion?.trim(),
      documentoIdentidad: documentoIdentidad.trim(),
      tipoUsuario: tipoUsuario,
      fechaRegistro: DateTime.now(),
      passwordHash: PasswordHasher.hash(password),
    );
    await db.insert(
      DbSchema.tableUsuario,
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    return usuario;
  }

  Future<Usuario?> findById(String id) async {
    final db = await _database;
    final rows = await db.query(
      DbSchema.tableUsuario,
      where: 'id_usuario = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Usuario.fromMap(rows.first);
  }

  Future<Usuario?> findByCorreo(String correo) async {
    final db = await _database;
    final rows = await db.query(
      DbSchema.tableUsuario,
      where: 'correo = ?',
      whereArgs: [correo.trim().toLowerCase()],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Usuario.fromMap(rows.first);
  }

  Future<Usuario?> authenticate(String correo, String password) async {
    final user = await findByCorreo(correo);
    if (user == null) return null;
    if (!PasswordHasher.verify(password, user.passwordHash)) return null;
    return user;
  }

  Future<int> update(Usuario u) async {
    final db = await _database;
    return db.update(
      DbSchema.tableUsuario,
      u.toMap(),
      where: 'id_usuario = ?',
      whereArgs: [u.idUsuario],
    );
  }

  Future<int> delete(String id) async {
    final db = await _database;
    return db.delete(
      DbSchema.tableUsuario,
      where: 'id_usuario = ?',
      whereArgs: [id],
    );
  }

  Future<List<Usuario>> all() async {
    final db = await _database;
    final rows = await db.query(DbSchema.tableUsuario, orderBy: 'nombre ASC');
    return rows.map(Usuario.fromMap).toList();
  }
}
