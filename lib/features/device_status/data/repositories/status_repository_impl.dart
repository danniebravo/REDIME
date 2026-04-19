import '../../domain/entities/device_status_entity.dart';
import '../../domain/repositories/status_repository.dart';
import '../datasources/status_local_datasource.dart';

class StatusRepositoryImpl implements StatusRepository {
  final StatusLocalDataSource localDataSource;

  const StatusRepositoryImpl(this.localDataSource);

  @override
  Future<DeviceStatusEntity> getDeviceStatus(String pickupRequestId) {
    return localDataSource.getDeviceStatus(pickupRequestId);
  }

  @override
  Future<List<DeviceStatusEntity>> getAllDeviceStatuses() {
    return localDataSource.getAllDeviceStatuses();
  }
}
