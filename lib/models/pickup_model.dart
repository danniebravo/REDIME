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
}
