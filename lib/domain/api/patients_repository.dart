import 'package:patients/utils/architecture.dart';
import 'package:patients/utils/crud.dart';
import '../models/patient.dart';
import '../models/patient_types.dart';

class PatientTypesRepository extends CrudRepository<PatientType> {
  // All CRUD functionality is inherited from CrudRepository
  // items Resource<List<PatientType>> is available for UI binding

  void addPatientType(PatientType type) {
    put(type); // Uses CRUD functionality
  }

  void removePatientType(PatientType type) {
    remove(type); // Uses CRUD functionality
  }

  // Convenient getter for UI
  Resource<List<PatientType>> get patientTypes => items;
}

class PatientsRepository extends CrudRepository<Patient> {
  // All CRUD functionality is inherited from CrudRepository
  // items Resource<List<Patient>> is available for UI binding

  void addPatient(Patient patient) {
    put(patient); // Uses CRUD functionality
  }

  void removePatient(Patient patient) {
    remove(patient); // Uses CRUD functionality
  }

  Iterable<Patient> searchByEmail(String email) {
    return getAll().where((pt) => pt.email == email);
  }

  Iterable<Patient> searchByName(String name) {
    return getAll().where((pt) => pt.name.contains(name));
  }

  // Convenient getter for UI
  Resource<List<Patient>> get patients => items;
}
