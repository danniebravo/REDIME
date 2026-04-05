import '../models/pickup_request_model.dart';

/// Local/mock data source for pickup requests.
/// Replace with Firebase datasource later without changing the repository.
class PickupLocalDataSource {
  final List<PickupRequestModel> _requests = [];

  Future<PickupRequestModel> savePickupRequest(
    PickupRequestModel request,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    _requests.add(request);
    return request;
  }

  Future<List<PickupRequestModel>> getPickupRequests() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_requests);
  }
}
