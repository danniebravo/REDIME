import '../../domain/entities/pickup_request_entity.dart';
import '../../domain/repositories/pickup_repository.dart';
import '../datasources/pickup_local_datasource.dart';
import '../models/pickup_request_model.dart';

class PickupRepositoryImpl implements PickupRepository {
  final PickupLocalDataSource localDataSource;

  const PickupRepositoryImpl(this.localDataSource);

  @override
  Future<PickupRequestEntity> submitPickupRequest(
    PickupRequestEntity request,
  ) async {
    final model = PickupRequestModel.fromEntity(request);
    return await localDataSource.savePickupRequest(model);
  }

  @override
  Future<List<PickupRequestEntity>> getUserPickupRequests() async {
    return await localDataSource.getPickupRequests();
  }
}
