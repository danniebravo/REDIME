import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/help_button.dart';
import '../models/pickup_model.dart';
import '../viewmodels/pickup_list_viewmodel.dart';

class DeviceStatusView extends StatefulWidget {
  const DeviceStatusView({super.key});

  @override
  State<DeviceStatusView> createState() => _DeviceStatusViewState();
}

class _DeviceStatusViewState extends State<DeviceStatusView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PickupListViewModel>().loadMine();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PickupListViewModel>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.primaryTeal,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            const _DeviceStatusHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => context.read<PickupListViewModel>().loadMine(),
                child: _buildBody(vm),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(PickupListViewModel vm) {
    if (vm.isLoading && vm.pickups.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.errorMessage != null && vm.pickups.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 80),
          const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.primaryTeal,
          ),
          const SizedBox(height: 12),
          Text(
            vm.errorMessage!,
            textAlign: TextAlign.center,
            style: AppTextStyles.trackingSubtitle,
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () => vm.loadMine(),
              child: const Text('Reintentar'),
            ),
          ),
        ],
      );
    }

    if (vm.pickups.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 60),
          Text(
            AppStrings.deviceStatusTitle,
            style: AppTextStyles.screenTitle.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 24),
          const Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppColors.primaryTeal,
          ),
          const SizedBox(height: 12),
          const Text(
            'Aún no tienes dispositivos en seguimiento.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.local_shipping),
              label: const Text('Solicitar recogida'),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.pickupFlow);
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Ver puntos de reciclaje'),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.pickupStep1);
              },
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      itemCount: vm.pickups.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              AppStrings.deviceStatusTitle,
              style: AppTextStyles.screenTitle.copyWith(fontSize: 22),
            ),
          );
        }
        final pickup = vm.pickups[index - 1];
        return _PickupCard(
          pickup: pickup,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.pickupStatusDetail,
              arguments: pickup,
            );
          },
        );
      },
    );
  }
}

class _PickupCard extends StatelessWidget {
  final PickupModel pickup;
  final VoidCallback onTap;

  const _PickupCard({required this.pickup, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 1.5,
      shadowColor: Colors.black12,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.mintBackground,
                child: const Icon(
                  Icons.devices_other,
                  color: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pickup.dispositivoLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _StatusBadge(status: pickup.estadoLabel),
                        if (pickup.fechaLabel.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            pickup.fechaLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final s = status.toLowerCase();
    Color bg;
    Color fg;
    if (s.contains('complet') || s.contains('finaliz')) {
      bg = const Color(0xFFE6F5E9);
      fg = const Color(0xFF2E7D32);
    } else if (s.contains('recib') && !s.contains('solicitud')) {
      bg = const Color(0xFFE3F2FD);
      fg = const Color(0xFF1565C0);
    } else if (s.contains('transit') || s.contains('camino')) {
      bg = const Color(0xFFFFF3E0);
      fg = const Color(0xFFE65100);
    } else {
      bg = AppColors.mintBackground;
      fg = AppColors.primaryTeal;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
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
