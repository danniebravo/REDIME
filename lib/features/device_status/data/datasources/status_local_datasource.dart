import '../../../device_pickup/domain/entities/enums.dart';
import '../../domain/entities/device_status_entity.dart';
import '../models/device_status_model.dart';
import '../models/tracking_step_model.dart';

/// Local/mock data source for device status.
/// Returns hardcoded demo data for development.
class StatusLocalDataSource {
  Future<DeviceStatusEntity> getDeviceStatus(String pickupRequestId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock status showing step 1 completed, step 2 in progress
    return DeviceStatusModel(
      pickupRequestId: pickupRequestId,
      deviceDescription: 'Laptop DELL Inspiron',
      currentStage: TrackingStage.processing,
      deliveryMethod: DeliveryMethod.homePickup,
      processingType: ProcessingType.commemoration,
      steps: [
        TrackingStepModel(
          stage: TrackingStage.delivery,
          title: 'Yendo a recogerlo',
          subtitle: 'Nuestro equipo est\u00e1 en camino',
          isCompleted: true,
          completedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        const TrackingStepModel(
          stage: TrackingStage.processing,
          title: 'Extrayendo memorias',
          subtitle: 'Estamos preservando la historia de tu dispositivo',
          isCompleted: false,
          isCurrent: true,
        ),
        const TrackingStepModel(
          stage: TrackingStage.completed,
          title: 'Ahora es una memoria viviente',
          subtitle: 'Tu dispositivo vive en el museo de memorias',
          isCompleted: false,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    );
  }

  Future<List<DeviceStatusEntity>> getAllDeviceStatuses() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final status1 = await getDeviceStatus('mock-001');

    // Second mock: standard recycle at drop-off, completed
    final status2 = DeviceStatusModel(
      pickupRequestId: 'mock-002',
      deviceDescription: 'Microondas Samsung',
      currentStage: TrackingStage.completed,
      deliveryMethod: DeliveryMethod.dropOffPoint,
      processingType: ProcessingType.standardRecycle,
      steps: [
        TrackingStepModel(
          stage: TrackingStage.delivery,
          title: 'Depositado',
          subtitle: 'Recibido en punto de entrega',
          isCompleted: true,
          completedAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        TrackingStepModel(
          stage: TrackingStage.processing,
          title: 'A punto de darle una nueva vida',
          subtitle: 'Procesando materiales para reciclaje',
          isCompleted: true,
          completedAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        TrackingStepModel(
          stage: TrackingStage.completed,
          title: 'Ahora es parte de algo mejor',
          subtitle: 'Los materiales fueron reciclados exitosamente',
          isCompleted: true,
          completedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    );

    return [status1, status2];
  }
}
