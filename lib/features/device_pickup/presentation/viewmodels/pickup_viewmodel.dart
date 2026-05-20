import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

enum DeviceCategory { none, telecom, others }

enum FunctionalStatus { none, yes, partial, no }

enum IntegrityStatus { none, yes, looseParts }

class RecyclePoint {
  final String id;
  final String address;
  final LatLng location;

  RecyclePoint({
    required this.id,
    required this.address,
    required this.location,
  });
}

class PickupViewModel extends ChangeNotifier {
  // ---------- STEP 1: MAP ----------
  bool isPointSelected = false;
  RecyclePoint? selectedPoint;

  String userAddress = "";
  bool isRouteCalculated = false;

  final List<RecyclePoint> availablePoints = [
    RecyclePoint(
      id: '1',
      address: 'Cl. 33 #42B-06, La Candelaria',
      location: const LatLng(6.2384, -75.5683),
    ),
    RecyclePoint(
      id: '2',
      address: 'La Candelaria, Medellín',
      location: const LatLng(6.2518, -75.5636),
    ),
    RecyclePoint(
      id: '3',
      address: 'Cl. 14a #43d-56, El Poblado',
      location: const LatLng(6.2166, -75.5681),
    ),
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

  void clearRoute() {
    userAddress = '';
    isRouteCalculated = false;
    notifyListeners();
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

  bool? hasScreen;
  bool? isScreenBroken;

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

  String? get dynamicExtraFieldLabel {
    if (selectedSubcategory == 'Laptop') return '¿Incluye batería?';
    if (selectedSubcategory == 'Televisor') return '¿Tipo de pantalla?';
    if (selectedSubcategory == 'Impresora') return '¿Incluye cartuchos?';

    if (selectedSubcategory == 'Dispositivo con pilas/baterías') {
      return '¿Tipo de batería?';
    }

    return null;
  }

  List<String>? get dynamicExtraFieldOptions {
    if (selectedSubcategory == 'Laptop') return ['Sí', 'No'];

    if (selectedSubcategory == 'Televisor') {
      return ['LCD', 'LED', 'OLED', 'CRT (Tubo)', 'No sé'];
    }

    if (selectedSubcategory == 'Impresora') return ['Sí', 'No'];

    if (selectedSubcategory == 'Dispositivo con pilas/baterías') {
      return ['Li-Ion', 'NiMH', 'Plomo', 'Otra', 'No sé'];
    }

    return null;
  }

  String? selectedDynamicExtra;

  static const List<String> nonRaeeItems = [
    'Ropa',
    'Muebles',
    'Alimentos',
    'Pilas sueltas',
    'Bombillos',
    'Medicamentos',
  ];

  bool get isNonRaee {
    if (selectedSubcategory == 'Otro' && brand.toLowerCase().isNotEmpty) {
      return nonRaeeItems.any(
        (item) => brand.toLowerCase().contains(item.toLowerCase()),
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
    'Philips',
    'Cuisinart',
    'Moulinex',
    'T-fal',
    'Whirlpool',
    'Electrolux',
    'Mabe',
    'Haceb',
    'Imusa',
    'HP',
    'Epson',
    'Brother',
    'Canon',
    'Lexmark',
    'Ricoh',
    'Xerox',
    'Western Digital',
    'Seagate',
    'Toshiba',
    'Kingston',
    'SanDisk',
    'Crucial',
    'Samsung',
    'Maxtor',
    'Hitachi',
    'TP-Link',
    'Cisco',
    'Netgear',
    'D-Link',
    'Linksys',
    'Ubiquiti',
    'MikroTik',
    'Huawei',
    'Duracell',
    'Energizer',
    'Panasonic',
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
      isScreenBroken = null;
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
  dynamic storyImageBytes;
  bool storySkipped = false;
  String userName = '';

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
}
