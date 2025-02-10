import 'package:patients/patients/patient_tile.dart';

import '../main.dart';
import 'patient.dart';
import 'patients_bloc.dart';

class PatientsPage extends UI {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Patients'.text(),
        actions: [
          PopupMenuButton(
            onSelected: patientsBloc.sortPatients,
            itemBuilder: (BuildContext context) {
              return SortPatients.values.map(
                (filter) {
                  return PopupMenuItem(
                    value: filter,
                    child: Text(filter.name),
                  );
                },
              ).toList();
            },
            child: Icon(Icons.sort_by_alpha),
          ).pad(),
          PopupMenuButton(
            onSelected: patientsBloc.filterPatients,
            itemBuilder: (context) {
              return FilterPatients.values.map(
                (filter) {
                  return PopupMenuItem(
                    value: filter,
                    child: Text(filter.name),
                  );
                },
              ).toList();
            },
            child: Icon(Icons.filter_9_plus),
          ).pad(),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: patientsBloc.patients.length,
        itemBuilder: (context, index) => PatientTile(
          patient: patientsBloc.patients.elementAt(index),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => patientsBloc.put(Patient()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
