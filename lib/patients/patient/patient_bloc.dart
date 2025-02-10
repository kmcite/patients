import 'package:file_picker/file_picker.dart';
import 'package:patients/patients/patient.dart';
import 'package:patients/patients/patients_repository.dart';
import 'package:patients/pictures/picture.dart';

class PatientBloc {
  final int id;
  PatientBloc(this.id);
  Patient? get() => patientsRepository.get(id);
  void set(Patient patient) => patientsRepository.put(patient);

  bool get editing => get()?.editing ?? false;

  void pickAndAddImageToThePatient() async {
    final picked = await FilePicker.platform.pickFiles();
    final path = picked?.files.first.path;
    if (path != null) {
      final patient = get()!;
      final picture = Picture()..path = path;
      patient.pictures.add(picture);
      set(patient);
    }
  }
}
