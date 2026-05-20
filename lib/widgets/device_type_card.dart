import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class DeviceTypeCard extends StatelessWidget {
  final String title;
  final String selectedAssetPath;
  final String unselectedAssetPath;
  final bool isSelected;
  final VoidCallback onTap;
  final Color backgroundColor;

  const DeviceTypeCard({
    super.key,
    required this.title,
    required this.selectedAssetPath,
    required this.unselectedAssetPath,
    required this.isSelected,
    required this.onTap,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor = isSelected
        ? AppColors.cardDarkTeal
        : backgroundColor;

    final String assetPath = isSelected
        ? selectedAssetPath
        : unselectedAssetPath;

    final TextStyle labelStyle = AppTextStyles.cardLabelDark.copyWith(
      color: isSelected ? AppColors.white : AppColors.darkText,
      fontWeight: FontWeight.w700,
      height: 1.12,
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppColors.primaryTeal, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.18 : 0.10),
              blurRadius: isSelected ? 8 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final double imageHeight = constraints.maxHeight * 0.43;
                final double imageWidth = constraints.maxWidth * 0.62;

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: imageHeight,
                          width: imageWidth,
                          child: Image.asset(
                            assetPath,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.devices_other,
                                size: 44,
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.primaryTeal,
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        Flexible(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: labelStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            if (isSelected)
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 20,
                    color: AppColors.darkText,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
