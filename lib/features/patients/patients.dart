import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:patients/features/patient_new/patient_new.dart';
import 'package:patients/features/patient_new/visits.dart';
import 'package:patients/repositories/patients_repository.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class PatientsBloc extends Bloc<PatientsView> {
  late final patientsRepository = watch<PatientsRepository>();

  // Iterable<PatientNew> get patients => patientsRepository.getAll();

  // Resource<Iterable<PatientNew>> get patients => patientsRepository.items;

  void onPatientAdded() {
    // navigator.toDialog<Patient>(const NewQuickPatientView());
    // patientsRepository.put(PatientNew());
    notifyListeners();
  }
}

class PatientsView extends Feature<PatientsBloc> {
  const PatientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => navigator.to(const VisitsView()),
          ),
        ],
      ),
      body: controller.patientsRepository.when(
        error: (error, message) => ErrorPatientsView(
          onRetry: () {
            // controller.patientsRepository.loadAll();
          },
          error: message ?? error.toString(),
        ),
        data: (patients) {
          if (patients.isEmpty) {
            return EmptyListView(
              onAddPatient: controller.onPatientAdded,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients.elementAt(index);
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    patient.name.isNotEmpty
                        ? patient.name[0].toUpperCase()
                        : 'P',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  patient.name.isNotEmpty ? patient.name : 'Unnamed Patient',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patient.gender),
                    Text(
                      patient.dateOfBirth == null
                          ? 'Unknown'
                          : DateFormat('MMM d, y').format(patient.dateOfBirth!),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  navigator.to(
                    PatientNewView(patient: patient),
                  );
                },
              );
            },
          );
        },
        empty: () => EmptyListView(
          onAddPatient: controller.onPatientAdded,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onPatientAdded,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EmptyListView extends StatelessWidget {
  const EmptyListView({super.key, required this.onAddPatient});

  final VoidCallback onAddPatient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          const Text('No patients found'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAddPatient,
            icon: const Icon(Icons.add),
            label: const Text('Add Patient'),
          ),
        ],
      ),
    );
  }
}

class ErrorPatientsView extends StatelessWidget {
  final VoidCallback onRetry;
  final String error;
  const ErrorPatientsView({
    super.key,
    required this.onRetry,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text('Error loading patients: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => onRetry(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
