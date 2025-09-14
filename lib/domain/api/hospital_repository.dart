import 'package:patients/domain/models/hospital.dart';
import 'package:patients/utils/hive.dart';

class HospitalRepository extends HiveRepository<Hospital> {
  Hospital hospital = Hospital();
  Hospital call([Hospital? hosp]) {
    if (hosp != null) {
      hospital = hosp;
      notifyListeners();
    }
    return hospital;
  }
}
