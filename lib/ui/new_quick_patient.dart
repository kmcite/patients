import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class NewQuickPatientBloc extends Bloc<NewQuickPatientView> {
  late PatientsRepository patientsRepository = watch();

  String name = '';
  String email = '';
  String complaints = '';

  @override
  void initState() {
    patientsRepository = watch<PatientsRepository>();
  }

  Future<void> onPatientAdded() async {
    final patient = Patient()
      ..name = name
      ..email = email
      ..complaints = complaints;

    // Check if email is already taken
    final existingPatients = patientsRepository.getAll();
    final isEmailTaken = existingPatients.any((p) => p.email == patient.email);

    if (isEmailTaken) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email already taken')),
      );
      return;
    }

    patientsRepository.put(patient);
    navigator.back();
  }

  void onCancelled() => navigator.back();

  void onNameChanged(String name) {
    this.name = name;
    notifyListeners();
  }

  void onEmailChanged(String email) {
    this.email = email;
    notifyListeners();
  }

  void onComplaintsChanged(String complaints) {
    this.complaints = complaints;
    notifyListeners();
  }
}

class NewQuickPatientView extends Feature<NewQuickPatientBloc> {
  const NewQuickPatientView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_add,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Add New Patient',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: controller.onCancelled,
                ),
              ],
            ),
            TextFormField(
              initialValue: controller.name,
              onChanged: controller.onNameChanged,
              decoration: const InputDecoration(
                labelText: 'Patient Name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Email is required';
                }
                if (!value!.contains('@')) {
                  return 'Invalid email format';
                }
                return null;
              },
              initialValue: controller.email,
              onChanged: controller.onEmailChanged,
            ),
            TextFormField(
              initialValue: controller.complaints,
              onChanged: controller.onComplaintsChanged,
              decoration: const InputDecoration(
                labelText: 'Chief Complaints',
                prefixIcon: Icon(Icons.medical_information),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Complaints are required';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: controller.onCancelled,
                    child: const Text('Cancel'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: controller.onPatientAdded,
                    icon: const Icon(Icons.add),
                    label: const Text('New Patient'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
