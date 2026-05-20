import 'package:flutter/foundation.dart';

import '../models/pickup_model.dart';
import '../services/pickup_service.dart';

class PickupListViewModel extends ChangeNotifier {
  final PickupService _service;

  PickupListViewModel({PickupService? service})
      : _service = service ?? PickupService();

  List<PickupModel> pickups = const [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadMine() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      pickups = await _service.getMyPickups();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('[PickupListViewModel.loadMine] error: $errorMessage');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<PickupModel?> submit(PickupModel pickup) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final created = await _service.createPickup(pickup);
      pickups = [created, ...pickups];
      return created;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('[PickupListViewModel.submit] error: $errorMessage');
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
