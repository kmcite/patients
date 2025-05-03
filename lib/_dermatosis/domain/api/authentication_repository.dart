import 'package:patients/_dermatosis/domain/models/authentication.dart';

import '../../main.dart';

class AuthenticationRepository {
  final authenticationRM = RM.inject(
    () => Authentication(),
  );

  // void logout() {
  //   authentication(Authentication());
  // }

  // void login(Authentication auth) {
  //   authentication(auth);
  // }

  Authentication authentication([Authentication? auth]) {
    if (auth != null) {
      authenticationRM
        ..state = auth
        ..notify();
    }
    return authenticationRM.state;
  }

  bool get authenticated => authentication().authenticated;
}

final authenticationRepository = AuthenticationRepository();
