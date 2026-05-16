import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';
import 'help_button.dart';

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
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.white,
                size: 28,
              ),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(
        title ?? AppStrings.appName,
        style: AppTextStyles.appBarTitle,
      ),
      actions: [
        if (showHelpIcon)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: HelpButton(
              size: 40,
              iconSize: 20,
              borderWidth: 2,
              color: AppColors.white,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.chat);
              },
            ),
          ),
      ],
    );
  }
}
