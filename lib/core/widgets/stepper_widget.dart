import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StepperWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color activeColor;

  const StepperWidget({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
    this.activeColor = AppColors.teal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Paso $currentStep',
          style: TextStyle(
            color: activeColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(totalSteps, (index) {
            bool isActive = index < currentStep;
            return Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? activeColor : Colors.transparent,
                    border: Border.all(color: activeColor, width: 1.5),
                  ),
                ),
                if (index < totalSteps - 1)
                  Container(
                    width: 24,
                    height: 1.5,
                    color: activeColor,
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
