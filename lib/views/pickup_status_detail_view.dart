import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/help_button.dart';
import '../models/pickup_model.dart';
import '../widgets/tracking_timeline.dart';

class PickupStatusDetailView extends StatelessWidget {
  final PickupModel pickup;

  const PickupStatusDetailView({super.key, required this.pickup});

  @override
  Widget build(BuildContext context) {
    final steps = pickup.trackingSteps;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.primaryTeal,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            const _DetailHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.deviceStatusTitle,
                      style: AppTextStyles.screenTitle.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.mintBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pickup.dispositivoLabel,
                            style: AppTextStyles.sectionLabel.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.local_shipping_outlined,
                                size: 16,
                                color: AppColors.primaryTeal,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                pickup.sourceLabel,
                                style: AppTextStyles.trackingSubtitle,
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.recycling,
                                size: 16,
                                color: AppColors.primaryTeal,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Reciclaje',
                                style: AppTextStyles.trackingSubtitle,
                              ),
                            ],
                          ),
                          if (pickup.fechaLabel.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.event,
                                  size: 16,
                                  color: AppColors.primaryTeal,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Solicitud del ${pickup.fechaLabel}',
                                  style: AppTextStyles.trackingSubtitle,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Seguimiento',
                      style: AppTextStyles.sectionLabel.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    TrackingTimeline(steps: steps),
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

class _DetailHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 38);
    path.quadraticBezierTo(
      size.width / 2,
      size.height - 2,
      size.width,
      size.height - 38,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader();

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _DetailHeaderClipper(),
      child: Container(
        width: double.infinity,
        color: AppColors.primaryTeal,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 34),
            child: SizedBox(
              height: 54,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    top: 5,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      AppStrings.appName,
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 7,
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
