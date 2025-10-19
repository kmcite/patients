// spark.dart
// ignore_for_file: unintended_html_in_doc_comment

/// -----------------
/// Serializer abstraction
/// -----------------
abstract class Serializer<T> {
  String encode(T value);
  T decode(String raw);
}
