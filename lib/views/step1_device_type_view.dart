import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/widgets/primary_button.dart';
import '../core/widgets/section_header.dart';
import '../widgets/device_type_card.dart';

class Step1DeviceTypeView extends StatelessWidget {
  final String? selectedDeviceType;
  final ValueChanged<String> onSelectDeviceType;
  final VoidCallback onContinue;

  const Step1DeviceTypeView({
    super.key,
    required this.selectedDeviceType,
    required this.onSelectDeviceType,
    required this.onContinue,
  });

  static const _cardConfigs = [
    (
      'large_appliance',
      'Electrodomésticos',
      'assets/images/Electrodomesticos-seleccionado.png',
      'assets/images/Electrodomesticos-deseleccionado.png',
      AppColors.cardLightMint,
    ),
    (
      'small_appliance',
      'Medianos y pequeños',
      'assets/images/Medianos-seleccionados.png',
      'assets/images/Medianos-Deseleccionados.png',
      AppColors.cardLightMint,
    ),
    (
      'telecom_equipment',
      'Equipos de telecomunicaciones',
      'assets/images/Equipos-de-telecom-seleccionados.webp',
      'assets/images/Equipos-de-telecom-deseleccionado_1.webp',
      AppColors.cardMediumTeal,
    ),
    (
      'other',
      'Otros',
      'assets/images/Otros-celeccionado_-blanco_1.webp',
      'assets/images/Otros-deseleccionados_-negro.webp',
      AppColors.cardLightMint,
    ),
  ];

  bool get _canContinue => selectedDeviceType != null;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Empecemos\ncon la redención',
            subtitle:
                '¿Selecciona qué tipo de dispositivo deseas\nreciclar hoy?',
          ),

          const SizedBox(height: 8),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 14,
            childAspectRatio: 1.04,
            children: _cardConfigs.map((config) {
              final (
                id,
                title,
                selectedAssetPath,
                unselectedAssetPath,
                bgColor,
              ) = config;

              return DeviceTypeCard(
                title: title,
                selectedAssetPath: selectedAssetPath,
                unselectedAssetPath: unselectedAssetPath,
                backgroundColor: bgColor,
                isSelected: selectedDeviceType == id,
                onTap: () => onSelectDeviceType(id),
              );
            }).toList(),
          ),

          const SizedBox(height: 60),

          PrimaryButton(
            label: AppStrings.continueButton,
            onPressed: _canContinue ? onContinue : null,
          ),
        ],
      ),
    );
  }
}
