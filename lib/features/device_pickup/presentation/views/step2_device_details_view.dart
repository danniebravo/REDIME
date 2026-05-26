import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/enums.dart';
import '../viewmodels/pickup_flow_viewmodel.dart';

class Step2DeviceDetailsView extends StatefulWidget {
  const Step2DeviceDetailsView({super.key});

  @override
  State<Step2DeviceDetailsView> createState() => _Step2DeviceDetailsViewState();
}

class _Step2DeviceDetailsViewState extends State<Step2DeviceDetailsView> {
  final TextEditingController _brandController = TextEditingController();
  final FocusNode _brandFocusNode = FocusNode();

  List<String> _brandSuggestions = [];
  bool _showSuggestions = false;

  @override
  void dispose() {
    _brandController.dispose();
    _brandFocusNode.dispose();
    super.dispose();
  }

  void _onBrandChanged(PickupFlowViewModel vm, String value) {
    vm.setBrand(value);

    final suggestions = vm.searchBrands(value);

    setState(() {
      _brandSuggestions = suggestions;
      _showSuggestions = suggestions.isNotEmpty && value.isNotEmpty;
    });
  }

  void _selectBrand(PickupFlowViewModel vm, String brand) {
    _brandController.text = brand;
    vm.setBrand(brand);

    setState(() {
      _showSuggestions = false;
      _brandSuggestions = [];
    });

    _brandFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PickupFlowViewModel>();

    if (_brandController.text != vm.brand && !_brandFocusNode.hasFocus) {
      _brandController.text = vm.brand;
    }

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              _brandFocusNode.unfocus();
              setState(() => _showSuggestions = false);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),

                  const Text(
                    'Detalles del Equipo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Completa la información técnica para su\ntratamiento.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.darkTeal,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 32),

                  _buildLabel(AppStrings.electronicTypeLabel),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: vm.selectedSubcategory,
                    hint: 'Selecciona una opción',
                    items: vm.subcategories,
                    onChanged: vm.setSubcategory,
                  ),

                  if (vm.isNonRaee) ...[
                    const SizedBox(height: 12),
                    _buildNonRaeeWarning(),
                  ],

                  if (vm.dynamicExtraFieldLabel != null &&
                      vm.dynamicExtraFieldOptions != null) ...[
                    const SizedBox(height: 20),
                    _buildLabel(vm.dynamicExtraFieldLabel!),
                    const SizedBox(height: 8),
                    _buildChipRow(
                      options: vm.dynamicExtraFieldOptions!,
                      selected: vm.selectedDynamicExtra,
                      onSelected: vm.setDynamicExtra,
                    ),
                  ],

                  const SizedBox(height: 20),

                  _buildLabel(AppStrings.brandLabel),
                  const SizedBox(height: 8),
                  _buildBrandAutocomplete(vm),

                  const SizedBox(height: 20),

