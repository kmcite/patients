import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class PatientBloc extends Bloc<PatientPage> {
  late final PatientsRepository patientsRepository = watch();
  late Patient? patient = widget.patient;

  void _loadPatient(int id) {
    patient = patientsRepository.getById(id);
    notifyListeners();
  }

  void updatePatient() {
    if (patient != null) {
      patientsRepository.put(patient!);
    }
  }

  void onRefreshed() {
    if (patient != null) {
      _loadPatient(patient!.id);
    }
  }
}

class PatientPage extends Feature<PatientBloc> {
  final Patient patient;

  const PatientPage({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    final patient = controller.patient;
    if (patient == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Patient'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Patient not found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.onRefreshed,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // navigator.to(
              //   EditPatientPage(patient: currentPatient),
              // );
            },
            tooltip: 'Edit Patient',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.onRefreshed(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Patient Information',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      InformationRow(label: 'Name', value: patient.name),
                      InformationRow(label: 'Email', value: patient.email),
                      InformationRow(
                          label: 'Phone',
                          value: patient.contact.target?.mnp ?? 'Not provided'),
                      InformationRow(
                          label: 'Age', value: '${patient.age} years'),
                      InformationRow(
                          label: 'Gender',
                          value: patient.gender ? 'Male' : 'Female'),
                      InformationRow(
                          label: 'Date of Birth',
                          value:
                              patient.dateOfBirth?.toString().split(' ')[0] ??
                                  'Not provided'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Medical Information Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.medical_information,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Medical Information',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      InformationRow(
                          label: 'Blood Group',
                          value: patient.bloodGroup.isNotEmpty
                              ? patient.bloodGroup
                              : 'Unknown'),
                      InformationRow(
                          label: 'Allergies',
                          value: patient.allergies.isNotEmpty
                              ? patient.allergies
                              : 'None reported'),
                      InformationRow(
                          label: 'Chronic Conditions',
                          value: patient.chronicConditions.isNotEmpty
                              ? patient.chronicConditions
                              : 'None reported'),
                      InformationRow(
                          label: 'Current Medications',
                          value: patient.currentMedications.isNotEmpty
                              ? patient.currentMedications
                              : 'None reported'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Clinical Information Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_hospital,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Clinical Information',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      InformationRow(
                          label: 'Complaints',
                          value: patient.complaints.isNotEmpty
                              ? patient.complaints
                              : 'None recorded'),
                      InformationRow(
                          label: 'Examination',
                          value: patient.examination.isNotEmpty
                              ? patient.examination
                              : 'Not performed'),
                      InformationRow(
                          label: 'Diagnosis',
                          value: patient.diagnosis.isNotEmpty
                              ? patient.diagnosis
                              : 'Not diagnosed'),
                      InformationRow(
                          label: 'Management',
                          value: patient.management.isNotEmpty
                              ? patient.management
                              : 'Not specified'),
                      InformationRow(
                          label: 'Outcome Status',
                          value: patient.outComeStatus.name.toUpperCase()),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (patient.emergencyContactName.isNotEmpty) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.emergency,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Emergency Contact',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        InformationRow(
                          label: 'Name',
                          value: patient.emergencyContactName,
                        ),
                        InformationRow(
                          label: 'Phone',
                          value: patient.emergencyContactPhone,
                        ),
                        InformationRow(
                          label: 'Relation',
                          value: patient.emergencyContactRelation,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Insurance Information Card
              if (patient.insuranceProvider.isNotEmpty) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Insurance Information',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        InformationRow(
                          label: 'Provider',
                          value: patient.insuranceProvider,
                        ),
                        InformationRow(
                          label: 'Policy Number',
                          value: patient.insuranceNumber,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // navigator.to(
          //   AddAppointmentPage(patient: currentPatient),
          // );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
      ),
    );
  }
}

class InformationRow extends StatelessWidget {
  const InformationRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
