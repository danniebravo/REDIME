import '../../../device_pickup/domain/entities/enums.dart';
import '../../domain/entities/tracking_step_entity.dart';

class TrackingStepModel extends TrackingStepEntity {
  const TrackingStepModel({
    required super.stage,
    required super.title,
    required super.subtitle,
    required super.isCompleted,
    super.isCurrent,
    super.completedAt,
  });

  factory TrackingStepModel.fromEntity(TrackingStepEntity entity) {
    return TrackingStepModel(
      stage: entity.stage,
      title: entity.title,
      subtitle: entity.subtitle,
      isCompleted: entity.isCompleted,
      isCurrent: entity.isCurrent,
      completedAt: entity.completedAt,
    );
  }

  factory TrackingStepModel.fromJson(Map<String, dynamic> json) {
    return TrackingStepModel(
      stage: TrackingStage.values.byName(json['stage'] as String),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      isCompleted: json['isCompleted'] as bool,
      isCurrent: json['isCurrent'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stage': stage.name,
      'title': title,
      'subtitle': subtitle,
      'isCompleted': isCompleted,
      'isCurrent': isCurrent,
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}
