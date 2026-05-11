import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/redime_app_bar.dart';
import '../features/device_status/presentation/viewmodels/device_status_viewmodel.dart';
import '../features/device_status/presentation/widgets/tracking_timeline.dart';

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
      appBar: const RedimeAppBar(
        title: AppStrings.appName,
        showHelpIcon: true,
      ),
      body: _buildBody(vm),
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
              const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
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
          // Device info header
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

          // Timeline
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
