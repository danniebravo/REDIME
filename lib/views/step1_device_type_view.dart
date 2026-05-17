import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/widgets/primary_button.dart';
import '../core/widgets/section_header.dart';
import '../widgets/device_type_card.dart';

class Step1DeviceTypeView extends StatefulWidget {
  const Step1DeviceTypeView({super.key});

  @override
  State<Step1DeviceTypeView> createState() => _Step1DeviceTypeViewState();
}

class _Step1DeviceTypeViewState extends State<Step1DeviceTypeView> {
  String? _selectedDeviceType;

  static const _cardConfigs = [
    ('Electrodoméstico grande', Icons.kitchen, AppColors.cardLightMint),
    ('Electrodoméstico pequeño', Icons.blender, AppColors.cardMediumTeal),
    ('Equipos de telecomunicación', Icons.headphones, AppColors.cardDarkTeal),
    ('Otros dispositivos', Icons.devices_other, AppColors.cardDarkTeal),
  ];

  bool get _canContinue => _selectedDeviceType != null;

  void _selectDeviceType(String type) {
    setState(() {
      _selectedDeviceType = type;
    });
  }

  void _continue() {
    // Tu lógica aquí
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Empecemos\ncon la redención',
            subtitle:
                '¿Selecciona qué tipo de dispositivo deseas\nreciclar hoy?',
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
              final (title, icon, bgColor) = config;

              return DeviceTypeCard(
                title: title,
                icon: icon,
                backgroundColor: bgColor,
                isSelected: _selectedDeviceType == title,
                onTap: () => _selectDeviceType(title),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          PrimaryButton(
            label: AppStrings.continueButton,
            onPressed: _canContinue ? _continue : null,
          ),
        ],
      ),
    );
  }
}
