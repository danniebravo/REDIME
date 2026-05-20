import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';
import '../core/widgets/help_button.dart';
import '../core/widgets/step_progress_indicator.dart';
import '../features/device_pickup/domain/entities/enums.dart';
import '../features/device_pickup/presentation/viewmodels/pickup_flow_viewmodel.dart';
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

  int _lastStep = 0;
  String? _selectedDeviceTypeId;

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

  void _syncPage(int currentStep) {
    if (currentStep != _lastStep && _pageController.hasClients) {
      _pageController.animateToPage(
        currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _lastStep = currentStep;
    }
  }

  void _handleBack(PickupFlowViewModel vm) {
    if (vm.currentStep > 0) {
      vm.previousStep();
    } else {
      Navigator.of(context).pop();
    }
  }

  String? _deviceTypeToId(DeviceType? type) {
    return switch (type) {
      DeviceType.largeAppliance => 'large_appliance',
      DeviceType.smallAppliance => 'small_appliance',
      DeviceType.telecomEquipment => 'telecom_equipment',
      DeviceType.other => 'other',
      null => null,
    };
  }

  DeviceType? _idToDeviceType(String id) {
    return switch (id) {
      'large_appliance' => DeviceType.largeAppliance,
      'small_appliance' => DeviceType.smallAppliance,
      'telecom_equipment' => DeviceType.telecomEquipment,
      'other' => DeviceType.other,
      _ => null,
    };
  }

  void _selectDeviceType(PickupFlowViewModel vm, String id) {
    final deviceType = _idToDeviceType(id);

    if (deviceType == null) return;

    setState(() {
      _selectedDeviceTypeId = id;
    });

    vm.selectDeviceType(deviceType);
  }

  String? _conditionToId(DeviceCondition? condition) {
    if (condition == null) return null;

    final name = condition.name.toLowerCase();
    final label = condition.displayName.toLowerCase();

    if (name.contains('partial') || label.contains('parcial')) {
      return 'partially_working';
    }

    if (name.contains('not') || label == 'no') {
      return 'not_working';
    }

    return 'fully_working';
  }

  DeviceCondition? _idToCondition(String? id) {
    if (id == null) return null;

    for (final condition in DeviceCondition.values) {
      if (_conditionToId(condition) == id) {
        return condition;
      }
    }

    return null;
  }

  String? _integrityToId(DeviceIntegrity? integrity) {
    if (integrity == null) return null;

    final name = integrity.name.toLowerCase();
    final label = integrity.displayName.toLowerCase();

    if (name.contains('single') || label == 'sí' || label == 'si') {
      return 'single_piece';
    }

    return 'multiple_pieces';
  }

  DeviceIntegrity? _idToIntegrity(String? id) {
    if (id == null) return null;

    for (final integrity in DeviceIntegrity.values) {
      if (_integrityToId(integrity) == id) {
        return integrity;
      }
    }

    return null;
  }

  void _setCondition(PickupFlowViewModel vm, String? id) {
    final condition = _idToCondition(id);

    if (condition == null) return;

    vm.setCondition(condition);
  }

  void _setIntegrity(PickupFlowViewModel vm, String? id) {
    final integrity = _idToIntegrity(id);

    if (integrity == null) return;

    vm.setIntegrity(integrity);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PickupFlowViewModel>();

    _selectedDeviceTypeId ??= _deviceTypeToId(vm.selectedDeviceType);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncPage(vm.currentStep);
    });

    return PopScope(
      canPop: vm.currentStep == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          vm.previousStep();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            _PickupFlowHeader(
              currentStep: vm.currentStep + 1,
              onBack: () => _handleBack(vm),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Step1DeviceTypeView(
                    selectedDeviceType: _selectedDeviceTypeId,
                    onSelectDeviceType: (id) => _selectDeviceType(vm, id),
                    onContinue: vm.canContinueStep1 ? vm.nextStep : () {},
                  ),
                  Step2DeviceDetailsView(
                    selectedSubcategory: vm.selectedSubcategory,
                    subcategories: vm.subcategories,
                    isNonRaee: vm.isNonRaee,
                    dynamicExtraFieldLabel: vm.dynamicExtraFieldLabel,
                    dynamicExtraFieldOptions: vm.dynamicExtraFieldOptions,
                    selectedDynamicExtra: vm.selectedDynamicExtra,
                    brand: vm.brand,
                    estimatedWeight: vm.estimatedWeight,
                    age: vm.age,
                    hasScreen: vm.hasScreen,
                    isScreenBroken: vm.isScreenBroken,
                    condition: _conditionToId(vm.condition),
                    integrity: _integrityToId(vm.integrity),
                    canContinue: vm.canContinueStep2,
                    onSubcategoryChanged: vm.setSubcategory,
                    onDynamicExtraChanged: vm.setDynamicExtra,
                    onBrandChanged: vm.setBrand,
                    onEstimatedWeightChanged: vm.setEstimatedWeight,
                    onAgeChanged: vm.setAge,
                    onHasScreenChanged: vm.setHasScreen,
                    onScreenBrokenChanged: vm.setIsScreenBroken,
                    onConditionChanged: (id) => _setCondition(vm, id),
                    onIntegrityChanged: (id) => _setIntegrity(vm, id),
                    onContinue: vm.nextStep,
                  ),
                  Step3AddressDateView(
                    address: vm.address,
                    pickupDate: vm.pickupDate,
                    canContinue: vm.canContinueStep3,
                    onAddressChanged: vm.setAddress,
                    onPickupDateChanged: vm.setPickupDate,
                    onContinue: vm.nextStep,
                  ),
                  const Step4StoryView(),
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
