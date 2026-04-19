import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryTeal,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 20, top: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Paso $currentStep',
            style: AppTextStyles.stepLabel,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps, (index) {
              final isActive = index < currentStep;
              final isCurrent = index == currentStep - 1;
              return Row(
                children: [
                  Container(
                    width: isCurrent ? 12 : 10,
                    height: isCurrent ? 12 : 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? AppColors.white
                          : AppColors.white.withValues(alpha: 0.35),
                      border: isCurrent
                          ? Border.all(color: AppColors.white, width: 2)
                          : null,
                    ),
                  ),
                  if (index < totalSteps - 1)
                    Container(
                      width: 24,
                      height: 2,
                      color: isActive
                          ? AppColors.white.withValues(alpha: 0.7)
                          : AppColors.white.withValues(alpha: 0.25),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
