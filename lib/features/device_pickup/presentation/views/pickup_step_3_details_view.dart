import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../viewmodels/pickup_viewmodel.dart';

class PickupStep3DetailsView extends StatefulWidget {
  const PickupStep3DetailsView({super.key});

  @override
  State<PickupStep3DetailsView> createState() => _PickupStep3DetailsViewState();
}

class _PickupStep3DetailsViewState extends State<PickupStep3DetailsView> {
  late PickupViewModel _viewModel;
  final TextEditingController _brandController = TextEditingController();
  final FocusNode _brandFocusNode = FocusNode();
  List<String> _brandSuggestions = [];
  bool _showSuggestions = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as PickupViewModel?;
    _viewModel = args ?? PickupViewModel();
    _viewModel.addListener(_onViewModelChange);
    _brandController.text = _viewModel.brand;
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    _brandController.dispose();
    _brandFocusNode.dispose();
    super.dispose();
  }

  void _onViewModelChange() {
    setState(() {});
  }

  void _onBrandChanged(String value) {
    _viewModel.setBrand(value);
    final suggestions = _viewModel.searchBrands(value);
    setState(() {
      _brandSuggestions = suggestions;
      _showSuggestions = suggestions.isNotEmpty && value.isNotEmpty;
    });
  }

  void _selectBrand(String brand) {
    _brandController.text = brand;
    _viewModel.setBrand(brand);
    setState(() {
      _showSuggestions = false;
      _brandSuggestions = [];
    });
    _brandFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'REDIME',
        currentStep: 3,
      ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                        style: TextStyle(fontSize: 14, color: AppColors.darkTeal),
                      ),
                      const SizedBox(height: 32),

                      // 1. ¿Qué tipo de electrónico es?
                      _buildLabel('¿Qué tipo de electrónico es?'),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: _viewModel.selectedSubcategory,
                        hint: 'Selecciona una opción',
                        items: _viewModel.subcategories,
                        onChanged: (val) => _viewModel.setSubcategory(val),
                      ),

                      // Non-RAEE warning
                      if (_viewModel.isNonRaee) ...[
                        const SizedBox(height: 12),
                        _buildNonRaeeWarning(),
                      ],

                      // Dynamic extra field per subcategory
                      if (_viewModel.dynamicExtraFieldLabel != null) ...[
                        const SizedBox(height: 20),
                        _buildLabel(_viewModel.dynamicExtraFieldLabel!),
                        const SizedBox(height: 8),
                        _buildChipRow(
                          options: _viewModel.dynamicExtraFieldOptions!,
                          selected: _viewModel.selectedDynamicExtra,
                          onSelected: (val) => _viewModel.setDynamicExtra(val),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // 2. Marca del dispositivo (Autocomplete con fuzzy search)
                      _buildLabel('Marca del dispositivo'),
                      const SizedBox(height: 8),
                      _buildBrandAutocomplete(),

                      const SizedBox(height: 20),

                      // 3. Peso estimado
                      _buildLabelWithIcon('Peso estimado', Icons.shopping_bag_outlined, AppColors.teal),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: _viewModel.selectedWeight,
                        hint: 'Selecciona',
                        items: PickupViewModel.weightOptions,
                        onChanged: (val) => _viewModel.setWeight(val),
                      ),
                      const SizedBox(height: 20),

                      // 4. Antigüedad
                      _buildLabelWithIcon('Antigüedad', Icons.access_time, AppColors.teal),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: _viewModel.selectedAge,
                        hint: 'Selecciona',
                        items: PickupViewModel.ageOptions,
                        onChanged: (val) => _viewModel.setAge(val),
                      ),
                      const SizedBox(height: 20),

                      // 5. ¿Tiene pantalla? (condicional)
                      _buildLabel('¿Tiene pantalla?'),
                      const SizedBox(height: 8),
                      _buildYesNoChips(
                        selected: _viewModel.hasScreen,
                        onSelected: (val) => _viewModel.setHasScreen(val),
                      ),

                      // 5.1 ¿La pantalla está rota? (solo si tiene pantalla)
                      if (_viewModel.hasScreen == true) ...[
                        const SizedBox(height: 20),
                        _buildLabel('¿La pantalla está rota?'),
                        const SizedBox(height: 8),
                        _buildYesNoChips(
                          selected: _viewModel.isScreenBroken,
                          onSelected: (val) => _viewModel.setIsScreenBroken(val),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // 6. ¿Aún funciona?
                      _buildLabel('¿Aún funciona?'),
                      const SizedBox(height: 8),
                      _buildFunctionalStatusChips(),
                      const SizedBox(height: 20),

                      // 7. ¿Está en una sola pieza?
                      _buildLabel('¿Está en una sola pieza?'),
                      const SizedBox(height: 8),
                      _buildIntegrityChips(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: PrimaryButton(
                text: 'Continuar',
                isEnabled: _viewModel.isStep3Valid,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.pickupStep4, arguments: _viewModel);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Brand Autocomplete with fuzzy search ----

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
            decoration: InputDecoration(
              hintText: 'Ej: Sony, Samsung, DELL...',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
              suffixIcon: _brandController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                      onPressed: () {
                        _brandController.clear();
                        _onBrandChanged('');
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
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _brandSuggestions.map((brand) {
                return InkWell(
                  onTap: () => _selectBrand(brand),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.devices, size: 16, color: AppColors.teal),
                        const SizedBox(width: 12),
                        Text(
                          brand,
                          style: const TextStyle(fontSize: 14, color: AppColors.textMain),
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

  // ---- Yes/No chips ----

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
                  color: selected == true ? AppColors.teal : AppColors.lightTeal,
                  width: selected == true ? 2 : 1.5,
                ),
              ),
              child: Text(
                'Sí',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected == true ? FontWeight.w600 : FontWeight.w400,
                  color: selected == true ? AppColors.darkTeal : AppColors.textMain,
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
                  color: selected == false ? AppColors.teal : AppColors.lightTeal,
                  width: selected == false ? 2 : 1.5,
                ),
              ),
              child: Text(
                'No',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected == false ? FontWeight.w600 : FontWeight.w400,
                  color: selected == false ? AppColors.darkTeal : AppColors.textMain,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---- Non-RAEE warning ----

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
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
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

  // ---- Reusable form building widgets ----

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

  Widget _buildLabelWithIcon(String text, IconData icon, Color iconColor) {
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
        Icon(icon, color: iconColor, size: 18),
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
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.darkTeal),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 14)));
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

  Widget _buildFunctionalStatusChips() {
    final options = [
      {'label': 'Sí', 'value': FunctionalStatus.yes},
      {'label': 'Sí, pero no en su totalidad', 'value': FunctionalStatus.partial},
      {'label': 'No', 'value': FunctionalStatus.no},
    ];

    return Column(
      children: options.map((opt) {
        final isActive = _viewModel.functionalStatus == opt['value'];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () => _viewModel.setFunctionalStatus(opt['value'] as FunctionalStatus),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? AppColors.teal : AppColors.lightTeal,
                  width: isActive ? 2 : 1.5,
                ),
              ),
              child: Text(
                opt['label'] as String,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.darkTeal : AppColors.textMain,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIntegrityChips() {
    final options = [
      {'label': 'Sí', 'value': IntegrityStatus.yes},
      {'label': 'No, tiene piezas sueltas', 'value': IntegrityStatus.looseParts},
    ];

    return Row(
      children: options.map((opt) {
        final isActive = _viewModel.integrityStatus == opt['value'];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: opt['value'] == IntegrityStatus.yes ? 8 : 0,
              left: opt['value'] == IntegrityStatus.looseParts ? 8 : 0,
            ),
            child: GestureDetector(
              onTap: () => _viewModel.setIntegrityStatus(opt['value'] as IntegrityStatus),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive ? AppColors.teal : AppColors.lightTeal,
                    width: isActive ? 2 : 1.5,
                  ),
                ),
                child: Text(
                  opt['label'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? AppColors.darkTeal : AppColors.textMain,
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
