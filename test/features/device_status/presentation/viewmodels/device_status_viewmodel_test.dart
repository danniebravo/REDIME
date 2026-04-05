import 'package:flutter_test/flutter_test.dart';
import 'package:redime/features/device_pickup/domain/entities/enums.dart';
import 'package:redime/features/device_status/data/datasources/status_local_datasource.dart';
import 'package:redime/features/device_status/data/repositories/status_repository_impl.dart';
import 'package:redime/features/device_status/domain/usecases/get_device_status.dart';
import 'package:redime/features/device_status/presentation/viewmodels/device_status_viewmodel.dart';

void main() {
  late DeviceStatusViewModel vm;

  setUp(() {
    final ds = StatusLocalDataSource();
    final repo = StatusRepositoryImpl(ds);
    final uc = GetDeviceStatusUseCase(repo);
    vm = DeviceStatusViewModel(getStatusUseCase: uc);
  });

  test('initial state is empty', () {
    expect(vm.deviceStatus, isNull);
    expect(vm.isLoading, false);
    expect(vm.errorMessage, isNull);
  });

  test('loadStatus sets deviceStatus from mock', () async {
    await vm.loadStatus('mock-001');

    expect(vm.isLoading, false);
    expect(vm.deviceStatus, isNotNull);
    expect(vm.deviceStatus!.pickupRequestId, 'mock-001');
    expect(vm.deviceStatus!.steps.length, 3);
    expect(vm.errorMessage, isNull);
  });

  test('buildDisplaySteps generates correct titles for homePickup + commemoration', () async {
    await vm.loadStatus('mock-001');
    final status = vm.deviceStatus!;
    final steps = DeviceStatusViewModel.buildDisplaySteps(status);

    expect(steps[0].title, 'Yendo a recogerlo');
    expect(steps[1].title, 'Extrayendo memorias');
    expect(steps[2].title, 'Ahora es una memoria viviente');
  });

  group('getStepTitle covers all combinations', () {
    test('delivery + homePickup', () {
      expect(
        DeviceStatusViewModel.getStepTitle(
          stage: TrackingStage.delivery,
          deliveryMethod: DeliveryMethod.homePickup,
          processingType: ProcessingType.standardRecycle,
        ),
        'Yendo a recogerlo',
      );
    });

    test('delivery + dropOffPoint', () {
      expect(
        DeviceStatusViewModel.getStepTitle(
          stage: TrackingStage.delivery,
          deliveryMethod: DeliveryMethod.dropOffPoint,
          processingType: ProcessingType.standardRecycle,
        ),
        'Depositado',
      );
    });

    test('processing + standardRecycle', () {
      expect(
        DeviceStatusViewModel.getStepTitle(
          stage: TrackingStage.processing,
          deliveryMethod: DeliveryMethod.homePickup,
          processingType: ProcessingType.standardRecycle,
        ),
        'A punto de darle una nueva vida',
      );
    });

    test('processing + commemoration', () {
      expect(
        DeviceStatusViewModel.getStepTitle(
          stage: TrackingStage.processing,
          deliveryMethod: DeliveryMethod.homePickup,
          processingType: ProcessingType.commemoration,
        ),
        'Extrayendo memorias',
      );
    });

    test('completed + standardRecycle', () {
      expect(
        DeviceStatusViewModel.getStepTitle(
          stage: TrackingStage.completed,
          deliveryMethod: DeliveryMethod.homePickup,
          processingType: ProcessingType.standardRecycle,
        ),
        'Ahora es parte de algo mejor',
      );
    });

    test('completed + commemoration', () {
      expect(
        DeviceStatusViewModel.getStepTitle(
          stage: TrackingStage.completed,
          deliveryMethod: DeliveryMethod.homePickup,
          processingType: ProcessingType.commemoration,
        ),
        'Ahora es una memoria viviente',
      );
    });
  });
}
