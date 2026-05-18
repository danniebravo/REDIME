import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/help_button.dart';
import '../viewmodels/device_status_viewmodel.dart';
import '../widgets/tracking_timeline.dart';

class DeviceStatusView extends StatefulWidget {
  const DeviceStatusView({super.key});

  @override
  State<DeviceStatusView> createState() => _DeviceStatusViewState();
}

class _DeviceStatusViewState extends State<DeviceStatusView> {
  @override
  void initState() {
    super.initState();

    // Load mock status on screen entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeviceStatusViewModel>().loadStatus('mock-001');
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DeviceStatusViewModel>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const _DeviceStatusHeader(),
          Expanded(child: _buildBody(vm)),
        ],
      ),
    );
  }

  Widget _buildBody(DeviceStatusViewModel vm) {
    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryTeal),
      );
    }

    if (vm.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.errorRed,
              ),
              const SizedBox(height: 12),
              Text(
                vm.errorMessage!,
                style: const TextStyle(color: AppColors.errorRed, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => vm.loadStatus('mock-001'),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (vm.deviceStatus == null) {
      return const Center(
        child: Text('No hay datos de seguimiento disponibles'),
      );
    }

    final status = vm.deviceStatus!;
    final displaySteps = DeviceStatusViewModel.buildDisplaySteps(status);

    return SingleChildScrollView(
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
                  status.deviceDescription,
                  style: AppTextStyles.sectionLabel.copyWith(fontSize: 16),
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
                      status.deliveryMethod.displayName,
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
                      status.processingType.displayName,
                      style: AppTextStyles.trackingSubtitle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Seguimiento',
            style: AppTextStyles.sectionLabel.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 20),
          TrackingTimeline(steps: displaySteps),
        ],
      ),
    );
  }
}

class _DeviceStatusHeaderClipper extends CustomClipper<Path> {
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

class _DeviceStatusHeader extends StatelessWidget {
  const _DeviceStatusHeader();

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _DeviceStatusHeaderClipper(),
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
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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
