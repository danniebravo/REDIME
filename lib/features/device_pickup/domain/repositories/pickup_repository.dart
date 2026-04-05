import '../entities/pickup_request_entity.dart';

/// Abstract contract for pickup data operations.
/// Implementations can be local/mock or Firebase.
abstract class PickupRepository {
  Future<PickupRequestEntity> submitPickupRequest(PickupRequestEntity request);
  Future<List<PickupRequestEntity>> getUserPickupRequests();
}
