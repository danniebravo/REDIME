import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'schema.dart';
import 'seed.dart';

/// Single entry point for the REDIME local database.
///
/// Uses sqflite on Android/iOS and sqflite_common_ffi on Windows/Linux/macOS
/// (including Flutter tests and `dart run`). Web is not supported.
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;
  Completer<Database>? _opening;
  String? _overridePath;

  bool get isSupported => !kIsWeb;

  /// Tests can point the helper at an isolated file (or
  /// `inMemoryDatabasePath`) before the first call to [database].
  void overridePath(String? path) {
    _overridePath = path;
  }

  Future<Database> get database async {
    if (_db != null) return _db!;
    if (_opening != null) return _opening!.future;
    final c = Completer<Database>();
    _opening = c;
    try {
      final db = await _open();
      _db = db;
      c.complete(db);
      return db;
    } catch (e, s) {
      c.completeError(e, s);
      rethrow;
    } finally {
      _opening = null;
    }
  }

  Future<Database> _open() async {
    _initFactory();
    final path = await _resolvePath();
    return openDatabase(
      path,
      version: DbSchema.version,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        final batch = db.batch();
        for (final stmt in DbSchema.createStatements) {
          batch.execute(stmt);
        }
        await batch.commit(noResult: true);
        await DbSeed.seedIfNeeded(db);
      },
      onUpgrade: (db, oldV, newV) async {
        // Additive migrations only. Bump DbSchema.version and extend here
        // when the schema evolves.
      },
    );
  }

  void _initFactory() {
    if (kIsWeb) return;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<String> _resolvePath() async {
    if (_overridePath != null) return _overridePath!;
    try {
      final dir = await getApplicationDocumentsDirectory();
      return p.join(dir.path, DbSchema.fileName);
    } catch (_) {
      return p.join(Directory.systemTemp.path, DbSchema.fileName);
    }
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  /// Dangerous: wipes the database file. Intended for tests.
  Future<void> reset() async {
    _initFactory();
    await close();
    try {
      final path = await _resolvePath();
      await deleteDatabase(path);
    } catch (_) {
      // If the file never existed we can ignore.
    }
  }
}
