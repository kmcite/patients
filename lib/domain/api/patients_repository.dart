import '../../main.dart';
import '../models/patient.dart';
import '../models/patient_types.dart';

final patientsRepository = PatientsRepository();
final patientTypesRepository = PatientTypesRepository();

class PatientTypesRepository extends CRUD<PatientType> {}

class PatientsRepository extends CRUD<Patient> {
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
