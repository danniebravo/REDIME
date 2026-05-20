import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/widgets/primary_button.dart';

class Step2DeviceDetailsView extends StatefulWidget {
  final String? selectedSubcategory;
  final List<String> subcategories;
  final bool isNonRaee;

  final String? dynamicExtraFieldLabel;
  final List<String>? dynamicExtraFieldOptions;
  final String? selectedDynamicExtra;

  final String brand;
  final String? estimatedWeight;
  final String? age;
  final bool? hasScreen;
  final bool? isScreenBroken;
  final String? condition;
  final String? integrity;
  final bool canContinue;

  final ValueChanged<String?> onSubcategoryChanged;
  final ValueChanged<String?> onDynamicExtraChanged;
  final ValueChanged<String> onBrandChanged;
  final ValueChanged<String?> onEstimatedWeightChanged;
  final ValueChanged<String?> onAgeChanged;
  final ValueChanged<bool?> onHasScreenChanged;
  final ValueChanged<bool?> onScreenBrokenChanged;
  final ValueChanged<String?> onConditionChanged;
  final ValueChanged<String?> onIntegrityChanged;
  final VoidCallback onContinue;

  const Step2DeviceDetailsView({
    super.key,
    required this.selectedSubcategory,
    required this.subcategories,
    required this.isNonRaee,
    required this.dynamicExtraFieldLabel,
    required this.dynamicExtraFieldOptions,
    required this.selectedDynamicExtra,
    required this.brand,
    required this.estimatedWeight,
    required this.age,
    required this.hasScreen,
    required this.isScreenBroken,
    required this.condition,
    required this.integrity,
    required this.canContinue,
    required this.onSubcategoryChanged,
    required this.onDynamicExtraChanged,
    required this.onBrandChanged,
    required this.onEstimatedWeightChanged,
    required this.onAgeChanged,
    required this.onHasScreenChanged,
    required this.onScreenBrokenChanged,
    required this.onConditionChanged,
    required this.onIntegrityChanged,
    required this.onContinue,
  });

  static const List<String> weightOptions = [
    'Menos de 1 kg',
    '1 - 5 kg',
    '5 - 15 kg',
    '15 - 30 kg',
    'Más de 30 kg',
  ];

  static const List<String> ageOptions = [
    'Menos de 1 año',
    '1 - 3 años',
    '3 - 5 años',
    '5 - 10 años',
    'Más de 10 años',
  ];

  static const List<String> conditionOptions = [
    'fully_working',
    'partially_working',
    'not_working',
  ];

  static const List<String> integrityOptions = [
    'single_piece',
    'multiple_pieces',
  ];

  @override
  State<Step2DeviceDetailsView> createState() => _Step2DeviceDetailsViewState();
}

class _Step2DeviceDetailsViewState extends State<Step2DeviceDetailsView> {
  late final TextEditingController _brandController;
  final FocusNode _brandFocusNode = FocusNode();

  List<String> _brandSuggestions = [];
  bool _showSuggestions = false;

