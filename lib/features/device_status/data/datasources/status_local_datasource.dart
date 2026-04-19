import '../../../../core/database/auth_session.dart';
import '../../../../core/database/models/dispositivo.dart';
import '../../../../core/database/models/solicitud_recogida.dart';
import '../../../../core/database/models/tracking_estado.dart';
import '../../../../core/database/redime_db.dart';
import '../../../device_pickup/domain/entities/enums.dart';
import '../../domain/entities/device_status_entity.dart';
import '../models/device_status_model.dart';
import '../models/tracking_step_model.dart';

/// Reads the current status for one or all devices from the local database.
/// Uses the tracking events registered when a pickup is submitted.
class StatusLocalDataSource {
  StatusLocalDataSource({RedimeDb? db, AuthSession? session})
      : _db = db ?? RedimeDb.instance,
        _session = session ?? AuthSession.instance;

  final RedimeDb _db;
  final AuthSession _session;

  Future<DeviceStatusEntity> getDeviceStatus(String pickupRequestId) async {
    await _db.ensureReady();
    final solicitud = await _db.solicitudes.findById(pickupRequestId);
    if (solicitud == null) {
      return _fallback(pickupRequestId);
    }
    final dispositivo =
        await _db.dispositivos.findById(solicitud.idDispositivo);
    if (dispositivo == null) {
      return _fallback(pickupRequestId);
    }
    final events = await _db.trackings.findByDispositivo(dispositivo.idDispositivo);
    return _build(solicitud, dispositivo, events);
  }

  Future<List<DeviceStatusEntity>> getAllDeviceStatuses() async {
    await _db.ensureReady();
    final idUsuario = _session.effectiveUserId;
    final solicitudes = await _db.solicitudes.findByUsuario(idUsuario);
    if (solicitudes.isEmpty) return [];
    final results = <DeviceStatusEntity>[];
    for (final s in solicitudes) {
      final dispositivo = await _db.dispositivos.findById(s.idDispositivo);
      if (dispositivo == null) continue;
      final events =
          await _db.trackings.findByDispositivo(dispositivo.idDispositivo);
      results.add(_build(s, dispositivo, events));
    }
    return results;
  }

  DeviceStatusModel _build(
    SolicitudRecogida s,
    Dispositivo d,
    List<TrackingEstado> events,
  ) {
    final processing = events.isNotEmpty
        ? events.first.procesamientoTipo
        : ProcessingType.standardRecycle;
    final stageReached = <TrackingStage, TrackingEstado>{};
    for (final e in events) {
      // Keep the latest event per stage.
      stageReached[e.etapa] = e;
    }

    TrackingStage currentStage = TrackingStage.delivery;
    if (stageReached.containsKey(TrackingStage.completed)) {
      currentStage = TrackingStage.completed;
    } else if (stageReached.containsKey(TrackingStage.processing)) {
      currentStage = TrackingStage.processing;
    }

    final steps = <TrackingStepModel>[
      _step(
        TrackingStage.delivery,
        s.metodoEntrega == DeliveryMethod.homePickup
            ? 'Yendo a recogerlo'
            : 'Depositado',
        s.metodoEntrega == DeliveryMethod.homePickup
            ? 'Nuestro equipo está en camino'
            : 'Recibido en punto de entrega',
        stageReached[TrackingStage.delivery],
        currentStage,
      ),
      _step(
        TrackingStage.processing,
        processing == ProcessingType.commemoration
            ? 'Extrayendo memorias'
            : 'A punto de darle una nueva vida',
        processing == ProcessingType.commemoration
            ? 'Estamos preservando la historia de tu dispositivo'
            : 'Procesando materiales para reciclaje',
        stageReached[TrackingStage.processing],
        currentStage,
      ),
      _step(
        TrackingStage.completed,
        processing == ProcessingType.commemoration
            ? 'Ahora es una memoria viviente'
            : 'Ahora es parte de algo mejor',
        processing == ProcessingType.commemoration
            ? 'Tu dispositivo vive en el museo de memorias'
            : 'Los materiales fueron reciclados exitosamente',
        stageReached[TrackingStage.completed],
        currentStage,
      ),
    ];

    return DeviceStatusModel(
      pickupRequestId: s.idSolicitud,
      deviceDescription: '${d.marca} ${d.modelo}'.trim(),
      currentStage: currentStage,
      deliveryMethod: s.metodoEntrega,
      processingType: processing,
      steps: steps,
      createdAt: s.fechaSolicitud,
    );
  }

  TrackingStepModel _step(
    TrackingStage stage,
    String title,
    String subtitle,
    TrackingEstado? event,
    TrackingStage currentStage,
  ) {
    final completed = event != null &&
        stage.order <= currentStage.order &&
        currentStage != stage;
    final isCurrent = stage == currentStage && !completed;
    return TrackingStepModel(
      stage: stage,
      title: title,
      subtitle: subtitle,
      isCompleted: completed,
      isCurrent: isCurrent,
      completedAt: completed ? event.fechaActualizacion : null,
    );
  }

  DeviceStatusModel _fallback(String id) {
    return DeviceStatusModel(
      pickupRequestId: id,
      deviceDescription: 'Sin datos',
      currentStage: TrackingStage.delivery,
      deliveryMethod: DeliveryMethod.homePickup,
      processingType: ProcessingType.standardRecycle,
      steps: const [
        TrackingStepModel(
          stage: TrackingStage.delivery,
          title: 'Pendiente',
          subtitle: 'La solicitud no tiene información de seguimiento',
          isCompleted: false,
          isCurrent: true,
        ),
        TrackingStepModel(
          stage: TrackingStage.processing,
          title: 'En procesamiento',
          subtitle: '—',
          isCompleted: false,
        ),
        TrackingStepModel(
          stage: TrackingStage.completed,
          title: 'Finalizado',
          subtitle: '—',
          isCompleted: false,
        ),
      ],
      createdAt: DateTime.now(),
    );
  }
}
