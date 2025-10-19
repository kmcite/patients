// spark.dart
// ignore_for_file: unintended_html_in_doc_comment

import 'package:patients/utils/services/serializer/serializer.dart';

/// Enum serializer: encode by name, decode using provided fromName
class EnumSerializer<E extends Enum> implements Serializer<E> {
  final E Function(int? index) fromIndex;
  EnumSerializer(this.fromIndex);
  @override
  String encode(E value) => value.index.toString();
  @override
  E decode(String raw) => fromIndex(int.tryParse(raw));
}
