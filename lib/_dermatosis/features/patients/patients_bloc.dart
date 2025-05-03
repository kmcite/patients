import 'package:patients/_dermatosis/domain/api/patients_repository.dart';
import 'package:patients/_dermatosis/domain/models/patient.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

final patientsBloc = PatientsBloc();

class PatientsBloc {
  PatientsRepository get _patientsRepository => patientsRepository;

  late final patientsRM = RM.injectStream(
    () => _patientsRepository.watch(),
    initialState: _patientsRepository.getAll(),
  );
  List<Patient> get patients => patientsRM.state;
  void put(Patient patient) {
    // this modifiedOn is used in recently modified feature
    // _patientsRepository.put(
    // patient.copyWith()
    // patient..modifiedOn = DateTime.now());

    // patientsRM.stateAsync = _patientsRepository.getAllAsync();
  }

  void remove(int id) {
    _patientsRepository.remove(id);
    // patientsRM.stateAsync = _patientsRepository.getAllAsync();
  }

  void removeAll() {
    // _patientsRepository.removeAll();
    // patientsRM.stateAsync = _patientsRepository.getAllAsync();
  }

  // ignore: unrelated_type_equality_checks
  Patient get(String id) => patients.firstWhere((patient) => patient.id == id);
}
