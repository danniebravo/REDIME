import 'package:flutter/foundation.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/pickup_request_entity.dart';
import '../../domain/usecases/submit_pickup_request.dart';

class PickupFlowViewModel extends ChangeNotifier {
  final SubmitPickupRequestUseCase _submitUseCase;

  PickupFlowViewModel({required SubmitPickupRequestUseCase submitUseCase})
      : _submitUseCase = submitUseCase;

  // ─── Step tracking ───
  int _currentStep = 0;
  int get currentStep => _currentStep;

  // ─── Step 1: Device Type ───
  DeviceType? _selectedDeviceType;
  DeviceType? get selectedDeviceType => _selectedDeviceType;

  // ─── Step 2: Device Details ───
  String _deviceDescription = '';
  String get deviceDescription => _deviceDescription;

  String _brand = '';
  String get brand => _brand;

  String? _estimatedWeight;
  String? get estimatedWeight => _estimatedWeight;

  String? _age;
  String? get age => _age;

  DeviceCondition? _condition;
  DeviceCondition? get condition => _condition;

  DeviceIntegrity? _integrity;
  DeviceIntegrity? get integrity => _integrity;

  // ─── Step 3: Address & Date ───
  String _address = '';
  String get address => _address;

  DateTime? _pickupDate;
  DateTime? get pickupDate => _pickupDate;

  // ─── Step 4: Story ───
  String _story = '';
  String get story => _story;

  String? _photoPath;
  String? get photoPath => _photoPath;

  // ─── State flags ───
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ─── Last submitted request ───
  PickupRequestEntity? _lastRequest;
  PickupRequestEntity? get lastRequest => _lastRequest;

  // ─── Computed: can continue per step ───
  bool get canContinueStep1 => _selectedDeviceType != null;

  bool get canContinueStep2 =>
      _deviceDescription.trim().isNotEmpty &&
      _brand.trim().isNotEmpty &&
      _estimatedWeight != null &&
      _age != null &&
      _condition != null &&
      _integrity != null;

  bool get canContinueStep3 =>
      _address.trim().isNotEmpty && _pickupDate != null;

  bool get hasStory => _story.trim().isNotEmpty || _photoPath != null;

  // ─── Step 1 methods ───
  void selectDeviceType(DeviceType type) {
    _selectedDeviceType = type;
    notifyListeners();
  }

  // ─── Step 2 methods ───
  void setDeviceDescription(String value) {
    _deviceDescription = value;
    notifyListeners();
  }

  void setBrand(String value) {
    _brand = value;
    notifyListeners();
  }

  void setEstimatedWeight(String? value) {
    _estimatedWeight = value;
    notifyListeners();
  }

  void setAge(String? value) {
    _age = value;
    notifyListeners();
  }

  void setCondition(DeviceCondition value) {
    _condition = value;
    notifyListeners();
  }

  void setIntegrity(DeviceIntegrity value) {
    _integrity = value;
    notifyListeners();
  }

  // ─── Step 3 methods ───
  void setAddress(String value) {
    _address = value;
    notifyListeners();
  }

  void setPickupDate(DateTime value) {
    _pickupDate = value;
    notifyListeners();
  }

  // ─── Step 4 methods ───
  void setStory(String value) {
    _story = value;
    notifyListeners();
  }

  void setPhotoPath(String? path) {
    _photoPath = path;
    notifyListeners();
  }

  // ─── Navigation ───
  void nextStep() {
    if (_currentStep < 3) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  // ─── Submit ───
  Future<void> submitRequest({bool withStory = true}) async {
    if (_selectedDeviceType == null) return;

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final device = DeviceEntity(
        deviceType: _selectedDeviceType!,
        description: _deviceDescription,
        brand: _brand,
        estimatedWeight: _estimatedWeight ?? '',
        age: _age ?? '',
        condition: _condition ?? DeviceCondition.notWorking,
        integrity: _integrity ?? DeviceIntegrity.singlePiece,
      );

      final hasUserStory = withStory && _story.trim().isNotEmpty;

      final request = PickupRequestEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        device: device,
        deliveryMethod: DeliveryMethod.homePickup,
        processingType: hasUserStory
            ? ProcessingType.commemoration
            : ProcessingType.standardRecycle,
        address: _address,
        pickupDate: _pickupDate ?? DateTime.now(),
        story: withStory && _story.trim().isNotEmpty ? _story : null,
        photoPath: withStory ? _photoPath : null,
        status: TrackingStage.delivery,
        createdAt: DateTime.now(),
      );

      _lastRequest = await _submitUseCase.call(request);
      _isCompleted = true;
    } catch (e) {
      _errorMessage = 'Error al enviar la solicitud: $e';
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // ─── Reset ───
  void reset() {
    _currentStep = 0;
    _selectedDeviceType = null;
    _deviceDescription = '';
    _brand = '';
    _estimatedWeight = null;
    _age = null;
    _condition = null;
    _integrity = null;
    _address = '';
    _pickupDate = null;
    _story = '';
    _photoPath = null;
    _isSubmitting = false;
    _isCompleted = false;
    _errorMessage = null;
    _lastRequest = null;
    notifyListeners();
  }
}
