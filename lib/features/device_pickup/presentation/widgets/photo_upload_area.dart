import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';

class PhotoUploadArea extends StatelessWidget {
  final String? photoPath;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const PhotoUploadArea({
    super.key,
    this.photoPath,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderGrey,
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: hasPhoto
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.file(
                      File(photoPath!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  if (onRemove != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Toca para cambiar',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 40,
                    color: AppColors.greySubtitle.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.uploadPhotoTitle,
                    style: AppTextStyles.sectionLabel,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.uploadPhotoSubtitle,
                    style: AppTextStyles.screenSubtitle.copyWith(fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
