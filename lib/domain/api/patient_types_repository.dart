import 'package:manager/manager.dart';
import 'package:patients/domain/models/patient_types.dart';

final patientTypesRepository = PatientTypesRepository();

class PatientTypesRepository extends CRUD<PatientType> {}
