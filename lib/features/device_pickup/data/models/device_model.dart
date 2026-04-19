import '../../domain/entities/device_entity.dart';
import '../../domain/entities/enums.dart';

class DeviceModel extends DeviceEntity {
  const DeviceModel({
    required super.deviceType,
    required super.description,
    required super.brand,
    required super.estimatedWeight,
    required super.age,
    required super.condition,
    required super.integrity,
  });

  factory DeviceModel.fromEntity(DeviceEntity entity) {
    return DeviceModel(
      deviceType: entity.deviceType,
      description: entity.description,
      brand: entity.brand,
      estimatedWeight: entity.estimatedWeight,
      age: entity.age,
      condition: entity.condition,
      integrity: entity.integrity,
    );
  }

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      deviceType: DeviceType.values.byName(json['deviceType'] as String),
      description: json['description'] as String,
      brand: json['brand'] as String,
      estimatedWeight: json['estimatedWeight'] as String,
      age: json['age'] as String,
      condition: DeviceCondition.values.byName(json['condition'] as String),
      integrity: DeviceIntegrity.values.byName(json['integrity'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceType': deviceType.name,
      'description': description,
      'brand': brand,
      'estimatedWeight': estimatedWeight,
      'age': age,
      'condition': condition.name,
      'integrity': integrity.name,
    };
  }
}
