import 'package:flutter/foundation.dart';
import '../../../device_pickup/domain/entities/enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/device_status_entity.dart';
import '../../domain/entities/tracking_step_entity.dart';
import '../../domain/usecases/get_device_status.dart';

class DeviceStatusViewModel extends ChangeNotifier {
  final GetDeviceStatusUseCase _getStatusUseCase;

  DeviceStatusViewModel({required GetDeviceStatusUseCase getStatusUseCase})
      : _getStatusUseCase = getStatusUseCase;

  DeviceStatusEntity? _deviceStatus;
  DeviceStatusEntity? get deviceStatus => _deviceStatus;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadStatus(String pickupRequestId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _deviceStatus = await _getStatusUseCase.call(pickupRequestId);
    } catch (e) {
      _errorMessage = 'Error al cargar el estado: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Generates the tracking step title based on domain logic.
  /// This ensures the UI never hardcodes tracking text.
  static String getStepTitle({
    required TrackingStage stage,
    required DeliveryMethod deliveryMethod,
    required ProcessingType processingType,
  }) {
    switch (stage) {
      case TrackingStage.delivery:
        return deliveryMethod == DeliveryMethod.homePickup
            ? AppStrings.trackingDeliveryPickup
            : AppStrings.trackingDeliveryDropOff;
      case TrackingStage.processing:
        return processingType == ProcessingType.commemoration
            ? AppStrings.trackingProcessingCommemoration
            : AppStrings.trackingProcessingRecycle;
      case TrackingStage.completed:
        return processingType == ProcessingType.commemoration
            ? AppStrings.trackingCompletedCommemoration
            : AppStrings.trackingCompletedRecycle;
    }
  }

  /// Builds the 3 tracking steps with correct text variants
  /// from a DeviceStatusEntity.
  static List<TrackingStepEntity> buildDisplaySteps(
    DeviceStatusEntity status,
  ) {
    return status.steps.map((step) {
      final derivedTitle = getStepTitle(
        stage: step.stage,
        deliveryMethod: status.deliveryMethod,
        processingType: status.processingType,
      );
      return step.copyWith(title: derivedTitle);
    }).toList();
  }
}
