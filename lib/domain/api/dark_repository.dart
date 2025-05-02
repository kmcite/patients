import '../../main.dart';

class DarkRepository {
  final darkRM = RM.inject<bool>(
    () => true,
    persist: () => PersistState(key: 'dark'),
  );
  bool dark([bool? value]) {
    if (value != null) darkRM.state = value;
    return darkRM.state;
  }
}

final DarkRepository darkRepository = DarkRepository();
