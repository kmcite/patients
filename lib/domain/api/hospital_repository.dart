import 'package:manager/eda/eda.dart';
import 'package:patients/domain/models/hospital.dart';

import '../../main_hmis.dart';

String get _hospitalKey => 'hospital';

final HospitalRepository hospitalRepository = HospitalRepository();

class HospitalRepository extends Service {
  HospitalRepository();
  Hospital get hospital {
    return Hospital.fromJson(prefs.getString(_hospitalKey)) ?? Hospital();
  }

  void setHospital(Hospital hospital) {
    prefs.setString(
      _hospitalKey,
      hospital.toJson(),
    );
  }

  String get name => hospital.name;
  String get info => hospital.info;
  String get city => hospital.city;

  @override
  void handle(Event event) {
    if (event is HospitalNameChangedEvent) {
      setHospital(
        hospital.copyWith(name: event.name),
      );
    } else if (event is HospitalCityChangedEvent) {
      setHospital(
        hospital.copyWith(city: event.city),
      );
    } else if (event is HospitalInfoChangedEvent) {
      setHospital(
        hospital.copyWith(info: event.info),
      );
    }
  }
}

class HospitalNameChangedEvent extends Event {
  final String name;
  HospitalNameChangedEvent(this.name);
}

class HospitalCityChangedEvent extends Event {
  final String city;
  HospitalCityChangedEvent(this.city);
}

class HospitalInfoChangedEvent extends Event {
  final String info;
  HospitalInfoChangedEvent(this.info);
}
