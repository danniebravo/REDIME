import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';
import '../core/constants/app_strings.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/primary_button.dart';

class PickupStep3DetailsView extends StatefulWidget {
  const PickupStep3DetailsView({super.key});

  @override
  State<PickupStep3DetailsView> createState() => _PickupStep3DetailsViewState();
}

class _PickupStep3DetailsViewState extends State<PickupStep3DetailsView> {
  final TextEditingController _brandController = TextEditingController();

  final FocusNode _brandFocusNode = FocusNode();

  List<String> _brandSuggestions = [];
  bool _showSuggestions = false;

  String? _selectedSubcategory;
  String? _selectedWeight;
  String? _selectedAge;

  bool? _hasScreen;
  bool? _isScreenBroken;

  String? _functionalStatus;
  String? _integrityStatus;

  final List<String> _subcategories = [
    'Electrodoméstico',
    'Computador',
    'Celular',
    'Televisor',
  ];

  final List<String> _weightOptions = [
    'Menos de 1 kg',
    '1 - 5 kg',
    'Más de 5 kg',
  ];

  final List<String> _ageOptions = [
    'Menos de 1 año',
    '1 - 3 años',
    'Más de 3 años',
  ];

  @override
  void dispose() {
    _brandController.dispose();
    _brandFocusNode.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _selectedSubcategory != null &&
      _selectedWeight != null &&
      _selectedAge != null;

  void _onBrandChanged(String value) {
    setState(() {
      _showSuggestions = value.isNotEmpty;
    });
  }

  void _selectBrand(String brand) {
    _brandController.text = brand;

    setState(() {
      _showSuggestions = false;
    });

    _brandFocusNode.unfocus();
  }

  void _continue() {
    Navigator.pushNamed(context, AppRoutes.pickupStep4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'REDIME', currentStep: 3),
      body: SafeArea(
        top: false,
        child: Column(
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
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Completa la información técnica para su tratamiento.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkTeal,
                        ),
                      ),

                      const SizedBox(height: 32),

                      _buildLabel(AppStrings.electronicTypeLabel),

                      const SizedBox(height: 8),

                      _buildDropdown(
                        value: _selectedSubcategory,
                        hint: 'Selecciona una opción',
                        items: _subcategories,
                        onChanged: (val) {
                          setState(() {
                            _selectedSubcategory = val;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      _buildLabel('Marca'),

                      const SizedBox(height: 8),

                      _buildBrandField(),

                      const SizedBox(height: 20),

                      _buildLabel('Peso estimado'),

                      const SizedBox(height: 8),

                      _buildDropdown(
                        value: _selectedWeight,
                        hint: 'Selecciona',
                        items: _weightOptions,
                        onChanged: (val) {
                          setState(() {
                            _selectedWeight = val;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      _buildLabel('Antigüedad'),

                      const SizedBox(height: 8),

                      _buildDropdown(
                        value: _selectedAge,
                        hint: 'Selecciona',
                        items: _ageOptions,
                        onChanged: (val) {
                          setState(() {
                            _selectedAge = val;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      _buildLabel('¿Tiene pantalla?'),

                      const SizedBox(height: 8),

                      _buildYesNo(
                        selected: _hasScreen,
                        onChanged: (v) {
                          setState(() {
                            _hasScreen = v;
                          });
                        },
                      ),

                      if (_hasScreen == true) ...[
                        const SizedBox(height: 20),
                        _buildLabel('¿Pantalla rota?'),
                        const SizedBox(height: 8),
                        _buildYesNo(
                          selected: _isScreenBroken,
                          onChanged: (v) {
                            setState(() {
                              _isScreenBroken = v;
                            });
                          },
                        ),
                      ],

                      const SizedBox(height: 20),

                      _buildLabel('¿Funciona?'),

                      const SizedBox(height: 8),

                      _buildOptions(
                        ['Sí', 'Parcial', 'No'],
                        _functionalStatus,
                        (v) {
                          setState(() {
                            _functionalStatus = v;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      _buildLabel('¿Está completo?'),

                      const SizedBox(height: 8),

                      _buildOptions(['Sí', 'No'], _integrityStatus, (v) {
                        setState(() {
                          _integrityStatus = v;
                        });
                      }),

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
        ),
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
        border: Border.all(color: AppColors.lightTeal),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildBrandField() {
    return TextField(
      controller: _brandController,
      focusNode: _brandFocusNode,
      onChanged: _onBrandChanged,
      decoration: InputDecoration(
        hintText: 'Ej: Samsung, Sony...',
        suffixIcon: _brandController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _brandController.clear();
                  setState(() {
                    _showSuggestions = false;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _buildYesNo({
    required bool? selected,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        _chip('Sí', selected == true, () {
          onChanged(selected == true ? null : true);
        }),
        const SizedBox(width: 12),
        _chip('No', selected == false, () {
          onChanged(selected == false ? null : false);
        }),
      ],
    );
  }

  Widget _buildOptions(
    List<String> options,
    String? selected,
    ValueChanged<String> onTap,
  ) {
    return Wrap(
      spacing: 8,
      children: options.map((e) {
        final active = selected == e;
        return ChoiceChip(
          label: Text(e),
          selected: active,
          onSelected: (_) => onTap(e),
        );
      }).toList(),
    );
  }

  Widget _chip(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: active ? AppColors.teal : AppColors.white,
            border: Border.all(color: AppColors.lightTeal),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(label, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
