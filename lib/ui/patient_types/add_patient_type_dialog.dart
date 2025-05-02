import 'package:patients/domain/api/patient_types_repository.dart';
import 'package:patients/domain/models/patient_types.dart';
import 'package:patients/main.dart';
import 'package:patients/domain/api/navigator.dart';

final _patientTypeField = RM.injectTextEditing();
mixin AddPatientTypeBloc {
  String get text => _patientTypeField.text;
  TextEditingController get controller => _patientTypeField.controller;
  void put(PatientType type) {
    patientTypesRepository.put(type);
  }
}

class AddPatientTypeDialog extends UI with AddPatientTypeBloc {
  const AddPatientTypeDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Type Name'),
          TextFormField(
            controller: controller,
          ).pad(),
          Row(
            children: [
              FilledButton(
                onPressed: () {
                  put(PatientType()..type = text);
                  navigator.back();
                },
                child: 'save'.text(),
              ).pad(),
              FilledButton(
                onPressed: () {
                  navigator.back();
                },
                child: 'cancel'.text(),
              ).pad(),
            ],
          ),
        ],
      ).pad(),
    );
  }
}
