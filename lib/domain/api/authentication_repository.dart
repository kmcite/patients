import 'package:patients/domain/models/authentication.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

final authentictaionRM = RM.inject(() => Authentication());
set authentication(Authentication authentication) {
  authentictaionRM
    ..state = authentication
    ..notify();
}

Authentication get authentication => authentictaionRM.state;

bool get authenticated => authentictaionRM.state.authenticated;
