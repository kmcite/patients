import 'package:patients/main.dart';

/// [RM.navigate] is the data source & repository and
/// is SSOT for navigation in this app.
class NavigationBloc {
  final navigator = RM.navigate;
  GlobalKey<NavigatorState> get key => navigator.navigatorKey;
  late final to = navigator.to;
  late final back = navigator.back;
  late final dialog = navigator.toDialog;
  void toFromDrawer(Widget page) {
    back();
    to(page);
  }
}

/// [navigator] is [NavigationBloc] & can be used in UI
final NavigationBloc navigator = NavigationBloc();
