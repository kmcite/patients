import 'package:patients/domain/api/user_repository.dart';
import 'package:patients/main.dart';

class SettingsRepository extends Repository {
  var themeModeToggler = Toggler(ThemeMode.values);
  bool get dark => themeModeToggler() == ThemeMode.dark ? true : false;

  String clinicName = 'Adn Opd';

  void toggle() {
    themeModeToggler = themeModeToggler..next();
    notifyListeners();
  }

  void setThemeMode(ThemeMode value) {
    themeModeToggler.value = value;
    notifyListeners();
  }

  void setClinicName(String value) {
    clinicName = value;
    notifyListeners();
  }
}
