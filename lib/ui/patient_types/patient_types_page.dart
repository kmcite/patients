import 'dart:async';

import 'package:forui/forui.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/main.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/domain/models/patient_types.dart';
import 'package:patients/ui/patient_types/add_patient_type_dialog.dart';

/// STATE
typedef _PatientTypesState = ({List<PatientType> types});

/// EVENTS
class PatientTypesEvent {}

class NavigateToAddTypeDialogEvent extends PatientTypesEvent {}

class UpdatePatientTypeEvent extends PatientTypesEvent {
  final PatientType patientType;
  UpdatePatientTypeEvent(this.patientType);
}

class RemovePatientTypeEvent extends PatientTypesEvent {
  final int id;
  RemovePatientTypeEvent(this.id);
}

/// BLOC
final _patientTypes = _PatientTypes();

class _PatientTypes extends Bloc<void, _PatientTypesState> {
  StreamSubscription? _typesSubscription;
  _PatientTypes() {
    on<NavigateToAddTypeDialogEvent>(
      (event) {
        navigator.toDialog(AddPatientTypeDialog());
      },
    );
    on<UpdatePatientTypeEvent>(
      (event) {
        patientTypesRepository(event.patientType);
      },
    );
    on<RemovePatientTypeEvent>(
      (event) {
        patientTypesRepository.remove(event.id);
      },
    );
    _typesSubscription = patientTypesRepository.watch().listen(
      (types) {
        emit(
          (types: types),
        );
      },
    );
  }

  @override
  get initialState => (types: patientTypesRepository());
  @override
  void dispose() {
    _typesSubscription?.cancel();
    super.dispose();
  }
}

/// UI
class PatientTypesPage extends UI {
  const PatientTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('Patient Types'),
        prefixActions: [
          FButton.icon(
            child: FIcon(FAssets.icons.arrowLeft),
            onPress: () {
              navigator.back();
            },
          ),
        ],
        suffixActions: [
          FButton.icon(
            child: FIcon(FAssets.icons.plus),
            onPress: () => _patientTypes(NavigateToAddTypeDialogEvent()),
          ),
        ],
      ),
      content: ListView.builder(
        itemCount: _patientTypes().types.length,
        itemBuilder: (context, index) {
          final patientType = _patientTypes().types[index];
          return PatientTypeItem(patientType: patientType);
        },
      ),
    );
  }
}

class PatientTypeItem extends UI {
  final PatientType patientType;
  const PatientTypeItem({super.key, required this.patientType});
  @override
  Widget build(BuildContext context) {
    return FTextField(
      key: Key('${patientType.id}'),
      initialValue: patientType.type,
      onChange: (value) {
        _patientTypes(
          UpdatePatientTypeEvent(patientType..type = value),
        );
      },
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${patientType.id}. ${patientType.type}'),
          FButton.icon(
            child: FIcon(FAssets.icons.delete),
            onPress: () =>
                _patientTypes(RemovePatientTypeEvent(patientType.id)),
          ),
        ],
      ),
    );
  }
}
