import 'package:patients/utils/architecture.dart';
import 'package:patients/utils/crud.dart';

import '../models/patient.dart';
import '../models/patient_types.dart';

class PatientTypesRepository extends Repository<PatientType>
    with CRUD<PatientType> {}

class PatientsRepository extends Repository<Patient> with CRUD<Patient> {
  Iterable<Patient> searchByEmail(String email) {
    return getAll().where(
      (pt) {
        return pt.email == email;
      },
    );
  }

  Iterable<Patient> searchByName(String name) {
    return getAll().where(
      (pt) {
        return pt.name.contains(name);
      },
    );
  }
}
