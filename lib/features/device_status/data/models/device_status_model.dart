import '../../../device_pickup/domain/entities/enums.dart';
import '../../domain/entities/device_status_entity.dart';
import 'tracking_step_model.dart';

class DeviceStatusModel extends DeviceStatusEntity {
  const DeviceStatusModel({
    required super.pickupRequestId,
    required super.deviceDescription,
    required super.currentStage,
    required super.deliveryMethod,
    required super.processingType,
    required super.steps,
    required super.createdAt,
  });

  factory DeviceStatusModel.fromJson(Map<String, dynamic> json) {
    return DeviceStatusModel(
      pickupRequestId: json['pickupRequestId'] as String,
      deviceDescription: json['deviceDescription'] as String,
      currentStage:
          TrackingStage.values.byName(json['currentStage'] as String),
      deliveryMethod:
          DeliveryMethod.values.byName(json['deliveryMethod'] as String),
      processingType:
          ProcessingType.values.byName(json['processingType'] as String),
      steps: (json['steps'] as List)
          .map((s) => TrackingStepModel.fromJson(s as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickupRequestId': pickupRequestId,
      'deviceDescription': deviceDescription,
      'currentStage': currentStage.name,
      'deliveryMethod': deliveryMethod.name,
      'processingType': processingType.name,
      'steps': steps
          .map((s) => TrackingStepModel.fromEntity(s).toJson())
          .toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
