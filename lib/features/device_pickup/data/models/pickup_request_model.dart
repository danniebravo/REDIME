import '../../domain/entities/enums.dart';
import '../../domain/entities/pickup_request_entity.dart';
import 'device_model.dart';

class PickupRequestModel extends PickupRequestEntity {
  const PickupRequestModel({
    required super.id,
    required super.device,
    required super.deliveryMethod,
    required super.processingType,
    required super.address,
    required super.pickupDate,
    super.story,
    super.photoPath,
    required super.status,
    required super.createdAt,
  });

  factory PickupRequestModel.fromEntity(PickupRequestEntity entity) {
    return PickupRequestModel(
      id: entity.id,
      device: entity.device,
      deliveryMethod: entity.deliveryMethod,
      processingType: entity.processingType,
      address: entity.address,
      pickupDate: entity.pickupDate,
      story: entity.story,
      photoPath: entity.photoPath,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }

  factory PickupRequestModel.fromJson(Map<String, dynamic> json) {
    return PickupRequestModel(
      id: json['id'] as String,
      device: DeviceModel.fromJson(json['device'] as Map<String, dynamic>),
      deliveryMethod:
          DeliveryMethod.values.byName(json['deliveryMethod'] as String),
      processingType:
          ProcessingType.values.byName(json['processingType'] as String),
      address: json['address'] as String,
      pickupDate: DateTime.parse(json['pickupDate'] as String),
      story: json['story'] as String?,
      photoPath: json['photoPath'] as String?,
      status: TrackingStage.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device': DeviceModel.fromEntity(device).toJson(),
      'deliveryMethod': deliveryMethod.name,
      'processingType': processingType.name,
      'address': address,
      'pickupDate': pickupDate.toIso8601String(),
      'story': story,
      'photoPath': photoPath,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
