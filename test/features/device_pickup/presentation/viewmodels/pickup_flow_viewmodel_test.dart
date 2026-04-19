import 'package:flutter_test/flutter_test.dart';
import 'package:redime/features/device_pickup/data/datasources/pickup_local_datasource.dart';
import 'package:redime/features/device_pickup/data/repositories/pickup_repository_impl.dart';
import 'package:redime/features/device_pickup/domain/entities/enums.dart';
import 'package:redime/features/device_pickup/domain/usecases/submit_pickup_request.dart';
import 'package:redime/features/device_pickup/presentation/viewmodels/pickup_flow_viewmodel.dart';

import '../../../../helpers/db_test_helper.dart';

void main() {
  late PickupFlowViewModel vm;

  setUp(() async {
    await initTestDatabase();
    final ds = PickupLocalDataSource();
    final repo = PickupRepositoryImpl(ds);
    final uc = SubmitPickupRequestUseCase(repo);
    vm = PickupFlowViewModel(submitUseCase: uc);
  });

  tearDown(() async {
    await tearDownTestDatabase();
  });

  group('Step navigation', () {
    test('starts at step 0', () {
      expect(vm.currentStep, 0);
    });

    test('nextStep increments', () {
      vm.nextStep();
      expect(vm.currentStep, 1);
    });

    test('previousStep decrements', () {
      vm.nextStep();
      vm.previousStep();
      expect(vm.currentStep, 0);
    });

    test('cannot go below 0', () {
      vm.previousStep();
      expect(vm.currentStep, 0);
    });

    test('cannot go above 3', () {
      vm.nextStep();
      vm.nextStep();
      vm.nextStep();
      vm.nextStep(); // should stay at 3
      expect(vm.currentStep, 3);
    });
  });

  group('Step 1 validation', () {
    test('canContinueStep1 is false initially', () {
      expect(vm.canContinueStep1, false);
    });

    test('canContinueStep1 is true after selection', () {
      vm.selectDeviceType(DeviceType.largeAppliance);
      expect(vm.canContinueStep1, true);
    });
  });

  group('Step 2 validation', () {
    test('canContinueStep2 is false when fields are empty', () {
      expect(vm.canContinueStep2, false);
    });

    test('canContinueStep2 is true when all fields filled', () {
      vm.setDeviceDescription('Laptop');
      vm.setBrand('Dell');
      vm.setEstimatedWeight('1 - 5 kg');
      vm.setAge('3 - 5 a\u00f1os');
      vm.setCondition(DeviceCondition.fullyWorking);
      vm.setIntegrity(DeviceIntegrity.singlePiece);
      expect(vm.canContinueStep2, true);
    });

    test('canContinueStep2 is false if brand is missing', () {
      vm.setDeviceDescription('Laptop');
      vm.setEstimatedWeight('1 - 5 kg');
      vm.setAge('3 - 5 a\u00f1os');
      vm.setCondition(DeviceCondition.fullyWorking);
      vm.setIntegrity(DeviceIntegrity.singlePiece);
      expect(vm.canContinueStep2, false);
    });
  });

  group('Step 3 validation', () {
    test('canContinueStep3 is false initially', () {
      expect(vm.canContinueStep3, false);
    });

    test('canContinueStep3 is true when address and date set', () {
      vm.setAddress('Calle 10 # 45-20');
      vm.setPickupDate(DateTime(2026, 5, 1));
      expect(vm.canContinueStep3, true);
    });
  });

  group('Submit', () {
    test('submitRequest sets isCompleted to true', () async {
      vm.selectDeviceType(DeviceType.smallAppliance);
      vm.setDeviceDescription('Licuadora');
      vm.setBrand('Oster');
      vm.setEstimatedWeight('1 - 5 kg');
      vm.setAge('1 - 3 a\u00f1os');
      vm.setCondition(DeviceCondition.partiallyWorking);
      vm.setIntegrity(DeviceIntegrity.singlePiece);
      vm.setAddress('Calle 50 # 12-34');
      vm.setPickupDate(DateTime(2026, 5, 15));

      await vm.submitRequest(withStory: false);

      expect(vm.isCompleted, true);
      expect(vm.lastRequest, isNotNull);
      expect(vm.errorMessage, isNull);
    });
  });

  group('Reset', () {
    test('reset clears all state', () {
      vm.selectDeviceType(DeviceType.other);
      vm.nextStep();
      vm.setDeviceDescription('Test');
      vm.reset();

      expect(vm.currentStep, 0);
      expect(vm.selectedDeviceType, isNull);
      expect(vm.deviceDescription, '');
      expect(vm.isCompleted, false);
    });
  });
}
