import 'package:flutter/material.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/utils/architecture.dart';

class AddPatientBloc extends Bloc {
  late final PatientsRepository patientsRepository;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final allergiesController = TextEditingController();
  final chronicConditionsController = TextEditingController();

  bool isMale = true;

  @override
  void initState() {
    patientsRepository = watch<PatientsRepository>();
  }

  void setGender(bool male) {
    isMale = male;
    notifyListeners();
  }

  bool get canSave {
    return nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        ageController.text.isNotEmpty;
  }

  void savePatient() {
    if (!canSave) return;

    final patient = Patient()
      ..name = nameController.text
      ..email = emailController.text
      ..age = double.tryParse(ageController.text) ?? 0.0
      ..gender = isMale
      ..bloodGroup = bloodGroupController.text
      ..allergies = allergiesController.text
      ..chronicConditions = chronicConditionsController.text;

    // Set phone number through contact
    if (phoneController.text.isNotEmpty) {
      final contact = Contact()..mnp = phoneController.text;
      patient.contact.target = contact;
    }

    patientsRepository.put(patient);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    ageController.dispose();
    bloodGroupController.dispose();
    allergiesController.dispose();
    chronicConditionsController.dispose();
    super.dispose();
  }
}

class AddPatientDialog extends Feature<AddPatientBloc> {
  const AddPatientDialog({super.key});

  @override
  AddPatientBloc createBloc() => AddPatientBloc();

  @override
  Widget build(BuildContext context, AddPatientBloc bloc) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Patient',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),

              // Basic Information
              TextField(
                controller: bloc.nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: bloc.emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: bloc.phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: bloc.ageController,
                decoration: const InputDecoration(
                  labelText: 'Age *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Gender Selection
              Text('Gender', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('MALE'),
                      value: true,
                      groupValue: bloc.isMale,
                      onChanged: (value) => bloc.setGender(value!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('FEMALE'),
                      value: false,
                      groupValue: bloc.isMale,
                      onChanged: (value) => bloc.setGender(value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Medical Information
              TextField(
                controller: bloc.bloodGroupController,
                decoration: const InputDecoration(
                  labelText: 'Blood Group (e.g., A+, B-, O+)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: bloc.allergiesController,
                decoration: const InputDecoration(
                  labelText: 'Allergies',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: bloc.chronicConditionsController,
                decoration: const InputDecoration(
                  labelText: 'Chronic Conditions',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: bloc.canSave
                        ? () {
                            bloc.savePatient();
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text('Save Patient'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
