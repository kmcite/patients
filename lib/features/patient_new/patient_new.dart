// lib/ui/patients/patient/patient_screen.dart
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:patients/features/patient_new/edit_patient.dart';
import 'package:patients/features/patient_new/visit_form.dart';
import 'package:patients/repositories/patients_repository.dart';
import 'package:patients/utils/architecture.dart';
import '../../models/patient.dart';

@injectable
class PatientNewBloc extends Bloc<PatientNewView> {
  late PatientsRepository patientsRepository = watch();
  late VisitsRepository visitsRepository = watch();

  PatientNew get patient => widget.patient;

  List<Visit> get visits => visitsRepository.value;
  List<PatientNew> get patients => patientsRepository.value;

  // late final PatientsRepository patientsRepository = watch();
  void onVisitSaved(Visit visit) {
    // Always set the forward relation
    visit.patient.target = patient;
    // visitsRepository.put(visit);
    // No need to put patient here, backlink updates automatically
    notifyListeners();
  }

  void onPatientRemoved() {
    // Cascade delete all visits of this patient
    // for (final v in patient.visits) {
    //   // visitsRepository.remove(v);
    // }
    // patientsRepository.remove(patient);
    notifyListeners();
  }
}

class PatientNewView extends Feature<PatientNewBloc> {
  final PatientNew patient;

  const PatientNewView({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              controller.onPatientRemoved();
              navigator.back();
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              navigator.to(
                EditPatientView(patient: patient),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      patient.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    _buildInfoRow('Gender', patient.gender),
                    _buildInfoRow(
                      'Date of Birth',
                      patient.dateOfBirth == null
                          ? 'Unknown'
                          : DateFormat('MMM d, y').format(patient.dateOfBirth!),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildVisitsSection(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // adding new visitation to a patient
          navigator.to(
            VisitForm(
              patient: patient,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildVisitsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Visits',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${patient.visits.length} visits',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (patient.visits.isEmpty)
          const Center(
            child: Text('No visits yet. Tap + to add a new visit.'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: patient.visits.length,
            itemBuilder: (context, index) {
              final visit = patient.visits[index];
              return _buildVisitCard(context, visit);
            },
          ),
      ],
    );
  }

  Widget _buildVisitCard(BuildContext context, Visit visit) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          DateFormat('MMM d, y - hh:mm a').format(visit.when),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Type: ${visit.encounterType}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (visit.diagnosis.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                visit.diagnosis,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        onTap: () {
          navigator.to(
            VisitForm(initialVisit: visit),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
