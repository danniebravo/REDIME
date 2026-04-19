import '../entities/device_status_entity.dart';
import '../repositories/status_repository.dart';

class GetDeviceStatusUseCase {
  final StatusRepository repository;

  const GetDeviceStatusUseCase(this.repository);

  Future<DeviceStatusEntity> call(String pickupRequestId) {
    return repository.getDeviceStatus(pickupRequestId);
  }
}
