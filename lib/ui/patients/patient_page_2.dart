import 'package:flutter/material.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/utils/architecture.dart';

class PatientBloc extends Bloc {
  late final PatientsRepository patientsRepository;
  Patient? patient;

  @override
  void initState() {
    patientsRepository = watch<PatientsRepository>();
  }

  void loadPatient(int id) {
    patient = patientsRepository.getById(id);
    notifyListeners();
  }
}

class PatientPage extends Feature<PatientBloc> {
  const PatientPage(this.patientId, {super.key});
  final int patientId;

  @override
  PatientBloc createBloc() => PatientBloc();

  @override
  Widget build(BuildContext context, PatientBloc bloc) {
    // Load patient if not already loaded
    if (bloc.patient?.id != patientId) {
      bloc.loadPatient(patientId);
    }

    final patient = bloc.patient;
    if (patient == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Patient')),
        body: const Center(child: Text('Patient not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit patient
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patient Information',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Name', patient.name),
                    _buildInfoRow('Email', patient.email),
                    _buildInfoRow('Phone', patient.contact.target?.mnp ?? ''),
                    _buildInfoRow('Age', patient.age.toString()),
                    _buildInfoRow('Gender', patient.gender ? 'Male' : 'Female'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medical Information',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                        'Blood Group',
                        patient.bloodGroup.isNotEmpty
                            ? patient.bloodGroup
                            : 'Unknown'),
                    _buildInfoRow(
                        'Allergies',
                        patient.allergies.isNotEmpty
                            ? patient.allergies
                            : 'None'),
                    _buildInfoRow(
                        'Chronic Conditions',
                        patient.chronicConditions.isNotEmpty
                            ? patient.chronicConditions
                            : 'None'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add appointment or medical record
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
