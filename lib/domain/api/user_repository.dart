import 'dart:async';

import 'package:patients/main.dart';

class UserRepository {
  UserRepository() {
    timer = Timer.periodic(
      1.seconds,
      (timer) {
        userRM.state = user();
      },
    );
  }
  Timer? timer;

  final userRM = RM.inject(() => User());

  User user([User? value]) {
    return userRM.state;
  }
}

final userRepository = UserRepository();
