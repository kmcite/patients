// spark.dart
// ignore_for_file: unintended_html_in_doc_comment

import 'dart:convert';

import 'package:patients/utils/services/serializer/serializer.dart';

/// List serializer built from an item serializer
Serializer<List<T>> listSerializer<T>(Serializer<T> itemSerializer) =>
    _ListSerializer(itemSerializer);

class _ListSerializer<T> implements Serializer<List<T>> {
  final Serializer<T> itemSerializer;
  _ListSerializer(this.itemSerializer);

  @override
  String encode(List<T> value) {
    final jsonList =
        value.map((e) => jsonDecode(itemSerializer.encode(e))).toList();
    return jsonEncode(jsonList);
  }

  @override
  List<T> decode(String raw) {
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((entry) => itemSerializer.decode(jsonEncode(entry)))
        .toList();
  }
}
