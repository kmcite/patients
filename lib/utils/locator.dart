import 'package:flutter/material.dart';
import 'package:patients/main.dart';

final instances = <Type, ChangeNotifier>{};

T find<T extends ChangeNotifier>([T? instance]) {
  if (instance != null) {
    instances[T] = instance;
  }
  if (instances[T] == null) {
    throw Exception('Instance not found');
  }
  return instances[T] as T;
}

extension OOO on StatelessWidget {
  ThemeModeBloc get themeModeBloc => find();

  Widget O(Widget Function(BuildContext context) builder) {
    return ListenableBuilder(
      listenable: Listenable.merge(instances.values),
      builder: (context, child) => builder(context),
    );
  }
}
