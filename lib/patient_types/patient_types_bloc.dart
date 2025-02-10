import 'package:patients/patient_types/patient_types.dart';

import 'patient_types_repository.dart';

class PatientTypesBloc {
  List<PatientType> get patientTypes => patientTypesRepository.getAll();
  late final put = patientTypesRepository.put;
  late final remove = patientTypesRepository.remove;
}

final patientTypesBloc = PatientTypesBloc();
