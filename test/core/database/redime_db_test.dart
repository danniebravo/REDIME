import 'package:flutter_test/flutter_test.dart';
import 'package:redime/core/database/models/historia_dispositivo.dart';
import 'package:redime/core/database/models/solicitud_recogida.dart';
import 'package:redime/core/database/models/usuario.dart';
import 'package:redime/core/database/password_hasher.dart';
import 'package:redime/core/database/redime_db.dart';
import 'package:redime/features/device_pickup/domain/entities/enums.dart';
import 'package:sqflite/sqflite.dart';

import '../../helpers/db_test_helper.dart';

void main() {
  late RedimeDb db;

  setUp(() async {
    await initTestDatabase();
    db = RedimeDb.instance;
    await db.ensureReady();
  });

  tearDown(() async {
    await tearDownTestDatabase();
  });

  test('seed populates recollection points', () async {
    final puntos = await db.puntos.activos();
    expect(puntos, isNotEmpty);
    expect(puntos.first.activo, isTrue);
  });

  test('seed creates the demo user with the expected password', () async {
    final demo = await db.usuarios.findByCorreo('demo@redime.co');
    expect(demo, isNotNull);
    expect(PasswordHasher.verify('demo1234', demo!.passwordHash), isTrue);
  });

  test('usuario email is UNIQUE', () async {
    await db.usuarios.create(
      nombre: 'Ana',
      apellido: 'Pérez',
      correo: 'ana@redime.co',
      telefono: '3001234567',
      documentoIdentidad: 'CC-1',
      password: '1234',
    );
    expect(
      () async => db.usuarios.create(
        nombre: 'Otra',
        apellido: 'Ana',
        correo: 'ana@redime.co',
        telefono: '3009999999',
        documentoIdentidad: 'CC-2',
        password: '1234',
      ),
      throwsA(isA<DatabaseException>()),
    );
  });

  test('dispositivo año_aproximado rule rejects 1980', () async {
    final user = await db.usuarios.create(
      nombre: 'Luis',
      apellido: 'Díaz',
      correo: 'luis@redime.co',
      telefono: '3000000001',
      documentoIdentidad: 'CC-100',
      password: '1234',
    );
    expect(
      () async => db.dispositivos.create(
        idUsuario: user.idUsuario,
        marca: 'Sony',
        modelo: 'Walkman',
        anoAproximado: 1980,
        tipoDispositivo: DeviceType.smallAppliance,
        pesoEstimado: 0.5,
        funciona: false,
        piezaEntera: true,
      ),
      throwsArgumentError,
    );
  });

  test('dispositivo peso_estimado must be positive', () async {
    final user = await db.usuarios.create(
      nombre: 'Luis',
      apellido: 'Díaz',
      correo: 'luis2@redime.co',
      telefono: '3000000002',
      documentoIdentidad: 'CC-101',
      password: '1234',
    );
    expect(
      () async => db.dispositivos.create(
        idUsuario: user.idUsuario,
        marca: 'Sony',
        modelo: 'Walkman',
        anoAproximado: 2005,
        tipoDispositivo: DeviceType.smallAppliance,
        pesoEstimado: 0,
        funciona: false,
        piezaEntera: true,
      ),
      throwsArgumentError,
    );
  });

  test('only one HISTORIA per dispositivo is allowed', () async {
    final user = await db.usuarios.create(
      nombre: 'Carlos',
      apellido: 'Ruiz',
      correo: 'carlos@redime.co',
      telefono: '3000000003',
      documentoIdentidad: 'CC-200',
      password: '1234',
    );
    final dispositivo = await db.dispositivos.create(
      idUsuario: user.idUsuario,
      marca: 'Dell',
      modelo: 'Inspiron',
      anoAproximado: 2015,
      tipoDispositivo: DeviceType.smallAppliance,
      pesoEstimado: 2.3,
      funciona: true,
      piezaEntera: true,
    );

    await db.historias.create(
      idDispositivo: dispositivo.idDispositivo,
      textoHistoria: 'Historia A',
    );
    expect(
      () async => db.historias.create(
        idDispositivo: dispositivo.idDispositivo,
        textoHistoria: 'Historia duplicada',
      ),
      throwsA(isA<DatabaseException>()),
    );
  });

  test('publishing an unapproved story is rejected', () async {
    final user = await db.usuarios.create(
      nombre: 'Mía',
      apellido: 'López',
      correo: 'mia@redime.co',
      telefono: '3000000004',
      documentoIdentidad: 'CC-300',
      password: '1234',
    );
    final dispositivo = await db.dispositivos.create(
      idUsuario: user.idUsuario,
      marca: 'HP',
      modelo: 'Pavilion',
      anoAproximado: 2018,
      tipoDispositivo: DeviceType.smallAppliance,
      pesoEstimado: 2.0,
      funciona: true,
      piezaEntera: true,
    );
    expect(
      () async => db.historias.create(
        idDispositivo: dispositivo.idDispositivo,
        textoHistoria: 'Pública sin aprobación',
        estado: EstadoAprobacion.pendiente,
        publica: true,
      ),
      throwsStateError,
    );
  });

  test('solicitud homePickup requires dirección', () async {
    final user = await db.usuarios.create(
      nombre: 'Pedro',
      apellido: 'Gómez',
      correo: 'pedro@redime.co',
      telefono: '3000000005',
      documentoIdentidad: 'CC-400',
      password: '1234',
    );
    final dispositivo = await db.dispositivos.create(
      idUsuario: user.idUsuario,
      marca: 'LG',
      modelo: 'Nexus',
      anoAproximado: 2014,
      tipoDispositivo: DeviceType.telecomEquipment,
      pesoEstimado: 0.3,
      funciona: true,
      piezaEntera: true,
    );
    expect(
      () async => db.solicitudes.create(
        idUsuario: user.idUsuario,
        idDispositivo: dispositivo.idDispositivo,
        metodoEntrega: DeliveryMethod.homePickup,
      ),
      throwsArgumentError,
    );
  });

  test('solicitud dropOffPoint requires id_punto', () async {
    final user = await db.usuarios.create(
      nombre: 'Rita',
      apellido: 'Paz',
      correo: 'rita@redime.co',
      telefono: '3000000006',
      documentoIdentidad: 'CC-500',
      password: '1234',
    );
    final dispositivo = await db.dispositivos.create(
      idUsuario: user.idUsuario,
      marca: 'Samsung',
      modelo: 'S10',
      anoAproximado: 2019,
      tipoDispositivo: DeviceType.telecomEquipment,
      pesoEstimado: 0.2,
      funciona: true,
      piezaEntera: true,
    );
    expect(
      () async => db.solicitudes.create(
        idUsuario: user.idUsuario,
        idDispositivo: dispositivo.idDispositivo,
        metodoEntrega: DeliveryMethod.dropOffPoint,
      ),
      throwsArgumentError,
    );
  });

  test('happy path: register → pickup → tracking → approve story', () async {
    final user = await db.usuarios.create(
      nombre: 'Elena',
      apellido: 'Mora',
      correo: 'elena@redime.co',
      telefono: '3000000007',
      documentoIdentidad: 'CC-600',
      password: 'hola1234',
      tipoUsuario: TipoUsuario.donante,
    );
    final dispositivo = await db.dispositivos.create(
      idUsuario: user.idUsuario,
      marca: 'Apple',
      modelo: 'iPhone 6',
      anoAproximado: 2014,
      tipoDispositivo: DeviceType.telecomEquipment,
      pesoEstimado: 0.13,
      antiguedad: 'más de 10 años',
      funciona: false,
      piezaEntera: true,
      fotoUrl: null,
    );
    final solicitud = await db.solicitudes.create(
      idUsuario: user.idUsuario,
      idDispositivo: dispositivo.idDispositivo,
      metodoEntrega: DeliveryMethod.homePickup,
      direccion: 'Calle 10 # 45-20',
      fechaPreferida: DateTime(2026, 5, 15),
    );
    await db.trackings.addEvent(
      idDispositivo: dispositivo.idDispositivo,
      etapa: TrackingStage.delivery,
      procesamientoTipo: ProcessingType.commemoration,
      mensajeUsuario: 'Solicitud recibida',
    );
    final historia = await db.historias.create(
      idDispositivo: dispositivo.idDispositivo,
      textoHistoria: 'Este teléfono me acompañó por años…',
    );
    await db.preferencias.upsert(
      idUsuario: user.idUsuario,
      tipoProcesamientoPreferido: ProcessingType.commemoration,
      consentimientoPublicacion: true,
    );

    expect(solicitud.estadoSolicitud, EstadoSolicitud.pendiente);

    await db.historias.aprobar(historia.idHistoria, publicar: true);
    final publicas = await db.historias.publicas();
    expect(publicas, isNotEmpty);
    expect(publicas.first.idDispositivo, dispositivo.idDispositivo);

    final tracking = await db.trackings.findByDispositivo(
      dispositivo.idDispositivo,
    );
    expect(tracking, hasLength(1));
  });
}
