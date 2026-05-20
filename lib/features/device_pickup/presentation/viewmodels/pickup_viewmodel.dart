import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../../models/pickup_model.dart';
import '../../../../services/pickup_service.dart';

enum DeviceCategory { none, telecom, others }

enum FunctionalStatus { none, yes, partial, no }

enum IntegrityStatus { none, yes, looseParts }

class RecyclePoint {
  final String id;
  final String address;
  final LatLng location;

  RecyclePoint({required this.id, required this.address, required this.location});
}

class PickupViewModel extends ChangeNotifier {
  PickupViewModel({PickupService? pickupService})
      : _pickupService = pickupService ?? PickupService();

  final PickupService _pickupService;

  // ---------- STEP 1: MAP ----------
  bool isPointSelected = false;
  RecyclePoint? selectedPoint;
  
  String userAddress = "";
  bool isRouteCalculated = false;

  final List<RecyclePoint> availablePoints = [
    RecyclePoint(id: '1', address: 'Cl. 33 #42B-06, La Candelaria', location: const LatLng(6.2384, -75.5683)),
    RecyclePoint(id: '2', address: 'La Candelaria, Medellín', location: const LatLng(6.2518, -75.5636)),
    RecyclePoint(id: '3', address: 'Cl. 14a #43d-56, El Poblado', location: const LatLng(6.2166, -75.5681)),
  ];

  void setUserAddress(String address) {
    userAddress = address;
    if (selectedPoint != null && isRouteCalculated) {
      notifyListeners();
    }
  }

  void calculateRoute() {
    if (userAddress.isNotEmpty) {
       isRouteCalculated = true;
       notifyListeners();
    }
  }

  void selectPoint(RecyclePoint point) {
    selectedPoint = point;
    isPointSelected = true;
    isRouteCalculated = false;
    notifyListeners();
  }

  void deselectPoint() {
    selectedPoint = null;
    isPointSelected = false;
    isRouteCalculated = false;
    notifyListeners();
  }

  // ---------- STEP 2: DEVICE TYPE ----------
  DeviceCategory selectedCategory = DeviceCategory.none;

  void setCategory(DeviceCategory category) {
    selectedCategory = category;
    selectedSubcategory = null;
    brand = '';
    selectedWeight = null;
    selectedAge = null;
    functionalStatus = FunctionalStatus.none;
    integrityStatus = IntegrityStatus.none;
    hasScreen = null;
    isScreenBroken = null;
    selectedDynamicExtra = null;
    notifyListeners();
  }

  // ---------- STEP 3: DEVICE DETAILS ----------
  String? selectedSubcategory;
  String brand = '';
  String? selectedWeight;
  String? selectedAge;
  FunctionalStatus functionalStatus = FunctionalStatus.none;
  IntegrityStatus integrityStatus = IntegrityStatus.none;

  // Screen conditional fields
  bool? hasScreen;       // null = not answered, true = yes, false = no
  bool? isScreenBroken;  // null = not answered

  // Subcategories based on selected category (HU-18: dynamic subcategories)
  List<String> get subcategories {
    if (selectedCategory == DeviceCategory.telecom) {
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
    } else if (selectedCategory == DeviceCategory.others) {
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
    }
    return [];
  }

  // Dynamic extra fields per subcategory (HU-18: dynamic form)
  String? get dynamicExtraFieldLabel {
    if (selectedSubcategory == 'Laptop') return '¿Incluye batería?';
    if (selectedSubcategory == 'Televisor') return '¿Tipo de pantalla?';
    if (selectedSubcategory == 'Impresora') return '¿Incluye cartuchos?';
    if (selectedSubcategory == 'Dispositivo con pilas/baterías') return '¿Tipo de batería?';
    return null;
  }

  List<String>? get dynamicExtraFieldOptions {
    if (selectedSubcategory == 'Laptop') return ['Sí', 'No'];
    if (selectedSubcategory == 'Televisor') return ['LCD', 'LED', 'OLED', 'CRT (Tubo)', 'No sé'];
    if (selectedSubcategory == 'Impresora') return ['Sí', 'No'];
    if (selectedSubcategory == 'Dispositivo con pilas/baterías') return ['Li-Ion', 'NiMH', 'Plomo', 'Otra', 'No sé'];
    return null;
  }

  String? selectedDynamicExtra;

  // Non-RAEE validation list (HU-18: object not allowed)
  static const List<String> nonRaeeItems = [
    'Ropa', 'Muebles', 'Alimentos', 'Pilas sueltas', 'Bombillos', 'Medicamentos',
  ];

