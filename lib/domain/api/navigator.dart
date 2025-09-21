import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:navigation_builder/navigation_builder.dart';

@singleton
class Navigation {
  final navigator = NavigationBuilder.navigate;
  GlobalKey<NavigatorState> get key => navigator.navigatorKey;
  late final to = navigator.to;
  late final toReplacementNamed = navigator.toReplacementNamed;
  late final back = navigator.back;
  late final toAndRemoveUntil = navigator.toAndRemoveUntil;
  late final toDialog = navigator.toDialog;
}
