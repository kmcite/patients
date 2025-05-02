import 'dart:convert';

class Hospital {
  final String name;
  final String city;
  final String info;
  const Hospital({
    this.name = '',
    this.city = '',
    this.info = '',
  });

  static fromJson(String? string) {
    if (string == null || string.isEmpty) {
      return const Hospital();
    }
    final Map<String, dynamic> json = jsonDecode(string);
    return Hospital(
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      info: json['info'] ?? '',
    );
  }

  String toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'city': city,
      'info': info,
    };
    return jsonEncode(json);
  }

  Hospital copyWith({
    String? name,
    String? city,
    String? info,
  }) {
    return Hospital(
      name: name ?? this.name,
      city: city ?? this.city,
      info: info ?? this.info,
    );
  }
}
