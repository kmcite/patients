import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/models/patient.dart';
import 'package:patients/repositories/patients_repository.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class EditPatientBloc extends Bloc<EditPatientView> {
  late PatientsRepository patientsRepository = watch();
  late VisitsRepository visitsRepository = watch();
  late PatientNew patient = widget.patient;
  void onNameChnaged(String name) {
    patient.name = name;
  }

  void onVisitRemoved(Visit visit) {
    // If you want to keep the visit but unlink from patient:
    visit.patient.target = null;
    // visitsRepository.put(visit);

    // If you want to delete the visit completely:
    // visitsRepository.remove(visit);
  }

  void onGenderChanged(String gender) {
    patient.gender = gender;
    notifyListeners();
  }

  void onSave() {
    // Save the patient itself
    // patientsRepository.put(patient);
    navigator.back();
  }
}

class EditPatientView extends Feature<EditPatientBloc> {
  final PatientNew patient;
  const EditPatientView({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Patient'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: controller.onSave,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8,
          children: [
            TextFormField(
              initialValue: patient.name,
              onChanged: (value) => controller.onNameChnaged(value),
            ),
            TextFormField(
              initialValue: patient.gender,
              onChanged: (value) => controller.onGenderChanged(value),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: patient.visits.length,
                  itemBuilder: (context, i) {
                    final visit = patient.visits[i];
                    return Column(
                      children: [
                        Text(visit.when.toString()),
                        Text(visit.encounterType),
                        Text(visit.diagnosis),
                        Text(visit.management),
                        Text(visit.examination),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => controller.onVisitRemoved(visit),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
