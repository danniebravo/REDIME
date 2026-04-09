import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // ── Top hero section with overlapping circles ──
          SizedBox(
            height: screenHeight * 0.55,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Background mint rectangle
                Positioned.fill(
                  child: Container(color: AppColors.lightMint),
                ),

                // Large dark circle (left-center)
                Positioned(
                  top: -screenWidth * 0.15,
                  left: -screenWidth * 0.25,
                  child: Container(
                    width: screenWidth * 1.0,
                    height: screenWidth * 1.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.darkTeal,
                    ),
                  ),
                ),

                // Medium teal circle (overlapping right)
                Positioned(
                  top: screenHeight * 0.08,
                  left: screenWidth * 0.15,
                  child: Container(
                    width: screenWidth * 0.85,
                    height: screenWidth * 0.85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.tealSurface.withOpacity(0.85),
                    ),
                  ),
                ),

                // Title text centered on circles
                Positioned(
                  bottom: screenHeight * 0.06,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.appName,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppStrings.welcomeGreeting,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Body content ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  Text(
                    AppStrings.welcomeBody,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.screenSubtitle.copyWith(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.darkText,
                    ),
                  ),
                  const Spacer(flex: 3),

                  // ── Continue button ──
                  PrimaryButton(
                    label: AppStrings.continueButton,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.login,
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
