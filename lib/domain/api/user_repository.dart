import 'package:patients/main.dart';

class UserRepository extends Repository {
  UserRepository();
  var user = User();
  var showDurationInToggler = Toggler(ShowDurationIn.values);

  void toggleShowDurationIn() {
    showDurationInToggler = showDurationInToggler..next();
    notifyListeners();
  }

  void setJobStartedOn(DateTime selected) {
    user.jobStartedOn = selected;
    notifyListeners();
  }

  void setShowDurationIn(ShowDurationIn show) {
    user.showDurationIn = show;
    notifyListeners();
  }

  void setName(String name) {
    user.name = name;
    notifyListeners();
  }

  ShowDurationIn get showDurationIn => showDurationInToggler();
}

final userRepository = UserRepository();

class Toggler<T> {
  final List<T> _values;
  int _index;

  Toggler(List<T> values, {T? start})
      : assert(values.isNotEmpty, 'Values list cannot be empty'),
        _values = List.unmodifiable(values),
        _index = start != null ? values.indexOf(start) : 0 {
    if (_index == -1) {
      throw ArgumentError('Start value not found in values list');
    }
  }
  T get value => _values[_index];
  set value(T value) {
    _index = _values.indexOf(value);
  }

  /// Current value without advancing
  T call() => _values[_index];

  /// Advances to the next value (wraps around)
  T next() {
    _index = (_index + 1) % _values.length;
    return call();
  }
}
