import 'package:patients/domain/api/patients.dart';
import 'package:patients/main.dart';

class PatientsBloc with ChangeNotifier {
  PatientsRepository get patientsRepository => context.of();

  final BuildContext context;
  PatientsBloc(this.context);

  late List<Patient> patients = patientsRepository.getAll();

  void put(Patient p) {
    patientsRepository.put(p);
    patients = patientsRepository.getAll();
    notifyListeners();
  }

  Patient get(int id) => patients.where((p) => p.id == id).first;
}
