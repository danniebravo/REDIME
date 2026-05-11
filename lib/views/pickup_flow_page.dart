import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/widgets/redime_app_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PickupFlowViewModel>();

    // Sync PageView with ViewModel step
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
        appBar: RedimeAppBar(
          onBack: () {
            if (vm.currentStep > 0) {
              vm.previousStep();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        body: Column(
          children: [
            // Step progress indicator
            StepProgressIndicator(
              currentStep: vm.currentStep + 1,
              totalSteps: 4,
            ),

            // Step content
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