  static const List<String> _allBrands = [
    'Samsung',
    'Apple',
    'Huawei',
    'Xiaomi',
    'Motorola',
    'Nokia',
    'LG',
    'Sony',
    'OnePlus',
    'Oppo',
    'Vivo',
    'Realme',
    'ZTE',
    'Honor',
    'Google Pixel',
    'HTC',
    'Alcatel',
    'BlackBerry',
    'Dell',
    'HP',
    'Lenovo',
    'Asus',
    'Acer',
    'MSI',
    'Toshiba',
    'Compaq',
    'Gateway',
    'Alienware',
    'Razer',
    'Microsoft Surface',
    'Panasonic',
    'Philips',
    'TCL',
    'Hisense',
    'Sharp',
    'Vizio',
    'AOC',
    'ViewSonic',
    'BenQ',
    'Daewoo',
    'Kalley',
    'Challenger',
    'Canon',
    'Nikon',
    'Fujifilm',
    'GoPro',
    'Olympus',
    'JBL',
    'Bose',
    'Harman Kardon',
    'Sennheiser',
    'Nintendo',
    'PlayStation',
    'Xbox',
    'Sega',
    'Atari',
    'Black & Decker',
    'Oster',
    'Hamilton Beach',
    'KitchenAid',
    'Braun',
    'Cuisinart',
    'Moulinex',
    'T-fal',
    'Whirlpool',
    'Electrolux',
    'Mabe',
    'Haceb',
    'Imusa',
    'Epson',
    'Brother',
    'Lexmark',
    'Ricoh',
    'Xerox',
    'Western Digital',
    'Seagate',
    'Kingston',
    'SanDisk',
    'Crucial',
    'Maxtor',
    'Hitachi',
    'TP-Link',
    'Cisco',
    'Netgear',
    'D-Link',
    'Linksys',
    'Ubiquiti',
    'MikroTik',
    'Duracell',
    'Energizer',
    'Varta',
    'GP',
    'Garmin',
    'Fitbit',
    'Dyson',
    'iRobot',
    'Bosch',
    'Makita',
    'DeWalt',
    'Dremel',
  ];

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.brand);
  }

  @override
  void didUpdateWidget(covariant Step2DeviceDetailsView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.brand != _brandController.text && !_brandFocusNode.hasFocus) {
      _brandController.text = widget.brand;
    }
  }

  @override
  void dispose() {
    _brandController.dispose();
    _brandFocusNode.dispose();
    super.dispose();
  }

  List<String> _searchBrands(String query) {
    if (query.isEmpty) return [];

    final q = query.toLowerCase().trim();
    final uniqueBrands = _allBrands.toSet().toList();

    final prefixMatches = uniqueBrands
        .where((brand) => brand.toLowerCase().startsWith(q))
        .toList();

    final containsMatches = uniqueBrands
        .where(
          (brand) =>
              brand.toLowerCase().contains(q) &&
              !brand.toLowerCase().startsWith(q),
        )
        .toList();

    final fuzzyMatches = uniqueBrands.where((brand) {
      final lowerBrand = brand.toLowerCase();

      if (lowerBrand.contains(q) || lowerBrand.startsWith(q)) {
        return false;
      }

      return _fuzzyMatch(q, lowerBrand);
    }).toList();

    return [
      ...prefixMatches,
      ...containsMatches,
      ...fuzzyMatches,
    ].take(8).toList();
  }

  bool _fuzzyMatch(String query, String target) {
    if ((query.length - target.length).abs() > 3) return false;

    int matched = 0;
    int targetIndex = 0;

    for (int i = 0; i < query.length && targetIndex < target.length; i++) {
      for (int j = targetIndex; j < target.length; j++) {
        if (query[i] == target[j]) {
          matched++;
          targetIndex = j + 1;
          break;
        }
      }
    }

    return matched >= (query.length * 0.6).ceil() && query.length >= 2;
  }

  void _onBrandChanged(String value) {
    widget.onBrandChanged(value);

    final suggestions = _searchBrands(value);

    setState(() {
      _brandSuggestions = suggestions;
      _showSuggestions = suggestions.isNotEmpty && value.trim().isNotEmpty;
    });
  }

  void _selectBrand(String brand) {
    _brandController.text = brand;
    widget.onBrandChanged(brand);

    setState(() {
      _showSuggestions = false;
      _brandSuggestions = [];
    });

    _brandFocusNode.unfocus();
  }

  String _conditionLabel(String value) {
    return switch (value) {
      'fully_working' => 'Sí',
      'partially_working' => 'Sí, pero no en su totalidad',
      'not_working' => 'No',
      _ => value,
    };
  }

  String _integrityLabel(String value) {
    return switch (value) {
      'single_piece' => 'Sí',
      'multiple_pieces' => 'No, tiene piezas sueltas',
      _ => value,
    };
  }

  @override
  Widget build(BuildContext context) {
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
                    value: widget.selectedSubcategory,
                    hint: 'Selecciona una opción',
                    items: widget.subcategories,
                    onChanged: widget.onSubcategoryChanged,
                  ),

                  if (widget.isNonRaee) ...[
                    const SizedBox(height: 12),
                    _buildNonRaeeWarning(),
                  ],

                  if (widget.dynamicExtraFieldLabel != null &&
                      widget.dynamicExtraFieldOptions != null) ...[
                    const SizedBox(height: 20),
                    _buildLabel(widget.dynamicExtraFieldLabel!),
                    const SizedBox(height: 8),
                    _buildChipRow(
                      options: widget.dynamicExtraFieldOptions!,
                      selected: widget.selectedDynamicExtra,
                      onSelected: widget.onDynamicExtraChanged,
                    ),
                  ],

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
                    value: widget.estimatedWeight,
                    hint: AppStrings.selectPlaceholder,
                    items: Step2DeviceDetailsView.weightOptions,
                    onChanged: widget.onEstimatedWeightChanged,
                  ),

                  const SizedBox(height: 20),

                  _buildLabelWithIcon(AppStrings.ageLabel, Icons.access_time),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: widget.age,
                    hint: AppStrings.selectPlaceholder,
                    items: Step2DeviceDetailsView.ageOptions,
                    onChanged: widget.onAgeChanged,
                  ),

                  const SizedBox(height: 20),

                  _buildLabel('¿Tiene pantalla?'),
                  const SizedBox(height: 8),
                  _buildYesNoChips(
                    selected: widget.hasScreen,
                    onSelected: widget.onHasScreenChanged,
                  ),

                  if (widget.hasScreen == true) ...[
                    const SizedBox(height: 20),
                    _buildLabel('¿La pantalla está rota?'),
                    const SizedBox(height: 8),
                    _buildYesNoChips(
                      selected: widget.isScreenBroken,
                      onSelected: widget.onScreenBrokenChanged,
                    ),
                  ],

                  const SizedBox(height: 20),

                  _buildLabel(AppStrings.stillWorksLabel),
                  const SizedBox(height: 8),
                  _buildConditionChips(),

                  const SizedBox(height: 20),

                  _buildLabel(AppStrings.onePieceLabel),
                  const SizedBox(height: 8),
                  _buildIntegrityChips(),

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
            onPressed: widget.canContinue ? widget.onContinue : null,
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
                  onTap: () => _selectBrand(brand),
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
          child: _buildSelectableBox(
            label: 'Sí',
            isSelected: selected == true,
            onTap: () => onSelected(selected == true ? null : true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSelectableBox(
            label: 'No',
            isSelected: selected == false,
            onTap: () => onSelected(selected == false ? null : false),
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

  Widget _buildConditionChips() {
    return Row(
      children: Step2DeviceDetailsView.conditionOptions.map((condition) {
        final isSelected = widget.condition == condition;
        final isMiddle = condition == 'partially_working';

        return Expanded(
          flex: isMiddle ? 3 : 1,
          child: Padding(
            padding: EdgeInsets.only(
              right: condition == 'not_working' ? 0 : 8,
              left: condition == 'fully_working' ? 0 : 4,
            ),
            child: _buildSelectableBox(
              label: _conditionLabel(condition),
              isSelected: isSelected,
              onTap: () => widget.onConditionChanged(condition),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIntegrityChips() {
    return Row(
      children: Step2DeviceDetailsView.integrityOptions.map((integrity) {
        final isSelected = widget.integrity == integrity;
        final isFirst = integrity == 'single_piece';

        return Expanded(
          flex: isFirst ? 1 : 3,
          child: Padding(
            padding: EdgeInsets.only(
              right: isFirst ? 8 : 0,
              left: isFirst ? 0 : 4,
            ),
            child: _buildSelectableBox(
              label: _integrityLabel(integrity),
              isSelected: isSelected,
              onTap: () => widget.onIntegrityChanged(integrity),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSelectableBox({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.teal : AppColors.lightTeal,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColors.darkTeal : AppColors.textMain,
          ),
        ),
      ),
    );
  }
}
