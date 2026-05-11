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

  String? _selectedSubcategory;
  String? get selectedSubcategory => _selectedSubcategory;

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

  bool? _hasScreen;
  bool? get hasScreen => _hasScreen;

  bool? _isScreenBroken;
  bool? get isScreenBroken => _isScreenBroken;

  String? _selectedDynamicExtra;
  String? get selectedDynamicExtra => _selectedDynamicExtra;

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

  // ─── Dynamic subcategories ───
  List<String> get subcategories {
    switch (_selectedDeviceType) {
      case DeviceType.telecomEquipment:
        return [
          'Celular',
          'Laptop',
          'Tablet',
          'Router / Modem',
          'Teléfono fijo',
          'Cámara',
          'Disco duro',
          'Consola de videojuegos',
          'Dispositivo con pilas/baterías',
        ];

      case DeviceType.largeAppliance:
      case DeviceType.smallAppliance:
      case DeviceType.other:
        return [
          'Televisor',
          'Impresora',
          'Electrodoméstico pequeño',
          'Cámara',
          'Disco duro',
          'Consola de videojuegos',
          'Dispositivo con pilas/baterías',
          'Otro',
        ];

      case null:
        return [];
    }
  }

  String? get dynamicExtraFieldLabel {
    if (_selectedSubcategory == 'Laptop') return '¿Incluye batería?';
    if (_selectedSubcategory == 'Televisor') return '¿Tipo de pantalla?';
    if (_selectedSubcategory == 'Impresora') return '¿Incluye cartuchos?';
    if (_selectedSubcategory == 'Dispositivo con pilas/baterías') {
      return '¿Tipo de batería?';
    }
    return null;
  }

  List<String>? get dynamicExtraFieldOptions {
    if (_selectedSubcategory == 'Laptop') return ['Sí', 'No'];
    if (_selectedSubcategory == 'Televisor') {
      return ['LCD', 'LED', 'OLED', 'CRT (Tubo)', 'No sé'];
    }
    if (_selectedSubcategory == 'Impresora') return ['Sí', 'No'];
    if (_selectedSubcategory == 'Dispositivo con pilas/baterías') {
      return ['Li-Ion', 'NiMH', 'Plomo', 'Otra', 'No sé'];
    }
    return null;
  }

  static const List<String> nonRaeeItems = [
    'Ropa',
    'Muebles',
    'Alimentos',
    'Pilas sueltas',
    'Bombillos',
    'Medicamentos',
  ];

  bool get isNonRaee {
    if (_selectedSubcategory == 'Otro' && _brand.toLowerCase().isNotEmpty) {
      return nonRaeeItems.any(
        (item) => _brand.toLowerCase().contains(item.toLowerCase()),
      );
    }
    return false;
  }

  static const List<String> weightOptions = [
    'Menos de 1 kg',
    '1 - 5 kg',
    '5 - 15 kg',
    '15 - 30 kg',
    'Más de 30 kg',
  ];

  static const List<String> ageOptions = [
    'Menos de 1 año',
    '1 - 3 años',
    '3 - 5 años',
    '5 - 10 años',
    'Más de 10 años',
  ];

  static const List<String> allBrands = [
    'Samsung',
    'Apple',
    'Huawei',
    'Xiaomi',
    'Motorola',
    'Nokia',
    'LG',
    'Sony',
    'OnePlus',
    'Oppo',
    'Vivo',
    'Realme',
    'ZTE',
    'Honor',
    'Google Pixel',
    'HTC',
    'Alcatel',
    'BlackBerry',
    'Dell',
    'HP',
    'Lenovo',
    'Asus',
    'Acer',
    'MSI',
    'Toshiba',
    'Compaq',
    'Gateway',
    'Alienware',
    'Razer',
    'Microsoft Surface',
    'Panasonic',
    'Philips',
    'TCL',
    'Hisense',
    'Sharp',
    'Vizio',
    'AOC',
    'ViewSonic',
    'BenQ',
    'Daewoo',
    'Kalley',
    'Challenger',
    'Canon',
    'Nikon',
    'Fujifilm',
    'GoPro',
    'Olympus',
    'JBL',
    'Bose',
    'Harman Kardon',
    'Sennheiser',
    'Nintendo',
    'PlayStation',
    'Xbox',
    'Sega',
    'Atari',
    'Black & Decker',
    'Oster',
    'Hamilton Beach',
    'KitchenAid',
    'Braun',
    'Cuisinart',
    'Moulinex',
    'T-fal',
    'Whirlpool',
    'Electrolux',
    'Mabe',
    'Haceb',
    'Imusa',
    'Epson',
    'Brother',
    'Lexmark',
    'Ricoh',
    'Xerox',
    'Western Digital',
    'Seagate',
    'Kingston',
    'SanDisk',
    'Crucial',
    'Maxtor',
    'Hitachi',
    'TP-Link',
    'Cisco',
    'Netgear',
    'D-Link',
    'Linksys',
    'Ubiquiti',
    'MikroTik',
    'Duracell',
    'Energizer',
    'Varta',
    'GP',
    'Garmin',
    'Fitbit',
    'Dyson',
    'iRobot',
    'Bosch',
    'Makita',
    'DeWalt',
    'Dremel',
  ];

  List<String> searchBrands(String query) {
    if (query.isEmpty) return [];

    final q = query.toLowerCase().trim();
    final uniqueBrands = allBrands.toSet().toList();

    final prefixMatches = uniqueBrands
        .where((brand) => brand.toLowerCase().startsWith(q))
        .toList();

    final containsMatches = uniqueBrands
        .where(
          (brand) =>
              brand.toLowerCase().contains(q) &&
              !brand.toLowerCase().startsWith(q),
        )
        .toList();

    final fuzzyMatches = uniqueBrands.where((brand) {
      final lowerBrand = brand.toLowerCase();

      if (lowerBrand.contains(q) || lowerBrand.startsWith(q)) {
        return false;
      }

      return _fuzzyMatch(q, lowerBrand);
    }).toList();

    return [
      ...prefixMatches,
      ...containsMatches,
      ...fuzzyMatches,
    ].take(8).toList();
  }

  bool _fuzzyMatch(String query, String target) {
    if ((query.length - target.length).abs() > 3) return false;

    int matched = 0;
    int targetIndex = 0;

    for (int i = 0; i < query.length && targetIndex < target.length; i++) {
      for (int j = targetIndex; j < target.length; j++) {
        if (query[i] == target[j]) {
          matched++;
          targetIndex = j + 1;
          break;
        }
      }
    }

    return matched >= (query.length * 0.6).ceil() && query.length >= 2;
  }

  // ─── Computed: can continue per step ───
  bool get canContinueStep1 => _selectedDeviceType != null;

  bool get canContinueStep2 =>
      _selectedSubcategory != null &&
      _brand.trim().isNotEmpty &&
      _estimatedWeight != null &&
      _age != null &&
      _condition != null &&
      _integrity != null &&
      _hasScreen != null &&
      !isNonRaee;

  bool get canContinueStep3 =>
      _address.trim().isNotEmpty && _pickupDate != null;

  bool get hasStory => _story.trim().isNotEmpty || _photoPath != null;

  // ─── Step 1 methods ───
  void selectDeviceType(DeviceType type) {
    _selectedDeviceType = type;

    _selectedSubcategory = null;
    _deviceDescription = '';
    _brand = '';
    _estimatedWeight = null;
    _age = null;
    _condition = null;
    _integrity = null;
    _hasScreen = null;
    _isScreenBroken = null;
    _selectedDynamicExtra = null;

    notifyListeners();
  }

  // ─── Step 2 methods ───
  void setDeviceDescription(String value) {
    _deviceDescription = value;
    notifyListeners();
  }

  void setSubcategory(String? value) {
    _selectedSubcategory = value;
    _deviceDescription = value ?? '';
    _selectedDynamicExtra = null;
    _hasScreen = null;
    _isScreenBroken = null;
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

  void setDynamicExtra(String? value) {
    _selectedDynamicExtra = value;
    notifyListeners();
  }

  void setHasScreen(bool? value) {
    _hasScreen = value;

    if (value == false) {
      _isScreenBroken = null;
    }

    notifyListeners();
  }

  void setIsScreenBroken(bool? value) {
    _isScreenBroken = value;
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
        description: _selectedSubcategory ?? _deviceDescription,
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
    _selectedSubcategory = null;
    _brand = '';
    _estimatedWeight = null;
    _age = null;
    _condition = null;
    _integrity = null;
    _hasScreen = null;
    _isScreenBroken = null;
    _selectedDynamicExtra = null;

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
