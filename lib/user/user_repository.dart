import 'package:patients/main.dart';

class UserRepository {
  late final Injected<User> userRM = RM.injectStream(
    () {
      return Stream.periodic(
        1.seconds,
        (tracker) {
          return setUser(user..tracking = tracker);
          // return userRM.state..tracking = tracker;
        },
      );
    },
    initialState: User(),
  );

  User get user => userRM.state;
  User setUser(User value) {
    userRM
      ..state = value
      ..notify();
    return user;
  }
}

final UserRepository userRepository = UserRepository();
