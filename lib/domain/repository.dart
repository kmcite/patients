import 'dart:async';

abstract class Repository<T> {
  final controller = StreamController<T>.broadcast();
  Stream<T> call() => controller.stream;
}
