import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';

class PhotoUploadArea extends StatelessWidget {
  final String? photoPath;
  final VoidCallback onTap;

  const PhotoUploadArea({
    super.key,
    this.photoPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
        child: photoPath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(
                  File(photoPath!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
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
