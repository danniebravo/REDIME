import '../entities/pickup_request_entity.dart';
import '../repositories/pickup_repository.dart';

class SubmitPickupRequestUseCase {
  final PickupRepository repository;

  const SubmitPickupRequestUseCase(this.repository);

  Future<PickupRequestEntity> call(PickupRequestEntity request) {
    return repository.submitPickupRequest(request);
  }
}
