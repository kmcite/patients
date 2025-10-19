// spark.dart
// ignore_for_file: unintended_html_in_doc_comment

import 'dart:convert';
import 'package:patients/utils/services/serializer/serializer.dart';

/// Helper serializer for Model-like classes (that expose toJson())
class ModelSerializer<T> implements Serializer<T> {
  final T Function(Map<String, dynamic>) fromJson;
  ModelSerializer(this.fromJson);

  @override
  String encode(T value) {
    // rely on runtime `toJson()` available on the value (common pattern)
    final jsonObj = (value as dynamic).toJson() as Map<String, dynamic>;
    return jsonEncode(jsonObj);
  }

  @override
  T decode(String raw) => fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
