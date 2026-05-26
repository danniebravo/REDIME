import '../entities/pickup_request_entity.dart';

class SubmitPickupRequestUseCase {
  Future<PickupRequestEntity> call(PickupRequestEntity request) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return request;
  }
}
