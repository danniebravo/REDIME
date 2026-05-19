import 'device_entity.dart';
import 'enums.dart';

class PickupRequestEntity {
  final String id;
  final DeviceEntity device;
  final DeliveryMethod deliveryMethod;
  final ProcessingType processingType;
  final String address;
  final DateTime pickupDate;
  final String? story;
  final String? photoPath;
  final TrackingStage status;
  final DateTime createdAt;

  const PickupRequestEntity({
    required this.id,
    required this.device,
    required this.deliveryMethod,
    required this.processingType,
    required this.address,
    required this.pickupDate,
    this.story,
    this.photoPath,
    required this.status,
    required this.createdAt,
  });

  bool get hasStory => story != null && story!.isNotEmpty;

  PickupRequestEntity copyWith({
    String? id,
    DeviceEntity? device,
    DeliveryMethod? deliveryMethod,
    ProcessingType? processingType,
    String? address,
    DateTime? pickupDate,
    String? story,
    String? photoPath,
    TrackingStage? status,
    DateTime? createdAt,
  }) {
    return PickupRequestEntity(
      id: id ?? this.id,
      device: device ?? this.device,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      processingType: processingType ?? this.processingType,
      address: address ?? this.address,
      pickupDate: pickupDate ?? this.pickupDate,
      story: story ?? this.story,
      photoPath: photoPath ?? this.photoPath,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
