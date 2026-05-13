import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/redime_app_bar.dart';
import '../widgets/tracking_timeline.dart';

class DeviceStatusView extends StatefulWidget {
  const DeviceStatusView({super.key});

  @override
  State<DeviceStatusView> createState() => _DeviceStatusViewState();
}

class _DeviceStatusViewState extends State<DeviceStatusView> {
  final List<Map<String, dynamic>> steps = [
    {
      "title": "Solicitud recibida",
      "subtitle": "Hemos recibido tu solicitud",
      "isCompleted": true,
      "isCurrent": false,
      "completedAt": "12/05/2026",
    },
    {
      "title": "Dispositivo en tránsito",
      "subtitle": "El dispositivo va en camino",
      "isCompleted": false,
      "isCurrent": true,
      "completedAt": null,
    },
    {
      "title": "Dispositivo recibido",
      "subtitle": "Ya llegó a nuestras instalaciones",
      "isCompleted": false,
      "isCurrent": false,
      "completedAt": null,
    },
    {
      "title": "Proceso completado",
      "subtitle": "Finalizado correctamente",
      "isCompleted": false,
      "isCurrent": false,
      "completedAt": null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RedimeAppBar(title: AppStrings.appName, showHelpIcon: true),
      body: SingleChildScrollView(
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
                    'iPhone 13 Pro Max',
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
                        'Entrega a domicilio',
                        style: AppTextStyles.trackingSubtitle,
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.recycling,
                        size: 16,
                        color: AppColors.primaryTeal,
                      ),
                      const SizedBox(width: 6),
                      Text('Reciclaje', style: AppTextStyles.trackingSubtitle),
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

            TrackingTimeline(steps: steps),
          ],
        ),
      ),
    );
  }
}
