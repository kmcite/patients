import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/ui/new_quick_patient.dart';
import 'package:patients/ui/patients/patient.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class PatientsBloc extends Bloc<PatientsView> {
  late final patientsRepository = watch<PatientsRepository>();

  List<Patient> get patients => patientsRepository.patients.hasData
      ? patientsRepository.patients.data!
      : [];

  void onPatientAdded(BuildContext context) {
    navigator.toDialog<Patient>(const NewQuickPatientView());
  }
}

class PatientsView extends Feature<PatientsBloc> {
  const PatientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => navigator.back(),
        ),
      ),
      body: controller.patientsRepository.patients.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, message) => Center(
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
                onPressed: () => controller.patientsRepository.loadAll(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (patients) {
          if (patients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No patients yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first patient to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => controller.onPatientAdded(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Patient'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
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
                    if (patient.email.isNotEmpty) Text(patient.email),
                    if (patient.complaints.isNotEmpty)
                      Text(
                        patient.complaints,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  navigator.to(
                    PatientPage(patient: patient),
                  );
                },
              );
            },
          );
        },
        empty: () => Center(
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
                onPressed: () => controller.onPatientAdded(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Patient'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.onPatientAdded(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
