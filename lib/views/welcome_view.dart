import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';
import '../core/constants/app_strings.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Circle sizes based on screen proportions (matched to Figma)
    final bigCircleDiameter = screenWidth * 1.15;
    final medCircleDiameter = screenWidth * 0.95;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        top: false, // let circles bleed into status bar
        child: Column(
          children: [
            // ═══════════════════════════════════════════
            // Top hero: mint background + 2 overlapping circles + title
            // ═══════════════════════════════════════════
            ClipRect(
              child: SizedBox(
                height: screenHeight * 0.62,
                width: double.infinity,
                child: Stack(
                  children: [
                    // ── Mint background ──
                    Positioned.fill(
                      child: Container(color: AppColors.welcomeMintBg),
                    ),

                    // ── Large dark circle (upper-left, bleeds off screen) ──
                    Positioned(
                      top: -bigCircleDiameter * 0.18,
                      left: -bigCircleDiameter * 0.28,
                      child: Container(
                        width: bigCircleDiameter,
                        height: bigCircleDiameter,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.welcomeDarkCircle,
                        ),
                      ),
                    ),

                    // ── Medium teal circle (overlapping, center-right) ──
                    Positioned(
                      top: screenHeight * 0.10,
                      left: screenWidth * 0.18,
                      child: Container(
                        width: medCircleDiameter,
                        height: medCircleDiameter,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.welcomeMediumCircle,
                        ),
                      ),
                    ),

                    // ── REDIME + ¡Bienvenido! ──
                    Positioned(
                      bottom: screenHeight * 0.07,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'REDIME',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '¡Bienvenido!',
                            style: TextStyle(
                              fontSize: 17,
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
            ),

            // ═══════════════════════════════════════════
            // Bottom section: body text + button
            // ═══════════════════════════════════════════
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  children: [
                    const Spacer(flex: 3),

                    // ── Description text ──
                    const Text(
                      'Tus dispositivos tienen historia y nosotros la\n'
                      'preservamos. Conoce las opciones que REDIME te\n'
                      'ofrece y comienza tu proceso ahora',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkText,
                        height: 1.55,
                      ),
                    ),

                    const Spacer(flex: 5),

                    // ── Continuar button (sin flecha, tal como el diseño) ──
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.login,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryTeal,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Continuar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
