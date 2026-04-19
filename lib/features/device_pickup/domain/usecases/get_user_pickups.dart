import '../entities/pickup_request_entity.dart';
import '../repositories/pickup_repository.dart';

class GetUserPickupsUseCase {
  final PickupRepository repository;

  const GetUserPickupsUseCase(this.repository);

  Future<List<PickupRequestEntity>> call() {
    return repository.getUserPickupRequests();
  }
}
