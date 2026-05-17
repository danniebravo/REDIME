import 'package:flutter/material.dart';
import '../core/widgets/redime_app_bar.dart';
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

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _syncPage();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _syncPage();
    }
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _previousStep();
        }
      },
      child: Scaffold(
        appBar: RedimeAppBar(
          onBack: () {
            if (_currentStep > 0) {
              _previousStep();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        body: Column(
          children: [
            StepProgressIndicator(currentStep: _currentStep + 1, totalSteps: 4),

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

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: const Text('Atrás'),
                      ),
                    ),

                  if (_currentStep > 0) const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: _currentStep < 3 ? _nextStep : () {},
                      child: Text(_currentStep < 3 ? 'Continuar' : 'Finalizar'),
                    ),
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
