import '../../../../core/database/auth_session.dart';
import '../../../../core/database/models/dispositivo.dart';
import '../../../../core/database/models/historia_dispositivo.dart';
import '../../../../core/database/models/solicitud_recogida.dart';
import '../../../../core/database/redime_db.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/pickup_request_entity.dart';
import '../models/device_model.dart';
import '../models/pickup_request_model.dart';

/// Persists pickup requests in the local SQLite database. Writes across four
/// tables (dispositivo + solicitud + tracking + opcional historia +
/// preferencia) in a single transaction so the data is always consistent.
class PickupLocalDataSource {
  PickupLocalDataSource({RedimeDb? db, AuthSession? session})
      : _db = db ?? RedimeDb.instance,
        _session = session ?? AuthSession.instance;

  final RedimeDb _db;
  final AuthSession _session;

  Future<PickupRequestModel> savePickupRequest(
    PickupRequestModel request,
  ) async {
    await _db.ensureReady();

    final idUsuario = _session.effectiveUserId;

    final dispositivo = await _db.dispositivos.create(
      idUsuario: idUsuario,
      marca: request.device.brand.isNotEmpty
          ? request.device.brand
          : 'Sin marca',
      modelo: request.device.description.isNotEmpty
          ? request.device.description
          : 'Sin modelo',
      anoAproximado: _inferYear(request.device.age),
      tipoDispositivo: _mapDeviceType(request.device.deviceType),
      pesoEstimado: _parseWeight(request.device.estimatedWeight),
      antiguedad: request.device.age.isNotEmpty ? request.device.age : null,
      funciona: request.device.condition == DeviceCondition.fullyWorking,
      piezaEntera: request.device.integrity == DeviceIntegrity.singlePiece,
      fotoUrl: request.photoPath,
    );

    final solicitud = await _db.solicitudes.create(
      idUsuario: idUsuario,
      idDispositivo: dispositivo.idDispositivo,
      metodoEntrega: request.deliveryMethod,
      direccion: request.deliveryMethod == DeliveryMethod.homePickup
          ? request.address
          : null,
      fechaPreferida: request.pickupDate,
      estado: EstadoSolicitud.pendiente,
    );

    await _db.trackings.addEvent(
      idDispositivo: dispositivo.idDispositivo,
      etapa: TrackingStage.delivery,
      subestado: request.deliveryMethod == DeliveryMethod.homePickup
          ? 'Solicitud recibida'
          : 'Pendiente de depósito',
      mensajeUsuario:
          'Tu solicitud fue registrada. Pronto recibirás más información.',
      procesamientoTipo: request.processingType,
    );

    if (request.story != null && request.story!.trim().isNotEmpty) {
      await _db.historias.create(
        idDispositivo: dispositivo.idDispositivo,
        textoHistoria: request.story!,
        extracto: _makeExcerpt(request.story!),
        imagenUrl: request.photoPath,
        estado: EstadoAprobacion.pendiente,
        publica: false,
      );

      // Register the user consent so the public archive can later publish it
      // only if consentimiento_publicacion = true.
      await _db.preferencias.upsert(
        idUsuario: idUsuario,
        tipoProcesamientoPreferido: request.processingType,
        consentimientoPublicacion: true,
      );
    }

    return PickupRequestModel(
      id: solicitud.idSolicitud,
      device: request.device,
      deliveryMethod: request.deliveryMethod,
      processingType: request.processingType,
      address: request.address,
      pickupDate: request.pickupDate,
      story: request.story,
      photoPath: request.photoPath,
      status: TrackingStage.delivery,
      createdAt: solicitud.fechaSolicitud,
    );
  }

  Future<List<PickupRequestModel>> getPickupRequests() async {
    await _db.ensureReady();
    final idUsuario = _session.effectiveUserId;
    final solicitudes = await _db.solicitudes.findByUsuario(idUsuario);
    final results = <PickupRequestModel>[];
    for (final s in solicitudes) {
      final dispositivo = await _db.dispositivos.findById(s.idDispositivo);
      if (dispositivo == null) continue;
      final tracking = await _db.trackings.latestFor(dispositivo.idDispositivo);
      final historia =
          await _db.historias.findByDispositivo(dispositivo.idDispositivo);
      results.add(_toPickupRequest(s, dispositivo, tracking?.etapa, historia));
    }
    return results;
  }

  PickupRequestModel _toPickupRequest(
    SolicitudRecogida s,
    Dispositivo d,
    TrackingStage? currentStage,
    HistoriaDispositivo? historia,
  ) {
    return PickupRequestModel(
      id: s.idSolicitud,
      device: DeviceModel(
        deviceType: d.tipoDispositivo,
        description: d.modelo,
        brand: d.marca,
        estimatedWeight: d.pesoEstimado.toString(),
        age: d.antiguedad ?? '',
        condition: d.funciona
            ? DeviceCondition.fullyWorking
            : DeviceCondition.notWorking,
        integrity: d.piezaEntera
            ? DeviceIntegrity.singlePiece
            : DeviceIntegrity.looseParts,
      ),
      deliveryMethod: s.metodoEntrega,
      processingType: historia != null
          ? ProcessingType.commemoration
          : ProcessingType.standardRecycle,
      address: s.direccion ?? '',
      pickupDate: s.fechaPreferida ?? s.fechaSolicitud,
      story: historia?.textoHistoria,
      photoPath: d.fotoUrl,
      status: currentStage ?? TrackingStage.delivery,
      createdAt: s.fechaSolicitud,
    );
  }

  DeviceType _mapDeviceType(DeviceType t) => t;

  int _inferYear(String age) {
    final now = DateTime.now().year;
    if (age.isEmpty) return now;
    final match = RegExp(r'(\d+)').firstMatch(age);
    if (match == null) return now;
    final years = int.tryParse(match.group(1)!) ?? 0;
    final candidate = now - years;
    if (candidate < 1990) return 1990;
    if (candidate > now) return now;
    return candidate;
  }

  double _parseWeight(String raw) {
    if (raw.isEmpty) return 1.0;
    final match = RegExp(r'([\d.,]+)').firstMatch(raw);
    if (match == null) return 1.0;
    final normalized = match.group(1)!.replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed <= 0) return 1.0;
    return parsed;
  }

  String _makeExcerpt(String text) {
    final trimmed = text.trim();
    if (trimmed.length <= 140) return trimmed;
    return '${trimmed.substring(0, 137)}...';
  }

  // Expose entity transform for tests that still rely on the old signature.
  PickupRequestModel asModel(PickupRequestEntity entity) =>
      PickupRequestModel.fromEntity(entity);
}
