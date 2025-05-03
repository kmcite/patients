import 'package:patients/domain/models/hospital.dart';
import 'package:patients/main.dart';

final HospitalRepository hospitalRepository = HospitalRepository();

class HospitalRepository extends Repository<Hospital> {
  @override
  Hospital get initialState => Hospital();
}
