import '../../main.dart';
import '../models/patient.dart';

final patientsRepository = PatientsRepository();

class PatientsRepository extends CRUD<Patient> {}
