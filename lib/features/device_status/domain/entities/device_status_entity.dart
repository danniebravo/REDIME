import '../../../device_pickup/domain/entities/enums.dart';
import 'tracking_step_entity.dart';

class DeviceStatusEntity {
  final String pickupRequestId;
  final String deviceDescription;
  final TrackingStage currentStage;
  final DeliveryMethod deliveryMethod;
  final ProcessingType processingType;
  final List<TrackingStepEntity> steps;
  final DateTime createdAt;

  const DeviceStatusEntity({
    required this.pickupRequestId,
    required this.deviceDescription,
    required this.currentStage,
    required this.deliveryMethod,
    required this.processingType,
    required this.steps,
    required this.createdAt,
  });
}
