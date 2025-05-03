import 'package:patients/main.dart';

class Hospital extends Model {
  final String name;
  final String city;
  final String info;
  Hospital({
    this.name = '',
    this.city = '',
    this.info = '',
  });

  static fromJson(String? string) {
    if (string == null || string.isEmpty) {
      return Hospital();
    }
    final Map<String, dynamic> json = jsonDecode(string);
    return Hospital(
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      info: json['info'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'city': city,
      'info': info,
    };
    return json;
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

  @override
  int id = 0;
}
