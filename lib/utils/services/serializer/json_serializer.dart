// spark.dart
// ignore_for_file: unintended_html_in_doc_comment

import 'dart:convert';
import 'package:patients/utils/services/serializer/serializer.dart';

/// Primitive/json-structure serializer: the `fromDecoded` converts jsonDecode -> T
class JsonSerializer<T> implements Serializer<T> {
  final T Function(dynamic decoded) fromDecoded;
  JsonSerializer(this.fromDecoded);
  @override
  String encode(T value) => jsonEncode(value);
  @override
  T decode(String raw) => fromDecoded(jsonDecode(raw));
}
