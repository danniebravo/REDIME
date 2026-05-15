import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';

class RedimeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showHelpIcon;
  final String? title;
  final VoidCallback? onBack;

  const RedimeAppBar({
    super.key,
    this.showBackButton = true,
    this.showHelpIcon = true,
    this.title,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryTeal,
      elevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            )
          : null,
      automaticallyImplyLeading: false,
      title: Text(
        title ?? AppStrings.appName,
        style: AppTextStyles.appBarTitle,
      ),
      actions: [
        if (showHelpIcon)
          IconButton(
            tooltip: 'Soporte REDIME',
            icon: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 1.5),
              ),
              child: const Center(
                child: Text(
                  '?',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.chat);
            },
          ),
      ],
    );
  }
}
