import '../entities/device_status_entity.dart';

/// Abstract contract for device status operations.
/// Implementations can be local/mock or Firebase.
abstract class StatusRepository {
  Future<DeviceStatusEntity> getDeviceStatus(String pickupRequestId);
  Future<List<DeviceStatusEntity>> getAllDeviceStatuses();
}
