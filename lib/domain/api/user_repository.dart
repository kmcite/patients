import 'dart:async';

import 'package:patients/main.dart';

class UserRepository {
  User _user = User();
  final controller = StreamController<User>.broadcast();
  UserRepository() {
    controller.add(_user);
    timer = Timer.periodic(
      1.seconds,
      (timer) {
        updateUser(_user);
      },
    );
  }
  void updateUser(User user) {
    _user = user;
    controller.add(_user);
  }

  Timer? timer;

  User user([User? value]) {
    if (value != null) {
      updateUser(value);
    }
    return _user;
  }

  Stream<User> call() => controller.stream;
  Future<void> dispose() async {
    await controller.close();
    timer?.cancel();
  }
}

final userRepository = UserRepository();
