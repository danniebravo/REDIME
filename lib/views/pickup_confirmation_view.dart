import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/redime_app_bar.dart';

class PickupConfirmationView extends StatelessWidget {
  const PickupConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporal hasta conectar ViewModel/backend
    const bool hasStory = true;

    return Scaffold(
      appBar: RedimeAppBar(
        title: AppStrings.confirmationAppBarTitle,
        showBackButton: false,
        showHelpIcon: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Recycling check icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.mintBackground,
                  border: Border.all(color: AppColors.primaryTeal, width: 3),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: AppColors.primaryTeal,
                ),
              ),

              const SizedBox(height: 28),

              // Title
              Text(
                AppStrings.confirmationTitle,
                style: AppTextStyles.confirmationTitle,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                AppStrings.confirmationSubtitle,
                style: AppTextStyles.confirmationSubtitle,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 36),

              // Back to home button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (_) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryTeal,
                    side: const BorderSide(
                      color: AppColors.primaryTeal,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppStrings.backToHome,
                    style: AppTextStyles.outlineButtonLabel,
                  ),
                ),
              ),

              // Share button
              if (hasStory) ...[
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Compartir: próximamente'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.share, size: 18),
                    label: Text(
                      AppStrings.shareOnSocial,
                      style: AppTextStyles.outlineButtonLabel,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryTeal,
                      side: const BorderSide(
                        color: AppColors.primaryTeal,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
