// SQL schema for the REDIME local database.
//
// Based on the functional database design document (Juan Buitrago).
// SQLite dialect. Column sizes documented in comments reflect the physical
// model (VARCHAR/INT/DECIMAL widths) but SQLite itself stores types
// dynamically. All integrity rules (PK, FK, UNIQUE, NOT NULL, CHECK) are
// enforced at the engine level.

class DbSchema {
  DbSchema._();

  static const int version = 1;
  static const String fileName = 'redime.db';

  // ── USUARIO ──────────────────────────────────────────────────────────
  static const String tableUsuario = 'usuario';
  static const String createUsuario = '''
    CREATE TABLE $tableUsuario (
      id_usuario          TEXT    NOT NULL PRIMARY KEY,
      nombre              TEXT    NOT NULL,
      apellido            TEXT    NOT NULL,
      correo              TEXT    NOT NULL UNIQUE,
      telefono            TEXT    NOT NULL,
      direccion           TEXT,
      documento_identidad TEXT    NOT NULL UNIQUE,
      tipo_usuario        TEXT    NOT NULL
        CHECK (tipo_usuario IN ('donante','visitante','administrador')),
      fecha_registro      TEXT    NOT NULL,
      password_hash       TEXT    NOT NULL,
      CHECK (length(trim(nombre))   > 0),
      CHECK (length(trim(apellido)) > 0),
      CHECK (length(correo) >= 5 AND correo LIKE '%@%')
    )
  ''';

  // ── DISPOSITIVO ──────────────────────────────────────────────────────
  static const String tableDispositivo = 'dispositivo';
  static const String createDispositivo = '''
    CREATE TABLE $tableDispositivo (
      id_dispositivo   TEXT    NOT NULL PRIMARY KEY,
      id_usuario       TEXT    NOT NULL,
      marca            TEXT    NOT NULL,
      modelo           TEXT    NOT NULL,
      ano_aproximado   INTEGER NOT NULL,
      tipo_dispositivo TEXT    NOT NULL
        CHECK (tipo_dispositivo IN (
          'largeAppliance','smallAppliance','telecomEquipment','other'
        )),
      peso_estimado    REAL    NOT NULL CHECK (peso_estimado > 0),
      antiguedad       TEXT,
      funciona         INTEGER NOT NULL CHECK (funciona IN (0,1)),
      pieza_entera     INTEGER NOT NULL CHECK (pieza_entera IN (0,1)),
      foto_url         TEXT,
      fecha_registro   TEXT    NOT NULL,
      -- SQLite forbids non-deterministic functions (strftime('%Y','now'))
      -- inside a CHECK constraint, so the lower bound is enforced here and
      -- the "current year" upper bound is validated in DispositivoRepository.
      CHECK (ano_aproximado BETWEEN 1990 AND 2100),
      FOREIGN KEY (id_usuario) REFERENCES $tableUsuario(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
    )
  ''';
  static const String indexDispositivoUsuario =
      'CREATE INDEX idx_dispositivo_usuario ON $tableDispositivo(id_usuario)';

  // ── SOLICITUD_RECOGIDA ───────────────────────────────────────────────
  static const String tableSolicitud = 'solicitud_recogida';
  static const String createSolicitud = '''
    CREATE TABLE $tableSolicitud (
      id_solicitud     TEXT    NOT NULL PRIMARY KEY,
      id_usuario       TEXT    NOT NULL,
      id_dispositivo   TEXT    NOT NULL,
      id_punto         TEXT,
      fecha_solicitud  TEXT    NOT NULL,
      metodo_entrega   TEXT    NOT NULL
        CHECK (metodo_entrega IN ('homePickup','dropOffPoint')),
      direccion        TEXT,
      fecha_preferida  TEXT,
      estado_solicitud TEXT    NOT NULL
        CHECK (estado_solicitud IN (
          'pendiente','en_proceso','completada','cancelada'
        )),
      CHECK (
        (metodo_entrega = 'homePickup'   AND direccion IS NOT NULL) OR
        (metodo_entrega = 'dropOffPoint' AND id_punto  IS NOT NULL)
      ),
      FOREIGN KEY (id_usuario)     REFERENCES $tableUsuario(id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
      FOREIGN KEY (id_dispositivo) REFERENCES $tableDispositivo(id_dispositivo)
        ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (id_punto)       REFERENCES punto_recoleccion(id_punto)
        ON DELETE SET NULL ON UPDATE CASCADE
    )
  ''';
  static const String indexSolicitudUsuario =
      'CREATE INDEX idx_solicitud_usuario ON $tableSolicitud(id_usuario)';
  static const String indexSolicitudDispositivo =
      'CREATE INDEX idx_solicitud_dispositivo ON $tableSolicitud(id_dispositivo)';

