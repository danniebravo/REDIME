import 'database_helper.dart';
import 'repositories/dispositivo_repository.dart';
import 'repositories/historia_repository.dart';
import 'repositories/preferencia_repository.dart';
import 'repositories/punto_repository.dart';
import 'repositories/solicitud_repository.dart';
import 'repositories/tracking_repository.dart';
import 'repositories/usuario_repository.dart';

/// Facade that groups every repository of the REDIME database. Built so the
/// rest of the codebase only depends on one import to reach persistence.
class RedimeDb {
  RedimeDb({DatabaseHelper? db})
      : _helper = db ?? DatabaseHelper.instance,
        usuarios = UsuarioRepository(db: db),
        dispositivos = DispositivoRepository(db: db),
        solicitudes = SolicitudRepository(db: db),
        historias = HistoriaRepository(db: db),
        trackings = TrackingRepository(db: db),
        puntos = PuntoRepository(db: db),
        preferencias = PreferenciaRepository(db: db);

  final DatabaseHelper _helper;

  final UsuarioRepository usuarios;
  final DispositivoRepository dispositivos;
  final SolicitudRepository solicitudes;
  final HistoriaRepository historias;
  final TrackingRepository trackings;
  final PuntoRepository puntos;
  final PreferenciaRepository preferencias;

  /// Single shared instance — the rest of the app should read from here.
  static final RedimeDb instance = RedimeDb();

  Future<void> ensureReady() async {
    await _helper.database;
  }

  Future<void> close() => _helper.close();
}
