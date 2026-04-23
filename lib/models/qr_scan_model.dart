class QrScanModel {
  final String url;
  final String title;
  final String description;

  const QrScanModel({
    required this.url,
    required this.title,
    required this.description,
  });

  // Permite copiar el objeto cambiando solo algunos valores
  QrScanModel copyWith({String? url, String? title, String? description}) {
    return QrScanModel(
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  // Convertir a Map (útil para APIs o base de datos)
  Map<String, dynamic> toMap() {
    return {'url': url, 'title': title, 'description': description};
  }

  // Crear desde Map
  factory QrScanModel.fromMap(Map<String, dynamic> map) {
    return QrScanModel(
      url: map['url'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
