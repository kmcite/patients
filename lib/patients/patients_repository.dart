import '../main.dart';
import 'patient.dart';

class PatientsRepository with CRUD<Patient> {}

final PatientsRepository patientsRepository = PatientsRepository();
