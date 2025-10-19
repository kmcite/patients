import 'package:patients/models/user.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/utils/services/repository.dart';

@singleton
class UserRepository extends Repository<User> {
  @override
  final initialState = User();
  // var user = User();
  var showDurationInToggler = Toggler(ShowDurationIn.values);

  void toggleShowDurationIn() {
    update(value..showDurationIn = showDurationInToggler.next());
  }

  void setJobStartedOn(DateTime selected) {
    update(value..jobStartedOn = selected);
  }

  void setShowDurationIn(ShowDurationIn show) {
    update(value..showDurationIn = show);
  }

  void setName(String name) {
    update(value..name = name);
  }

  ShowDurationIn get showDurationIn => showDurationInToggler();
}

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
