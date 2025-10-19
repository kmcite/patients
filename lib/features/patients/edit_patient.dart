import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/repositories/patients_repository.dart';
import 'package:patients/models/patient.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class EditPatientBloc extends Bloc<EditPatientView> {
  late PatientsRepository patientsRepository = watch();
  late PatientNew patient = widget.patient;

  void onNameChanged(String name) {
    patient.name = name;
    notifyListeners();
  }

  void onEmailChanged(String email) {
    // patient.email = email;
    notifyListeners();
  }

  void onPhoneChanged(String phone) {
    // patient.contact.target!.mnp = phone;
    notifyListeners();
  }

  void onPatientSaved() {
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
        title: Text(patient.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: controller.onPatientSaved,
            tooltip: 'Save',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 8,
          children: [
            TextFormField(
              initialValue: patient.name,
              onChanged: (value) => controller.onNameChanged(value),
            ),
            // TextFormField(
            //   initialValue: patient.email,
            //   onChanged: (value) => controller.onEmailChanged(value),
            // ),
            // TextFormField(
            //   initialValue: patient.contact.target?.mnp,
            //   onChanged: (value) => controller.onPhoneChanged(value),
            // ),
            ListTile(
              leading: CircleAvatar(
                child: Text(
                  patient.name.isNotEmpty ? patient.name[0].toUpperCase() : 'P',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                patient.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              // subtitle: Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     if (patient.email.isNotEmpty) Text('Email: ${patient.email}'),
              //     if (patient.contact.target?.mnp.isNotEmpty == true)
              //       Text('Phone: ${patient.contact.target!.mnp}'),
              //     Text('Age: ${patient.age}'),
              //   ],
              // ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // navigator.to(PatientPage(patient: patient));
              },
            ),
          ],
        ),
      ),
    );
  }
}
