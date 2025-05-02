import 'package:forui/forui.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient_types.dart';
import 'package:patients/main.dart';
import 'package:patients/domain/api/navigator.dart';

final _addPatientType = _AddPatientType();

/// BLOC
class _AddPatientType extends Bloc<AddTypeEvent, String> {
  _AddPatientType() {
    on<ChangeTypeNameEvent>(
      (event) => emit(event.name),
    );
    on<GoBackEvent>(
      (event) {
        emit(initialState);
        navigator.back();
      },
    );
    on<SaveTypeEvent>(
      (event) {
        patientTypesRepository(event.type);
        navigator.back();
      },
    );
  }

  @override
  String get initialState => '';
}

/// EVENTS
class AddTypeEvent {
  const AddTypeEvent();
}

class ChangeTypeNameEvent extends AddTypeEvent {
  final String name;
  const ChangeTypeNameEvent(this.name);
}

class GoBackEvent extends AddTypeEvent {
  const GoBackEvent();
}

class SaveTypeEvent extends AddTypeEvent {
  final PatientType type;
  const SaveTypeEvent(this.type);
}

/// UI
class AddPatientTypeDialog extends UI {
  const AddPatientTypeDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return FDialog(
      direction: Axis.horizontal,
      actions: [
        FButton(
          onPress: () => _addPatientType(
            SaveTypeEvent(
              PatientType()..type = _addPatientType(),
            ),
          ),
          label: 'save'.text(),
        ),
        FButton(
          onPress: () => _addPatientType(GoBackEvent()),
          label: 'cancel'.text(),
        ),
      ],
      body: FTextField(
        label: Text('Type Name'),
        initialValue: _addPatientType.state,
        onChange: (name) => _addPatientType(ChangeTypeNameEvent(name)),
      ),
    );
  }
}
