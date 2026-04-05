import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/selectable_chip.dart';
import '../../domain/entities/enums.dart';
import '../viewmodels/pickup_flow_viewmodel.dart';
import '../widgets/weight_dropdown.dart';
import '../widgets/age_dropdown.dart';

class Step2DeviceDetailsView extends StatelessWidget {
  const Step2DeviceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PickupFlowViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Center(
            child: SectionHeader(
              title: 'Detalles del Equipo',
              subtitle:
                  'Completa la informaci\u00f3n t\u00e9cnica para su\ntratamiento.',
            ),
          ),
          const SizedBox(height: 28),

          // Electronic type
          Text(AppStrings.electronicTypeLabel, style: AppTextStyles.fieldLabel),
          const SizedBox(height: 8),
          TextField(
            onChanged: vm.setDeviceDescription,
            decoration: const InputDecoration(
              hintText: AppStrings.electronicTypeHint,
            ),
          ),
          const SizedBox(height: 20),

          // Brand
          Text(AppStrings.brandLabel, style: AppTextStyles.fieldLabel),
          const SizedBox(height: 8),
          TextField(
            onChanged: vm.setBrand,
            decoration: const InputDecoration(
              hintText: AppStrings.brandHint,
            ),
          ),
          const SizedBox(height: 20),

          // Weight
          Row(
            children: [
              Text(AppStrings.weightLabel, style: AppTextStyles.fieldLabel),
              const SizedBox(width: 6),
              const Text('\ud83c\udfcb\ufe0f', style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          WeightDropdown(
            value: vm.estimatedWeight,
            onChanged: vm.setEstimatedWeight,
          ),
          const SizedBox(height: 20),

          // Age
          Row(
            children: [
              Text(AppStrings.ageLabel, style: AppTextStyles.fieldLabel),
              const SizedBox(width: 6),
              const Text('\ud83d\udd70\ufe0f', style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          AgeDropdown(
            value: vm.age,
            onChanged: vm.setAge,
          ),
          const SizedBox(height: 20),

          // Still works?
          Text(AppStrings.stillWorksLabel, style: AppTextStyles.fieldLabel),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: DeviceCondition.values.map((c) {
              return SelectableChip(
                label: c.displayName,
                isSelected: vm.condition == c,
                onTap: () => vm.setCondition(c),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // One piece?
          Text(AppStrings.onePieceLabel, style: AppTextStyles.fieldLabel),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: DeviceIntegrity.values.map((i) {
              return SelectableChip(
                label: i.displayName,
                isSelected: vm.integrity == i,
                onTap: () => vm.setIntegrity(i),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Continue button
          PrimaryButton(
            label: AppStrings.continueButton,
            onPressed: vm.canContinueStep2 ? () => vm.nextStep() : null,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
