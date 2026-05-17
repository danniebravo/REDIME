import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/widgets/primary_button.dart';

class Step2DeviceDetailsView extends StatefulWidget {
  const Step2DeviceDetailsView({super.key});

  @override
  State<Step2DeviceDetailsView> createState() => _Step2DeviceDetailsViewState();
}

class _Step2DeviceDetailsViewState extends State<Step2DeviceDetailsView> {
  final TextEditingController _brandController = TextEditingController();

  final FocusNode _brandFocusNode = FocusNode();

  final List<String> _brandSuggestions = [];

  bool _showSuggestions = false;

  String? _selectedSubcategory;
  String? _estimatedWeight;
  String? _age;
  bool? _hasScreen;
  bool? _isScreenBroken;

  String? _selectedCondition;
  String? _selectedIntegrity;

  final List<String> _subcategories = [
    'Laptop',
    'Celular',
    'Monitor',
    'Tablet',
  ];

  final List<String> _weightOptions = [
    'Menos de 1kg',
    '1kg - 5kg',
    'Más de 5kg',
  ];

  final List<String> _ageOptions = [
    'Menos de 1 año',
    '1 - 3 años',
    'Más de 3 años',
  ];

  final List<String> _conditionOptions = ['Sí', 'Parcialmente', 'No'];

  final List<String> _integrityOptions = ['Completo', 'Por partes'];

  @override
  void dispose() {
    _brandController.dispose();
    _brandFocusNode.dispose();
    super.dispose();
  }

  void _onBrandChanged(String value) {
    setState(() {
      _showSuggestions = value.isNotEmpty && _brandSuggestions.isNotEmpty;
    });
  }

  void _selectBrand(String brand) {
    _brandController.text = brand;

    setState(() {
      _showSuggestions = false;
    });

    _brandFocusNode.unfocus();
  }

  bool get _canContinue {
    return _selectedSubcategory != null &&
        _brandController.text.trim().isNotEmpty;
  }

  void _continue() {
    // Tu lógica aquí
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              _brandFocusNode.unfocus();

              setState(() {
                _showSuggestions = false;
              });
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
                    value: _selectedSubcategory,
                    hint: 'Selecciona una opción',
                    items: _subcategories,
                    onChanged: (value) {
                      setState(() {
                        _selectedSubcategory = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  _buildLabel(AppStrings.brandLabel),

                  const SizedBox(height: 8),

                  _buildBrandAutocomplete(),

                  const SizedBox(height: 20),

                  _buildLabelWithIcon(
                    AppStrings.weightLabel,
                    Icons.shopping_bag_outlined,
                  ),

                  const SizedBox(height: 8),

                  _buildDropdown(
                    value: _estimatedWeight,
                    hint: AppStrings.selectPlaceholder,
                    items: _weightOptions,
                    onChanged: (value) {
                      setState(() {
                        _estimatedWeight = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  _buildLabelWithIcon(AppStrings.ageLabel, Icons.access_time),

                  const SizedBox(height: 8),

                  _buildDropdown(
                    value: _age,
                    hint: AppStrings.selectPlaceholder,
                    items: _ageOptions,
                    onChanged: (value) {
                      setState(() {
                        _age = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  _buildLabel('¿Tiene pantalla?'),

                  const SizedBox(height: 8),

                  _buildYesNoChips(
                    selected: _hasScreen,
                    onSelected: (value) {
                      setState(() {
                        _hasScreen = value;
                      });
                    },
                  ),

                  if (_hasScreen == true) ...[
                    const SizedBox(height: 20),

                    _buildLabel('¿La pantalla está rota?'),

                    const SizedBox(height: 8),

                    _buildYesNoChips(
                      selected: _isScreenBroken,
                      onSelected: (value) {
                        setState(() {
                          _isScreenBroken = value;
                        });
                      },
                    ),
                  ],

                  const SizedBox(height: 20),

                  _buildLabel(AppStrings.stillWorksLabel),

                  const SizedBox(height: 8),

                  _buildSelectionChips(
                    options: _conditionOptions,
                    selected: _selectedCondition,
                    onSelected: (value) {
                      setState(() {
                        _selectedCondition = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  _buildLabel(AppStrings.onePieceLabel),

                  const SizedBox(height: 8),

                  _buildSelectionChips(
                    options: _integrityOptions,
                    selected: _selectedIntegrity,
                    onSelected: (value) {
                      setState(() {
                        _selectedIntegrity = value;
                      });
                    },
                  ),

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
            onPressed: _canContinue ? _continue : null,
          ),
        ),
      ],
    );
  }

  Widget _buildBrandAutocomplete() {
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
            onChanged: _onBrandChanged,
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

                        setState(() {
                          _showSuggestions = false;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),

        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightTeal, width: 1.5),
            ),
            child: const Text('Sin sugerencias'),
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
              child: Text('Sí', textAlign: TextAlign.center),
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
              child: const Text('No', textAlign: TextAlign.center),
            ),
          ),
        ),
      ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightTeal, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.darkTeal,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSelectionChips({
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelected,
  }) {
    return Row(
      children: options.map((option) {
        final isSelected = selected == option;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelected(option),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.teal : AppColors.lightTeal,
                    width: isSelected ? 2 : 1.5,
                  ),
                ),
                child: Text(option, textAlign: TextAlign.center),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
