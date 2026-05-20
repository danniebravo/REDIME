class UserModel {
  final int id;
  final String usuario;
  final String name;

  UserModel({required this.id, required this.usuario, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _parseInt(json['id']),
      usuario: _parseString(
        json['usuario'] ?? json['email'] ?? json['username'],
      ),
      name: _parseString(json['name'] ?? json['nombre'] ?? json['fullName']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'usuario': usuario, 'name': name};
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}
