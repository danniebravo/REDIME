import '../../domain/entities/qr_scan_entity.dart';

class QrScanModel extends QrScanEntity {
  const QrScanModel({
    required super.rawValue,
    required super.title,
    required super.description,
  });

  factory QrScanModel.fromRawValue(String rawValue) {
    return QrScanModel(
      rawValue: rawValue,
      title: 'Código QR detectado',
      description:
          'Este código fue leído correctamente. El enlace o contenido real se conectará más adelante.',
    );
  }

  Map<String, dynamic> toMap() {
    return {'rawValue': rawValue, 'title': title, 'description': description};
  }

  factory QrScanModel.fromMap(Map<String, dynamic> map) {
    return QrScanModel(
      rawValue: map['rawValue'] ?? '',
      title: map['title'] ?? 'Código QR detectado',
      description: map['description'] ?? '',
    );
  }
}
