import 'enums.dart';

class DeviceEntity {
  final DeviceType deviceType;
  final String description;
  final String brand;
  final String estimatedWeight;
  final String age;
  final DeviceCondition condition;
  final DeviceIntegrity integrity;

  const DeviceEntity({
    required this.deviceType,
    required this.description,
    required this.brand,
    required this.estimatedWeight,
    required this.age,
    required this.condition,
    required this.integrity,
  });

  DeviceEntity copyWith({
    DeviceType? deviceType,
    String? description,
    String? brand,
    String? estimatedWeight,
    String? age,
    DeviceCondition? condition,
    DeviceIntegrity? integrity,
  }) {
    return DeviceEntity(
      deviceType: deviceType ?? this.deviceType,
      description: description ?? this.description,
      brand: brand ?? this.brand,
      estimatedWeight: estimatedWeight ?? this.estimatedWeight,
      age: age ?? this.age,
      condition: condition ?? this.condition,
      integrity: integrity ?? this.integrity,
    );
  }
}
