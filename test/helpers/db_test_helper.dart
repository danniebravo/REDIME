import 'package:redime/core/database/auth_session.dart';
import 'package:redime/core/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Shared setup for any test that touches the REDIME database.
/// Uses sqflite_common_ffi in-memory so each suite starts from a clean state.
Future<void> initTestDatabase() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  await DatabaseHelper.instance.close();
  DatabaseHelper.instance.overridePath(inMemoryDatabasePath);
  AuthSession.instance.signOut();
}

Future<void> tearDownTestDatabase() async {
  await DatabaseHelper.instance.close();
}
