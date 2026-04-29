import 'package:flutter/material.dart';
import '../../domain/entities/tracking_step_entity.dart';
import 'tracking_step_tile.dart';

class TrackingTimeline extends StatelessWidget {
  final List<TrackingStepEntity> steps;

  const TrackingTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        return TrackingStepTile(
          step: steps[index],
          isLast: index == steps.length - 1,
        );
      }),
    );
  }
}
