import 'package:patients/domain/models/hospital.dart';
import 'package:patients/main.dart';

final HospitalRepository hospitalRepository = HospitalRepository();

class HospitalRepository extends Repository {
  Hospital hospital = Hospital();
  Hospital call([Hospital? hosp]) {
    if (hosp != null) {
      hospital = hosp;
      notifyListeners();
    }
    return hospital;
  }
}
