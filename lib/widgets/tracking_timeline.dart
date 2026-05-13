import 'package:flutter/material.dart';
import 'tracking_step_tile.dart';

class TrackingTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> steps;

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
