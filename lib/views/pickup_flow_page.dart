import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';
import '../core/widgets/help_button.dart';
import '../core/widgets/step_progress_indicator.dart';
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
  late PageController _pageController;
  int _lastStep = 0;

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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PickupFlowViewModel>();

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
                children: const [
                  Step1DeviceTypeView(),
                  Step2DeviceDetailsView(),
                  Step3AddressDateView(),
                  Step4StoryView(),
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

    // Curva más equilibrada:
    // no tan arriba para no cortar el stepper,
    // no tan abajo para no generar tanto espacio blanco visual.
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
