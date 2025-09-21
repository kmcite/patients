import 'package:patients/utils/architecture.dart';
import 'package:injectable/injectable.dart';

@singleton
class HospitalRepository extends Repository {
  String name = 'Emergency and Trauma Center';
  String city = 'Dhaka';
  String info = 'Emergency and Trauma Center';
  void onNameChanged(String name) {
    this.name = name;
    notifyListeners();
  }

  void onCityChanged(String city) {
    this.city = city;
    notifyListeners();
  }

  void onInfoChanged(String info) {
    this.info = info;
    notifyListeners();
  }
}
