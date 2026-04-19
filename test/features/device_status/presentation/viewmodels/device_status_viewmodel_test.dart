import 'package:flutter_test/flutter_test.dart';
import 'package:redime/core/database/auth_session.dart';
import 'package:redime/core/database/redime_db.dart';
import 'package:redime/features/device_pickup/data/datasources/pickup_local_datasource.dart';
import 'package:redime/features/device_pickup/data/models/device_model.dart';
import 'package:redime/features/device_pickup/data/models/pickup_request_model.dart';
import 'package:redime/features/device_pickup/domain/entities/enums.dart';
import 'package:redime/features/device_status/data/datasources/status_local_datasource.dart';
import 'package:redime/features/device_status/data/repositories/status_repository_impl.dart';
import 'package:redime/features/device_status/domain/usecases/get_device_status.dart';
import 'package:redime/features/device_status/presentation/viewmodels/device_status_viewmodel.dart';

import '../../../../helpers/db_test_helper.dart';

Future<String> _seedSolicitud() async {
  final usuario = await RedimeDb.instance.usuarios.create(
    nombre: 'Test',
    apellido: 'User',
    correo: 'test${DateTime.now().microsecondsSinceEpoch}@redime.co',
    telefono: '3000000000',
    documentoIdentidad: 'DOC${DateTime.now().microsecondsSinceEpoch}',
    password: 'secret',
  );
  AuthSession.instance.setUser(usuario);

  final request = PickupRequestModel(
    id: 'ignored',
    device: const DeviceModel(
      deviceType: DeviceType.smallAppliance,
      description: 'Licuadora',
      brand: 'Oster',
      estimatedWeight: '2.5 kg',
      age: '3',
      condition: DeviceCondition.fullyWorking,
      integrity: DeviceIntegrity.singlePiece,
    ),
    deliveryMethod: DeliveryMethod.homePickup,
    processingType: ProcessingType.commemoration,
    address: 'Calle 10 # 45-20',
    pickupDate: DateTime(2026, 5, 15),
    story: 'Una historia breve sobre este dispositivo.',
    photoPath: null,
    status: TrackingStage.delivery,
    createdAt: DateTime.now(),
  );
  final ds = PickupLocalDataSource();
  final saved = await ds.savePickupRequest(request);
  return saved.id;
}

void main() {
  late DeviceStatusViewModel vm;

  setUp(() async {
    await initTestDatabase();
    final ds = StatusLocalDataSource();
    final repo = StatusRepositoryImpl(ds);
    final uc = GetDeviceStatusUseCase(repo);
    vm = DeviceStatusViewModel(getStatusUseCase: uc);
  });

  tearDown(() async {
    await tearDownTestDatabase();
  });

  test('initial state is empty', () {
    expect(vm.deviceStatus, isNull);
    expect(vm.isLoading, false);
    expect(vm.errorMessage, isNull);
  });

  test('loadStatus returns a seeded solicitud from the database', () async {
    final solicitudId = await _seedSolicitud();

    await vm.loadStatus(solicitudId);

    expect(vm.isLoading, false);
    expect(vm.deviceStatus, isNotNull);
    expect(vm.deviceStatus!.pickupRequestId, solicitudId);
    expect(vm.deviceStatus!.steps.length, 3);
    expect(vm.errorMessage, isNull);
  });

  test('homePickup + commemoration produces commemoration copy', () async {
    final solicitudId = await _seedSolicitud();
    await vm.loadStatus(solicitudId);
    final status = vm.deviceStatus!;

    expect(status.deliveryMethod, DeliveryMethod.homePickup);
    expect(status.processingType, ProcessingType.commemoration);
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
