import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/ui/patients/inherited_patient.dart';
import 'package:patients/ui/patients/patient_tile.dart';
import 'package:patients/ui/patients/sort_and_filter.dart';

import '../../main.dart';
import '../../domain/models/patient.dart';

mixin class PatientsBloc {
  Iterable<Patient> get _patients => patientsRepository.getAll();

  SortPatients get sort => sortRM.state.firstOrNull ?? SortPatients.name;
  FilterPatients get filter => filterRM.state.firstOrNull ?? FilterPatients.all;
  final sortRM = RM.inject(() => {SortPatients.date});
  final filterRM = RM.inject(() => {FilterPatients.all});

  Iterable<Patient> get patients {
    final filtered = switch (filter) {
      FilterPatients.all => _patients,
      FilterPatients.today => _patients.where(
          (patient) {
            return patient.timeOfPresentation.day == DateTime.now().day;
          },
        ),
      FilterPatients.last10 => _patients.take(10),
    };

    return filtered.toList()
      ..sort(
        (a, b) {
          return switch (sort) {
            SortPatients.date =>
              a.timeOfPresentation.compareTo(b.timeOfPresentation),
            SortPatients.name => a.name.compareTo(b.name),
          };
        },
      );
  }

  void put(Patient patient) => patientsRepository.put(patient);

  get(int id) {}
}

class PatientsPage extends UI with PatientsBloc, InheritedPatient {
  static String name = '';

  PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Patients'.text(),
      ),
      body: Column(
        children: [
          SortAndFilter(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: patients.length,
              itemBuilder: (context, index) {
                return patientRM.inherited(
                  stateOverride: () => patients.elementAt(index),
                  builder: (context) => PatientTile(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => put(Patient()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
