import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/tracking_step_entity.dart';
import 'package:intl/intl.dart';

class TrackingStepTile extends StatelessWidget {
  final TrackingStepEntity step;
  final bool isLast;

  const TrackingStepTile({
    super.key,
    required this.step,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column (circle + line)
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Circle indicator
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: step.isCompleted
                        ? AppColors.primaryTeal
                        : step.isCurrent
                            ? AppColors.white
                            : AppColors.borderGrey,
                    border: Border.all(
                      color: step.isCompleted || step.isCurrent
                          ? AppColors.primaryTeal
                          : AppColors.disabledGrey,
                      width: step.isCurrent ? 3 : 2,
                    ),
                  ),
                  child: step.isCompleted
                      ? const Icon(Icons.check, size: 16, color: AppColors.white)
                      : step.isCurrent
                          ? Center(
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                            )
                          : null,
                ),
                // Vertical line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 3,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: step.isCompleted
                          ? AppColors.primaryTeal
                          : AppColors.borderGrey,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: AppTextStyles.trackingTitle.copyWith(
                      color: step.isCompleted || step.isCurrent
                          ? AppColors.darkText
                          : AppColors.disabledGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.subtitle,
                    style: AppTextStyles.trackingSubtitle,
                  ),
                  if (step.completedAt != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Completado: ${DateFormat('dd/MM/yyyy').format(step.completedAt!)}',
                      style: AppTextStyles.trackingSubtitle.copyWith(
                        fontSize: 11,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                  ],
                  if (step.isCurrent) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.mintBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'En proceso',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
