import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/main.dart';

final patientsBloc = PatientsBloc();

class PatientsBloc with ChangeNotifier {
  PatientsBloc();

  late List<Patient> patients = patientsRepository.getAll();

  void put(Patient p) {
    patientsRepository.put(p);
    patients = patientsRepository.getAll();
    notifyListeners();
  }

  Patient get(int id) => patients.where((p) => p.id == id).first;
}