                  _buildLabelWithIcon(
                    AppStrings.weightLabel,
                    Icons.shopping_bag_outlined,
                  ),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: vm.estimatedWeight,
                    hint: AppStrings.selectPlaceholder,
                    items: PickupFlowViewModel.weightOptions,
                    onChanged: vm.setEstimatedWeight,
                  ),

                  const SizedBox(height: 20),

                  _buildLabelWithIcon(AppStrings.ageLabel, Icons.access_time),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: vm.age,
                    hint: AppStrings.selectPlaceholder,
                    items: PickupFlowViewModel.ageOptions,
                    onChanged: vm.setAge,
                  ),

                  const SizedBox(height: 20),

                  _buildLabel('¿Tiene pantalla?'),
                  const SizedBox(height: 8),
                  _buildYesNoChips(
                    selected: vm.hasScreen,
                    onSelected: vm.setHasScreen,
                  ),

                  if (vm.hasScreen == true) ...[
                    const SizedBox(height: 20),
                    _buildLabel('¿La pantalla está rota?'),
                    const SizedBox(height: 8),
                    _buildYesNoChips(
                      selected: vm.isScreenBroken,
                      onSelected: vm.setIsScreenBroken,
                    ),
                  ],

                  const SizedBox(height: 20),

                  _buildLabel(AppStrings.stillWorksLabel),
                  const SizedBox(height: 8),
                  _buildConditionChips(vm),

                  const SizedBox(height: 20),

                  _buildLabel(AppStrings.onePieceLabel),
                  const SizedBox(height: 8),
                  _buildIntegrityChips(vm),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: PrimaryButton(
            label: AppStrings.continueButton,
            onPressed: vm.canContinueStep2 ? () => vm.nextStep() : null,
          ),
        ),
      ],
    );
  }

  Widget _buildBrandAutocomplete(PickupFlowViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightTeal, width: 1.5),
          ),
          child: TextField(
            controller: _brandController,
            focusNode: _brandFocusNode,
            onChanged: (value) => _onBrandChanged(vm, value),
            style: const TextStyle(fontSize: 14, color: AppColors.textMain),
            decoration: InputDecoration(
              hintText: AppStrings.brandHint,
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
              suffixIcon: _brandController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        size: 18,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        _brandController.clear();
                        _onBrandChanged(vm, '');
                      },
                    )
                  : null,
            ),
          ),
        ),

        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightTeal, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _brandSuggestions.map((brand) {
                return InkWell(
                  onTap: () => _selectBrand(vm, brand),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.devices,
                          size: 16,
                          color: AppColors.teal,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          brand,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textMain,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildYesNoChips({
    required bool? selected,
    required ValueChanged<bool?> onSelected,
  }) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onSelected(selected == true ? null : true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected == true
                      ? AppColors.teal
                      : AppColors.lightTeal,
                  width: selected == true ? 2 : 1.5,
                ),
              ),
              child: Text(
                'Sí',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected == true
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: selected == true
                      ? AppColors.darkTeal
                      : AppColors.textMain,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => onSelected(selected == false ? null : false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected == false
                      ? AppColors.teal
                      : AppColors.lightTeal,
                  width: selected == false ? 2 : 1.5,
                ),
              ),
              child: Text(
                'No',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected == false
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: selected == false
                      ? AppColors.darkTeal
                      : AppColors.textMain,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNonRaeeWarning() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text(
                'Objeto no permitido',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Este objeto no es un residuo electrónico (RAEE). Puedes llevarlo a los puntos de reciclaje convencional de la Alcaldía de Medellín o a las cajas de recolección de tu barrio.',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textMain,
      ),
    );
  }

  Widget _buildLabelWithIcon(String text, IconData icon) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textMain,
          ),
        ),
        const SizedBox(width: 6),
        Icon(icon, color: AppColors.teal, size: 18),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final safeValue = items.contains(value) ? value : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightTeal, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: safeValue,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.darkTeal,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 14, color: AppColors.textMain),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildChipRow({
    required List<String> options,
    required String? selected,
    required ValueChanged<String?> onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isActive = selected == option;

        return GestureDetector(
          onTap: () => onSelected(isActive ? null : option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive ? AppColors.teal : AppColors.lightTeal,
                width: isActive ? 2 : 1.5,
              ),
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.darkTeal : AppColors.textMain,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConditionChips(PickupFlowViewModel vm) {
    final options = DeviceCondition.values;

    return Row(
      children: options.map((condition) {
        final isSelected = vm.condition == condition;
        final isMiddle = condition == DeviceCondition.partiallyWorking;

        return Expanded(
          flex: isMiddle ? 3 : 1,
          child: Padding(
            padding: EdgeInsets.only(
              right: condition == DeviceCondition.notWorking ? 0 : 8,
              left: condition == DeviceCondition.fullyWorking ? 0 : 4,
            ),
            child: GestureDetector(
              onTap: () => vm.setCondition(condition),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.teal : AppColors.lightTeal,
                    width: isSelected ? 2 : 1.5,
                  ),
                ),
                child: Text(
                  condition.displayName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? AppColors.darkTeal : AppColors.textMain,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIntegrityChips(PickupFlowViewModel vm) {
    final options = DeviceIntegrity.values;

    return Row(
      children: options.map((integrity) {
        final isSelected = vm.integrity == integrity;
        final isFirst = integrity == DeviceIntegrity.singlePiece;

        return Expanded(
          flex: isFirst ? 1 : 3,
          child: Padding(
            padding: EdgeInsets.only(
              right: isFirst ? 8 : 0,
              left: isFirst ? 0 : 4,
            ),
            child: GestureDetector(
              onTap: () => vm.setIntegrity(integrity),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.teal : AppColors.lightTeal,
                    width: isSelected ? 2 : 1.5,
                  ),
                ),
                child: Text(
                  integrity.displayName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? AppColors.darkTeal : AppColors.textMain,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
