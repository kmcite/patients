import 'dart:convert';

import 'package:patients/utils/services/serializer/serializer.dart';

// ignore: unintended_html_in_doc_comment
/// Map<String, V> serializer (keys must be stringable)
Serializer<Map<String, V>> mapSerializer<V>(Serializer<V> valueSerializer) =>
    _MapSerializer(valueSerializer);

class _MapSerializer<V> implements Serializer<Map<String, V>> {
  final Serializer<V> valueSerializer;
  _MapSerializer(this.valueSerializer);

  @override
  String encode(Map<String, V> value) {
    final jsonMap = <String, dynamic>{};
    value.forEach((k, v) {
      jsonMap[k] = jsonDecode(valueSerializer.encode(v));
    });
    return jsonEncode(jsonMap);
  }

  @override
  Map<String, V> decode(String raw) {
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final out = <String, V>{};
    decoded.forEach((k, v) {
      out[k] = valueSerializer.decode(jsonEncode(v));
    });
    return out;
  }
}
