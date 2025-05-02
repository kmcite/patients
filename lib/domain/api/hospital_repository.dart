import 'package:patients/domain/repository.dart';
import 'package:patients/domain/models/hospital.dart';
import 'package:patients/main.dart';

String get _hospitalKey => 'hospital';

final HospitalRepository hospitalRepository = HospitalRepository();

class HospitalRepository extends Repository<Hospital> {
  HospitalRepository() {
    controller.add(hospital);
  }
  Hospital get hospital {
    return Hospital.fromJson(prefs.getString(_hospitalKey)) ?? Hospital();
  }

  void setHospital(Hospital hospital) {
    prefs.setString(
      _hospitalKey,
      hospital.toJson(),
    );
    controller.add(hospital);
  }

  String get name => hospital.name;
  String get info => hospital.info;
  String get city => hospital.city;
}

// class HospitalNameChangedEvent extends Event {
//   final String name;
//   HospitalNameChangedEvent(this.name);
// }

// class HospitalCityChangedEvent extends Event {
//   final String city;
//   HospitalCityChangedEvent(this.city);
// }

// class HospitalInfoChangedEvent extends Event {
//   final String info;
//   HospitalInfoChangedEvent(this.info);
// }
