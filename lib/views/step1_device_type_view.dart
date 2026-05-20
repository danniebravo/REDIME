import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/widgets/primary_button.dart';
import '../core/widgets/section_header.dart';
import '../features/device_pickup/domain/entities/enums.dart';
import '../features/device_pickup/presentation/viewmodels/pickup_flow_viewmodel.dart';
import '../widgets/device_type_card.dart';

class Step1DeviceTypeView extends StatelessWidget {
  const Step1DeviceTypeView({super.key});

  static const _cardConfigs = [
    (
      DeviceType.largeAppliance,
      'assets/images/Electrodomesticos-seleccionado.png',
      'assets/images/Electrodomesticos-deseleccionado.png',
      AppColors.cardLightMint,
    ),
    (
      DeviceType.smallAppliance,
      'assets/images/Medianos-seleccionados.png',
      'assets/images/Medianos-Deseleccionados.png',
      AppColors.cardLightMint,
    ),
    (
      DeviceType.telecomEquipment,
      'assets/images/Equipos-de-telecom-seleccionados.webp',
      'assets/images/Equipos-de-telecom-deseleccionado_1.webp',
      AppColors.cardMediumTeal,
    ),
    (
      DeviceType.other,
      'assets/images/Otros-celeccionado_-blanco_1.webp',
      'assets/images/Otros-deseleccionados_-negro.webp',
      AppColors.cardLightMint,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PickupFlowViewModel>();

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
              final (type, selectedAssetPath, unselectedAssetPath, bgColor) =
                  config;

              return DeviceTypeCard(
                type: type,
                selectedAssetPath: selectedAssetPath,
                unselectedAssetPath: unselectedAssetPath,
                backgroundColor: bgColor,
                isSelected: vm.selectedDeviceType == type,
                onTap: () => vm.selectDeviceType(type),
              );
            }).toList(),
          ),

          const SizedBox(height: 60),

          PrimaryButton(
            label: AppStrings.continueButton,
            onPressed: vm.canContinueStep1 ? () => vm.nextStep() : null,
          ),
        ],
      ),
    );
  }
}
