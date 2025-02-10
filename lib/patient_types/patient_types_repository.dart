import 'package:patients/main.dart';
import 'package:patients/patient_types/patient_types.dart';

class PatientTypesRepository with CRUD<PatientType> {}

final patientTypesRepository = PatientTypesRepository();
