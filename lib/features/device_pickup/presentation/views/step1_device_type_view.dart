import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/enums.dart';
import '../viewmodels/pickup_flow_viewmodel.dart';
import '../widgets/device_type_card.dart';

class Step1DeviceTypeView extends StatelessWidget {
  const Step1DeviceTypeView({super.key});

  static const _cardConfigs = [
    (DeviceType.largeAppliance, Icons.kitchen, AppColors.cardLightMint),
    (DeviceType.smallAppliance, Icons.blender, AppColors.cardMediumTeal),
    (DeviceType.telecomEquipment, Icons.headphones, AppColors.cardDarkTeal),
    (DeviceType.other, Icons.devices_other, AppColors.cardDarkTeal),
  ];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PickupFlowViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Empecemos\ncon la redenci\u00f3n',
            subtitle:
                '\u00bfSelecciona qu\u00e9 tipo de dispositivo deseas\nreciclar hoy?',
          ),
          const SizedBox(height: 28),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.95,
            children: _cardConfigs.map((config) {
              final (type, icon, bgColor) = config;
              return DeviceTypeCard(
                type: type,
                icon: icon,
                backgroundColor: bgColor,
                isSelected: vm.selectedDeviceType == type,
                onTap: () => vm.selectDeviceType(type),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: AppStrings.continueButton,
            onPressed: vm.canContinueStep1 ? () => vm.nextStep() : null,
          ),
        ],
      ),
    );
  }
}