  bool get isNonRaee {
    if (selectedSubcategory == 'Otro' && brand.toLowerCase().isNotEmpty) {
      return nonRaeeItems.any((item) => brand.toLowerCase().contains(item.toLowerCase()));
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

  // ---- Comprehensive RAEE brands list with fuzzy matching ----
  static const List<String> allBrands = [
    // Celulares / Tablets
    'Samsung', 'Apple', 'Huawei', 'Xiaomi', 'Motorola', 'Nokia',
    'LG', 'Sony', 'OnePlus', 'Oppo', 'Vivo', 'Realme', 'ZTE',
    'Honor', 'Google Pixel', 'HTC', 'Alcatel', 'BlackBerry',
    // Laptops / PC
    'Dell', 'HP', 'Lenovo', 'Asus', 'Acer', 'MSI', 'Toshiba',
    'Compaq', 'Gateway', 'Alienware', 'Razer', 'Microsoft Surface',
    // Televisores / Monitores
    'LG', 'Samsung', 'Sony', 'Panasonic', 'Philips', 'TCL',
    'Hisense', 'Sharp', 'Vizio', 'AOC', 'ViewSonic', 'BenQ',
    'Daewoo', 'Kalley', 'Challenger',
    // Audiovisual / Cámaras
    'Canon', 'Nikon', 'Sony', 'Fujifilm', 'GoPro', 'Olympus',
    'Panasonic', 'JBL', 'Bose', 'Harman Kardon', 'Sennheiser',
    // Consolas de videojuegos
    'Nintendo', 'PlayStation', 'Xbox', 'Sega', 'Atari',
    // Electrodomésticos pequeños
    'Black & Decker', 'Oster', 'Hamilton Beach', 'KitchenAid',
    'Braun', 'Philips', 'Cuisinart', 'Moulinex', 'T-fal',
    'Whirlpool', 'Electrolux', 'Mabe', 'Haceb', 'Imusa',
    // Impresoras
    'HP', 'Epson', 'Brother', 'Canon', 'Lexmark', 'Ricoh', 'Xerox',
    // Discos duros / Almacenamiento
    'Western Digital', 'Seagate', 'Toshiba', 'Kingston', 'SanDisk',
    'Crucial', 'Samsung', 'Maxtor', 'Hitachi',
    // Redes / Router
    'TP-Link', 'Cisco', 'Netgear', 'D-Link', 'Linksys', 'Ubiquiti',
    'MikroTik', 'Huawei',
    // Pilas / Baterías
    'Duracell', 'Energizer', 'Panasonic', 'Varta', 'GP',
    // Otros
    'Garmin', 'Fitbit', 'Dyson', 'iRobot', 'Bosch',
    'Makita', 'DeWalt', 'Dremel',
  ];

  /// Fuzzy brand search: tolerates typos using Levenshtein-like matching
  List<String> searchBrands(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase().trim();
    
    // Remove duplicates from the master list
    final uniqueBrands = allBrands.toSet().toList();
    
    // First: exact prefix matches
    final prefixMatches = uniqueBrands
        .where((b) => b.toLowerCase().startsWith(q))
        .toList();
    
    // Second: contains matches
    final containsMatches = uniqueBrands
        .where((b) => b.toLowerCase().contains(q) && !b.toLowerCase().startsWith(q))
        .toList();
    
    // Third: fuzzy matches (tolerate 1-2 character differences)
    final fuzzyMatches = uniqueBrands
        .where((b) {
          if (b.toLowerCase().contains(q) || b.toLowerCase().startsWith(q)) return false;
          return _fuzzyMatch(q, b.toLowerCase());
        })
        .toList();
    
    return [...prefixMatches, ...containsMatches, ...fuzzyMatches].take(8).toList();
  }

  /// Simple fuzzy matching: checks if strings are within edit distance of 2
  bool _fuzzyMatch(String query, String target) {
    if ((query.length - target.length).abs() > 3) return false;
    
    // Check if most characters of query appear in target in order
    int matched = 0;
    int targetIdx = 0;
    for (int i = 0; i < query.length && targetIdx < target.length; i++) {
      for (int j = targetIdx; j < target.length; j++) {
        if (query[i] == target[j]) {
          matched++;
          targetIdx = j + 1;
          break;
        }
      }
    }
    // At least 60% of the query characters must match in order
    return matched >= (query.length * 0.6).ceil() && query.length >= 2;
  }

  void setSubcategory(String? value) {
    selectedSubcategory = value;
    selectedDynamicExtra = null;
    hasScreen = null;
    isScreenBroken = null;
    notifyListeners();
  }

  void setBrand(String value) {
    brand = value;
    notifyListeners();
  }

  void setWeight(String? value) {
    selectedWeight = value;
    notifyListeners();
  }

  void setAge(String? value) {
    selectedAge = value;
    notifyListeners();
  }

  void setFunctionalStatus(FunctionalStatus status) {
    functionalStatus = status;
    notifyListeners();
  }

  void setIntegrityStatus(IntegrityStatus status) {
    integrityStatus = status;
    notifyListeners();
  }

  void setDynamicExtra(String? value) {
    selectedDynamicExtra = value;
    notifyListeners();
  }

  void setHasScreen(bool? value) {
    hasScreen = value;
    if (value == false) {
      isScreenBroken = null; // Reset screen broken if no screen
    }
    notifyListeners();
  }

  void setIsScreenBroken(bool? value) {
    isScreenBroken = value;
    notifyListeners();
  }

  bool get isStep3Valid {
    return selectedSubcategory != null &&
        brand.isNotEmpty &&
        selectedWeight != null &&
        selectedAge != null &&
        functionalStatus != FunctionalStatus.none &&
        integrityStatus != IntegrityStatus.none &&
        hasScreen != null &&
        !isNonRaee;
  }

  // ---------- STEP 4: STORY ----------
  String storyText = '';
  String? storyImagePath;
  dynamic storyImageBytes; // Uint8List passed from Step 4
  bool storySkipped = false;
  String userName = ''; // Placeholder: will be filled when auth is integrated

  void setStoryText(String value) {
    storyText = value;
    notifyListeners();
  }

  void setStoryImage(String? path) {
    storyImagePath = path;
    notifyListeners();
  }

  void setStoryImageBytes(dynamic bytes) {
    storyImageBytes = bytes;
  }

  void skipStory() {
    storySkipped = true;
    storyText = '';
    storyImagePath = null;
    storyImageBytes = null;
    notifyListeners();
  }

  void submitStory() {
    storySkipped = false;
    notifyListeners();
  }

  bool get canSubmitStory {
    return storyText.trim().isNotEmpty;
  }

  // ---------- SUBMIT TO BACKEND ----------
  bool isSubmitting = false;
  String? submitError;
  bool isSubmitted = false;

  String? _functionalLabel() {
    switch (functionalStatus) {
      case FunctionalStatus.yes:
        return 'Sí';
      case FunctionalStatus.partial:
        return 'Parcial';
      case FunctionalStatus.no:
        return 'No';
      case FunctionalStatus.none:
        return null;
    }
  }

  String? _integrityLabel() {
    switch (integrityStatus) {
      case IntegrityStatus.yes:
        return 'Sí';
      case IntegrityStatus.looseParts:
        return 'No';
      case IntegrityStatus.none:
        return null;
    }
  }

  String? _deviceTypeLabel() {
    switch (selectedCategory) {
      case DeviceCategory.telecom:
        return 'telecom';
      case DeviceCategory.others:
        return 'others';
      case DeviceCategory.none:
        return null;
    }
  }

  Future<bool> submit() async {
    if (isSubmitting) return false;
    isSubmitting = true;
    submitError = null;
    notifyListeners();

    try {
      final addr = userAddress.trim().isNotEmpty
          ? userAddress.trim()
          : selectedPoint?.address;

      final pickup = PickupModel(
        deviceType: _deviceTypeLabel(),
        subcategory: selectedSubcategory,
        brand: brand.trim().isEmpty ? null : brand.trim(),
        estimatedWeight: selectedWeight,
        age: selectedAge,
        condition: _functionalLabel(),
        integrity: _integrityLabel(),
        hasScreen: hasScreen,
        isScreenBroken: isScreenBroken,
        dynamicExtra: selectedDynamicExtra,
        address: addr,
        story: storySkipped || storyText.trim().isEmpty ? null : storyText.trim(),
        photoPath: storyImagePath,
        status: 'En proceso',
        source: 'pickup-flow',
      );

      await _pickupService.createPickup(pickup);
      isSubmitted = true;
      return true;
    } catch (e) {
      submitError = e.toString().replaceFirst('Exception: ', '');
      debugPrint('[PickupViewModel.submit] error: $submitError');
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
