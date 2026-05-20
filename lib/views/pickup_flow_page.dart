import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';
import '../core/widgets/help_button.dart';
import '../core/widgets/step_progress_indicator.dart';
import 'step1_device_type_view.dart';
import 'step2_device_details_view.dart';
import 'step3_address_date_view.dart';
import 'step4_story_view.dart';

class PickupFlowPage extends StatefulWidget {
  const PickupFlowPage({super.key});

  @override
  State<PickupFlowPage> createState() => _PickupFlowPageState();
}

class _PickupFlowPageState extends State<PickupFlowPage> {
  late final PageController _pageController;

  int _currentStep = 0;
  int _lastStep = 0;

  String? _selectedDeviceTypeId;

  String? _selectedSubcategory;
  String? _selectedDynamicExtra;
  String _brand = '';
  String? _estimatedWeight;
  String? _age;
  bool? _hasScreen;
  bool? _isScreenBroken;
  String? _condition;
  String? _integrity;

  String _address = '';
  DateTime? _pickupDate;

  String _story = '';
  String? _photoPath;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> get _subcategories {
    switch (_selectedDeviceTypeId) {
      case 'telecom_equipment':
        return [
          'Celular',
          'Laptop',
          'Tablet',
          'Router / Modem',
          'Teléfono fijo',
          'Cámara',
          'Disco duro',
          'Consola de videojuegos',
          'Dispositivo con pilas/baterías',
        ];

      case 'large_appliance':
      case 'small_appliance':
      case 'other':
        return [
          'Televisor',
          'Impresora',
          'Electrodoméstico pequeño',
          'Cámara',
          'Disco duro',
          'Consola de videojuegos',
          'Dispositivo con pilas/baterías',
          'Otro',
        ];

      default:
        return [];
    }
  }

  String? get _dynamicExtraFieldLabel {
    if (_selectedSubcategory == 'Laptop') return '¿Incluye batería?';
    if (_selectedSubcategory == 'Televisor') return '¿Tipo de pantalla?';
    if (_selectedSubcategory == 'Impresora') return '¿Incluye cartuchos?';

    if (_selectedSubcategory == 'Dispositivo con pilas/baterías') {
      return '¿Tipo de batería?';
    }

    return null;
  }

  List<String>? get _dynamicExtraFieldOptions {
    if (_selectedSubcategory == 'Laptop') return ['Sí', 'No'];

    if (_selectedSubcategory == 'Televisor') {
      return ['LCD', 'LED', 'OLED', 'CRT (Tubo)', 'No sé'];
    }

    if (_selectedSubcategory == 'Impresora') return ['Sí', 'No'];

    if (_selectedSubcategory == 'Dispositivo con pilas/baterías') {
      return ['Li-Ion', 'NiMH', 'Plomo', 'Otra', 'No sé'];
    }

    return null;
  }

  bool get _isNonRaee {
    const nonRaeeItems = [
      'Ropa',
      'Muebles',
      'Alimentos',
      'Pilas sueltas',
      'Bombillos',
      'Medicamentos',
    ];

    if (_selectedSubcategory == 'Otro' && _brand.toLowerCase().isNotEmpty) {
      return nonRaeeItems.any(
        (item) => _brand.toLowerCase().contains(item.toLowerCase()),
      );
    }

    return false;
  }

  bool get _canContinueStep1 => _selectedDeviceTypeId != null;

  bool get _canContinueStep2 {
    return _selectedSubcategory != null &&
        _brand.trim().isNotEmpty &&
        _estimatedWeight != null &&
        _age != null &&
        _condition != null &&
        _integrity != null &&
        _hasScreen != null &&
        !_isNonRaee;
  }

  bool get _canContinueStep3 {
    return _address.trim().isNotEmpty && _pickupDate != null;
  }

  bool get _hasStory {
    return _story.trim().isNotEmpty || _photoPath != null;
  }

