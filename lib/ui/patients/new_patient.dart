import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class NewPatientBloc extends Bloc<NewPatientView> {
  late final PatientsRepository patientsRepository = watch();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final allergiesController = TextEditingController();
  final chronicConditionsController = TextEditingController();

  bool isMale = true;

  void setGender(bool? male) {
    isMale = male ?? true;
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

class NewPatientView extends Feature<NewPatientBloc> {
  const NewPatientView({super.key});

  @override
  Widget build(BuildContext context) {
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
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: controller.phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: controller.ageController,
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
              RadioGroup<bool>(
                groupValue: controller.isMale,
                onChanged: controller.setGender,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: true,
                          ),
                          const SizedBox(width: 8),
                          const Text('MALE'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: false,
                          ),
                          const SizedBox(width: 8),
                          const Text('FEMALE'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Medical Information
              TextField(
                controller: controller.bloodGroupController,
                decoration: const InputDecoration(
                  labelText: 'Blood Group (e.g., A+, B-, O+)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: controller.allergiesController,
                decoration: const InputDecoration(
                  labelText: 'Allergies',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: controller.chronicConditionsController,
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
                    onPressed: controller.canSave
                        ? () {
                            controller.savePatient();
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
