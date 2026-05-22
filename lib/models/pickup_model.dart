class PickupModel {
  final int? id;
  final int? userId;
  final String? deviceType;
  final String? subcategory;
  final String? brand;
  final String? estimatedWeight;
  final String? age;
  final String? condition;
  final String? integrity;
  final bool? hasScreen;
  final bool? isScreenBroken;
  final String? dynamicExtra;
  final String? address;
  final DateTime? pickupDate;
  final String? story;
  final String? photoPath;
  final String? status;
  final String? source;
  final DateTime? createdAt;

  PickupModel({
    this.id,
    this.userId,
    this.deviceType,
    this.subcategory,
    this.brand,
    this.estimatedWeight,
    this.age,
    this.condition,
    this.integrity,
    this.hasScreen,
    this.isScreenBroken,
    this.dynamicExtra,
    this.address,
    this.pickupDate,
    this.story,
    this.photoPath,
    this.status,
    this.source,
    this.createdAt,
  });

  factory PickupModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      final s = v.toString();
      if (s.isEmpty) return null;
      return DateTime.tryParse(s);
    }

    return PickupModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      deviceType: json['device_type'] as String?,
      subcategory: json['subcategory'] as String?,
      brand: json['brand'] as String?,
      estimatedWeight: json['estimated_weight'] as String?,
      age: json['age'] as String?,
      condition: json['condition'] as String?,
      integrity: json['integrity'] as String?,
      hasScreen: json['has_screen'] as bool?,
      isScreenBroken: json['is_screen_broken'] as bool?,
      dynamicExtra: json['dynamic_extra'] as String?,
      address: json['address'] as String?,
      pickupDate: parseDate(json['pickup_date']),
      story: json['story'] as String?,
      photoPath: json['photo_path'] as String?,
      status: json['status'] as String?,
      source: json['source'] as String?,
      createdAt: parseDate(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_type': deviceType,
      'subcategory': subcategory,
      'brand': brand,
      'estimated_weight': estimatedWeight,
      'age': age,
      'condition': condition,
      'integrity': integrity,
      'has_screen': hasScreen,
      'is_screen_broken': isScreenBroken,
      'dynamic_extra': dynamicExtra,
      'address': address,
      'pickup_date': pickupDate?.toIso8601String().substring(0, 10),
      'story': story,
      'photo_path': photoPath,
      'status': status,
      'source': source,
    };
  }

  String get dispositivoLabel {
    final parts = <String>[];
    if (brand != null && brand!.trim().isNotEmpty) parts.add(brand!.trim());
    if (subcategory != null && subcategory!.trim().isNotEmpty) {
      parts.add(subcategory!.trim());
    }
    if (parts.isEmpty && deviceType != null && deviceType!.trim().isNotEmpty) {
      parts.add(deviceType!.trim());
    }
    return parts.isEmpty ? 'Dispositivo' : parts.join(' ');
  }

  String get estadoLabel {
    if (status != null && status!.trim().isNotEmpty) return status!.trim();
    return 'En proceso';
  }

  String get fechaLabel {
    final d = createdAt ?? pickupDate;
    if (d == null) return '';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString().padLeft(4, '0');
    return '$dd/$mm/$yyyy';
  }

  List<Map<String, dynamic>> get trackingSteps {
    final s = (status ?? '').toLowerCase().trim();
    final isFullyDone = s.contains('complet') || s.contains('finaliz');

    int currentIdx;
    if (isFullyDone) {
      currentIdx = -1;
    } else if (s.contains('recib') && !s.contains('solicitud')) {
      currentIdx = 2;
    } else if (s.contains('transit') || s.contains('camino')) {
      currentIdx = 1;
    } else {
      currentIdx = 0;
    }

    String fmt(DateTime? d) {
      if (d == null) return '';
      final dd = d.day.toString().padLeft(2, '0');
      final mm = d.month.toString().padLeft(2, '0');
      final yyyy = d.year.toString().padLeft(4, '0');
      return '$dd/$mm/$yyyy';
    }

    bool completed(int i) =>
        isFullyDone || (currentIdx >= 0 && i < currentIdx);
    bool current(int i) => !isFullyDone && i == currentIdx;

    final createdLabel = fmt(createdAt);

    return [
      {
        'title': 'Solicitud recibida',
        'subtitle': 'Hemos recibido tu solicitud',
        'isCompleted': completed(0),
        'isCurrent': current(0),
        'completedAt': completed(0) ? createdLabel : null,
      },
      {
        'title': 'Dispositivo en tránsito',
        'subtitle': 'El dispositivo va en camino',
        'isCompleted': completed(1),
        'isCurrent': current(1),
        'completedAt': null,
      },
      {
        'title': 'Dispositivo recibido',
        'subtitle': 'Ya llegó a nuestras instalaciones',
        'isCompleted': completed(2),
        'isCurrent': current(2),
        'completedAt': null,
      },
      {
        'title': 'Proceso completado',
        'subtitle': 'Finalizado correctamente',
        'isCompleted': completed(3),
        'isCurrent': current(3),
        'completedAt': null,
      },
    ];
  }

  String get sourceLabel {
    final src = (source ?? '').toLowerCase();
    if (src.contains('punto') || src.contains('reciclaje')) {
      return 'Punto de reciclaje';
    }
    return 'Entrega a domicilio';
  }
}
