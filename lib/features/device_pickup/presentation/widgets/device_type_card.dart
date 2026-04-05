import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/enums.dart';

class DeviceTypeCard extends StatelessWidget {
  final DeviceType type;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  /// Card background colors matching the Figma 2x2 grid:
  /// Top-left (large): light mint
  /// Top-right (small): medium teal
  /// Bottom-left (telecom): dark teal
  /// Bottom-right (other): dark teal
  final Color backgroundColor;

  const DeviceTypeCard({
    super.key,
    required this.type,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkBg =
        backgroundColor == AppColors.cardDarkTeal ||
        backgroundColor == AppColors.cardMediumTeal;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cardSelected : backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColors.primaryTeal, width: 2)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryTeal.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 48,
                    color: isSelected
                        ? AppColors.primaryTeal
                        : (isDarkBg ? AppColors.white : AppColors.darkText),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    type.displayName,
                    textAlign: TextAlign.center,
                    style: isSelected
                        ? AppTextStyles.cardLabelDark
                        : (isDarkBg
                            ? AppTextStyles.cardLabel
                            : AppTextStyles.cardLabelDark),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.darkText,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
