import '../../main.dart';
import '../models/patient.dart';
import '../models/patient_types.dart';

final patientsRepository = PatientsRepository();
final patientTypesRepository = PatientTypesRepository();

class PatientTypesRepository extends CRUD<PatientType> {}

class PatientsRepository extends CRUD<Patient> {}
