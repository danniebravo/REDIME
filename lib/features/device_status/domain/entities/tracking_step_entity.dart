import '../../../device_pickup/domain/entities/enums.dart';

class TrackingStepEntity {
  final TrackingStage stage;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isCurrent;
  final DateTime? completedAt;

  const TrackingStepEntity({
    required this.stage,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.isCurrent = false,
    this.completedAt,
  });

  TrackingStepEntity copyWith({
    TrackingStage? stage,
    String? title,
    String? subtitle,
    bool? isCompleted,
    bool? isCurrent,
    DateTime? completedAt,
  }) {
    return TrackingStepEntity(
      stage: stage ?? this.stage,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isCompleted: isCompleted ?? this.isCompleted,
      isCurrent: isCurrent ?? this.isCurrent,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
