import 'package:patients/domain/models/hospital.dart';
import 'package:patients/utils/architecture.dart';

class HospitalRepository extends Repository {
  Hospital hospital = Hospital();

  Hospital call([Hospital? hosp]) {
    if (hosp != null) {
      hospital = hosp;
      notifyListeners();
    }
    return hospital;
  }

  void updateHospital(Hospital newHospital) {
    hospital = newHospital;
    notifyListeners();
  }
}