  // ── HISTORIA_DISPOSITIVO ─────────────────────────────────────────────
  // 1:1 with DISPOSITIVO enforced by UNIQUE(id_dispositivo).
  static const String tableHistoria = 'historia_dispositivo';
  static const String createHistoria = '''
    CREATE TABLE $tableHistoria (
      id_historia       TEXT    NOT NULL PRIMARY KEY,
      id_dispositivo    TEXT    NOT NULL UNIQUE,
      texto_historia    TEXT    NOT NULL,
      fecha_generacion  TEXT    NOT NULL,
      estado_aprobacion TEXT    NOT NULL
        CHECK (estado_aprobacion IN ('pendiente','aprobada','rechazada')),
      extracto          TEXT,
      imagen_url        TEXT,
      publica           INTEGER NOT NULL CHECK (publica IN (0,1)),
      CHECK (publica = 0 OR estado_aprobacion = 'aprobada'),
      FOREIGN KEY (id_dispositivo) REFERENCES $tableDispositivo(id_dispositivo)
        ON DELETE CASCADE ON UPDATE CASCADE
    )
  ''';

  // ── TRACKING_ESTADO ──────────────────────────────────────────────────
  static const String tableTracking = 'tracking_estado';
  static const String createTracking = '''
    CREATE TABLE $tableTracking (
      id_tracking         TEXT    NOT NULL PRIMARY KEY,
      id_dispositivo      TEXT    NOT NULL,
      etapa               TEXT    NOT NULL
        CHECK (etapa IN ('delivery','processing','completed')),
      subestado           TEXT,
      fecha_actualizacion TEXT    NOT NULL,
      mensaje_usuario     TEXT,
      procesamiento_tipo  TEXT    NOT NULL
        CHECK (procesamiento_tipo IN ('standardRecycle','commemoration')),
      FOREIGN KEY (id_dispositivo) REFERENCES $tableDispositivo(id_dispositivo)
        ON DELETE CASCADE ON UPDATE CASCADE
    )
  ''';
  static const String indexTrackingDispositivo =
      'CREATE INDEX idx_tracking_dispositivo ON $tableTracking(id_dispositivo)';

  // ── PUNTO_RECOLECCION ────────────────────────────────────────────────
  static const String tablePunto = 'punto_recoleccion';
  static const String createPunto = '''
    CREATE TABLE $tablePunto (
      id_punto        TEXT    NOT NULL PRIMARY KEY,
      nombre          TEXT    NOT NULL,
      direccion       TEXT    NOT NULL,
      lat             REAL    NOT NULL CHECK (lat  BETWEEN -90  AND 90),
      lng             REAL    NOT NULL CHECK (lng  BETWEEN -180 AND 180),
      horario         TEXT    NOT NULL,
      tipos_aceptados TEXT    NOT NULL,
      activo          INTEGER NOT NULL CHECK (activo IN (0,1))
    )
  ''';

  // ── PREFERENCIA_USUARIO ──────────────────────────────────────────────
  static const String tablePreferencia = 'preferencia_usuario';
  static const String createPreferencia = '''
    CREATE TABLE $tablePreferencia (
      id_preferencia                TEXT    NOT NULL PRIMARY KEY,
      id_usuario                    TEXT    NOT NULL,
      tipo_procesamiento_preferido  TEXT
        CHECK (tipo_procesamiento_preferido IN ('standardRecycle','commemoration')),
      consentimiento_publicacion    INTEGER NOT NULL CHECK (consentimiento_publicacion IN (0,1)),
      FOREIGN KEY (id_usuario) REFERENCES $tableUsuario(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
    )
  ''';
  static const String indexPreferenciaUsuario =
      'CREATE INDEX idx_preferencia_usuario ON $tablePreferencia(id_usuario)';

  /// DDL statements in dependency order (parents first).
  static const List<String> createStatements = [
    createUsuario,
    createPunto,
    createDispositivo,
    createSolicitud,
    createHistoria,
    createTracking,
    createPreferencia,
    indexDispositivoUsuario,
    indexSolicitudUsuario,
    indexSolicitudDispositivo,
    indexTrackingDispositivo,
    indexPreferenciaUsuario,
  ];

  static const List<String> dropStatements = [
    'DROP TABLE IF EXISTS $tablePreferencia',
    'DROP TABLE IF EXISTS $tableTracking',
    'DROP TABLE IF EXISTS $tableHistoria',
    'DROP TABLE IF EXISTS $tableSolicitud',
    'DROP TABLE IF EXISTS $tableDispositivo',
    'DROP TABLE IF EXISTS $tablePunto',
    'DROP TABLE IF EXISTS $tableUsuario',
  ];
}
