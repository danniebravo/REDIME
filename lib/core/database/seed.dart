import 'package:sqflite/sqflite.dart';

import 'password_hasher.dart';
import 'schema.dart';

/// Inserts minimum-viable reference data so the app is usable the first
/// time it starts: a demo user, a handful of Medellín collection points.
class DbSeed {
  DbSeed._();

  static Future<void> seedIfNeeded(Database db) async {
    await _seedPuntos(db);
    await _seedDemoUser(db);
  }

  static Future<void> _seedPuntos(Database db) async {
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${DbSchema.tablePunto}'),
    );
    if (count != null && count > 0) return;

    final puntos = <Map<String, Object?>>[
      {
        'id_punto': 'punto-centro-mde',
        'nombre': 'EcoPunto Centro Medellín',
        'direccion': 'Cra. 52 #44-17, La Candelaria, Medellín',
        'lat': 6.24470,
        'lng': -75.57389,
        'horario': 'Lun-Sáb 8:00-18:00',
        'tipos_aceptados':
            'largeAppliance,smallAppliance,telecomEquipment,other',
        'activo': 1,
      },
      {
        'id_punto': 'punto-poblado',
        'nombre': 'EcoPunto El Poblado',
        'direccion': 'Cl. 10 #43E-135, El Poblado, Medellín',
        'lat': 6.20833,
        'lng': -75.56778,
        'horario': 'Lun-Vie 9:00-19:00, Sáb 9:00-14:00',
        'tipos_aceptados': 'smallAppliance,telecomEquipment',
        'activo': 1,
      },
      {
        'id_punto': 'punto-laureles',
        'nombre': 'EcoPunto Laureles',
        'direccion': 'Cl. 33 #76-50, Laureles, Medellín',
        'lat': 6.24611,
        'lng': -75.58972,
        'horario': 'Lun-Sáb 7:30-17:30',
        'tipos_aceptados':
            'largeAppliance,smallAppliance,telecomEquipment,other',
        'activo': 1,
      },
    ];

    final batch = db.batch();
    for (final row in puntos) {
      batch.insert(DbSchema.tablePunto, row);
    }
    await batch.commit(noResult: true);
  }

  static Future<void> _seedDemoUser(Database db) async {
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${DbSchema.tableUsuario}'),
    );
    if (count != null && count > 0) return;

    // Demo credentials: correo `demo@redime.co`, password `demo1234`.
    await db.insert(DbSchema.tableUsuario, {
      'id_usuario': 'demo-user-0001',
      'nombre': 'Demo',
      'apellido': 'REDIME',
      'correo': 'demo@redime.co',
      'telefono': '3000000000',
      'direccion': 'Medellín, Antioquia',
      'documento_identidad': '1000000000',
      'tipo_usuario': 'donante',
      'fecha_registro': DateTime.now().toIso8601String().substring(0, 10),
      'password_hash': PasswordHasher.hash('demo1234'),
    });
  }
}