  void _syncPage() {
    if (_currentStep != _lastStep && _pageController.hasClients) {
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      _lastStep = _currentStep;
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _handleBack() {
    if (_currentStep > 0) {
      _previousStep();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _selectDeviceType(String id) {
    setState(() {
      _selectedDeviceTypeId = id;

      _selectedSubcategory = null;
      _selectedDynamicExtra = null;
      _brand = '';
      _estimatedWeight = null;
      _age = null;
      _hasScreen = null;
      _isScreenBroken = null;
      _condition = null;
      _integrity = null;
    });
  }

  void _setSubcategory(String? value) {
    setState(() {
      _selectedSubcategory = value;
      _selectedDynamicExtra = null;
      _hasScreen = null;
      _isScreenBroken = null;
    });
  }

  void _setDynamicExtra(String? value) {
    setState(() {
      _selectedDynamicExtra = value;
    });
  }

  void _setBrand(String value) {
    setState(() {
      _brand = value;
    });
  }

  void _setEstimatedWeight(String? value) {
    setState(() {
      _estimatedWeight = value;
    });
  }

  void _setAge(String? value) {
    setState(() {
      _age = value;
    });
  }

  void _setHasScreen(bool? value) {
    setState(() {
      _hasScreen = value;

      if (value == false) {
        _isScreenBroken = null;
      }
    });
  }

  void _setScreenBroken(bool? value) {
    setState(() {
      _isScreenBroken = value;
    });
  }

  void _setCondition(String? value) {
    setState(() {
      _condition = value;
    });
  }

  void _setIntegrity(String? value) {
    setState(() {
      _integrity = value;
    });
  }

  void _setAddress(String value) {
    setState(() {
      _address = value;
    });
  }

  void _setPickupDate(DateTime value) {
    setState(() {
      _pickupDate = value;
    });
  }

  void _setStory(String value) {
    setState(() {
      _story = value;
    });
  }

  void _setPhotoPath(String? value) {
    setState(() {
      _photoPath = value;
    });
  }

  Future<void> _submitRequest({required bool withStory}) async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.pushNamed(
        context,
        AppRoutes.pickupConfirmation,
        arguments: {'hasStory': withStory && _hasStory},
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al enviar la solicitud: $error';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncPage();
    });

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _previousStep();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            _PickupFlowHeader(
              currentStep: _currentStep + 1,
              onBack: _handleBack,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Step1DeviceTypeView(
                    selectedDeviceType: _selectedDeviceTypeId,
                    onSelectDeviceType: _selectDeviceType,
                    onContinue: _canContinueStep1 ? _nextStep : () {},
                  ),
                  Step2DeviceDetailsView(
                    selectedSubcategory: _selectedSubcategory,
                    subcategories: _subcategories,
                    isNonRaee: _isNonRaee,
                    dynamicExtraFieldLabel: _dynamicExtraFieldLabel,
                    dynamicExtraFieldOptions: _dynamicExtraFieldOptions,
                    selectedDynamicExtra: _selectedDynamicExtra,
                    brand: _brand,
                    estimatedWeight: _estimatedWeight,
                    age: _age,
                    hasScreen: _hasScreen,
                    isScreenBroken: _isScreenBroken,
                    condition: _condition,
                    integrity: _integrity,
                    canContinue: _canContinueStep2,
                    onSubcategoryChanged: _setSubcategory,
                    onDynamicExtraChanged: _setDynamicExtra,
                    onBrandChanged: _setBrand,
                    onEstimatedWeightChanged: _setEstimatedWeight,
                    onAgeChanged: _setAge,
                    onHasScreenChanged: _setHasScreen,
                    onScreenBrokenChanged: _setScreenBroken,
                    onConditionChanged: _setCondition,
                    onIntegrityChanged: _setIntegrity,
                    onContinue: _nextStep,
                  ),
                  Step3AddressDateView(
                    address: _address,
                    pickupDate: _pickupDate,
                    canContinue: _canContinueStep3,
                    onAddressChanged: _setAddress,
                    onPickupDateChanged: _setPickupDate,
                    onContinue: _nextStep,
                  ),
                  Step4StoryView(
                    story: _story,
                    photoPath: _photoPath,
                    isSubmitting: _isSubmitting,
                    errorMessage: _errorMessage,
                    onStoryChanged: _setStory,
                    onPhotoPathChanged: _setPhotoPath,
                    onFinishWithoutStory: () {
                      return _submitRequest(withStory: false);
                    },
                    onFinishWithStory: () {
                      return _submitRequest(withStory: true);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickupFlowHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 38);

    path.quadraticBezierTo(
      size.width / 2,
      size.height - 2,
      size.width,
      size.height - 38,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _PickupFlowHeader extends StatelessWidget {
  final int currentStep;
  final VoidCallback onBack;

  const _PickupFlowHeader({required this.currentStep, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _PickupFlowHeaderClipper(),
      child: Container(
        width: double.infinity,
        color: AppColors.primaryTeal,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 44,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: onBack,
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'REDIME',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 2,
                        child: HelpButton(
                          size: 40,
                          iconSize: 20,
                          borderWidth: 2,
                          color: AppColors.white,
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.chat);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                StepProgressIndicator(currentStep: currentStep, totalSteps: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
