import 'package:flutter/material.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/utils/architecture.dart';

class AddPatientDialogBloc extends Bloc {
  late final PatientsRepository patientsRepository;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final complaintsController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    patientsRepository = watch<PatientsRepository>();
  }

  Future<void> addPatient() async {
    if (!formKey.currentState!.validate()) return;

    final patient = Patient()
      ..name = nameController.text.trim()
      ..email = emailController.text.trim()
      ..complaints = complaintsController.text.trim();

    // Check if email is already taken
    final existingPatients = patientsRepository.getAll();
    final isEmailTaken = existingPatients.any((p) => p.email == patient.email);

    if (isEmailTaken) {
      // Show error
      return;
    }

    patientsRepository.addPatient(patient);
    navigator.back(patient);
  }

  void cancel() => navigator.back();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    complaintsController.dispose();
    super.dispose();
  }
}

class AddPatientDialog extends Feature<AddPatientDialogBloc> {
  const AddPatientDialog({super.key});

  @override
  AddPatientDialogBloc createBloc() => AddPatientDialogBloc();

  @override
  Widget build(BuildContext context, AddPatientDialogBloc bloc) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: bloc.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
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
                      onPressed: bloc.cancel,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Form Fields
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: bloc.nameController,
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
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: bloc.emailController,
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
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: bloc.complaintsController,
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
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: bloc.cancel,
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: bloc.addPatient,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Patient'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
