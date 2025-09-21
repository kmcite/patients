//     on<NavigateToAddTypeDialogEvent>(
//       (event) {
//         navigator.toDialog(AddPatientTypeDialog());
//       },
//     );
//     on<UpdatePatientTypeEvent>(
//       (event) {
//         patientTypesRepository(event.patientType);
//       },
//     );
//     on<RemovePatientTypeEvent>(
//       (event) {
//         patientTypesRepository.remove(event.id);
//       },
//     );

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient_types.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class PatientTypesBloc extends Bloc<PatientTypesPage> {
  late final patientTypesRepository = watch<PatientTypesRepository>();
  void onPatientTypeAdded(PatientType patientType) {
    patientTypesRepository.put(patientType);
  }
}

class PatientTypesPage extends Feature<PatientTypesBloc> {
  const PatientTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Types'),
      ),
      body: const Center(
        child: Text('Patient Types Management - Coming Soon'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.onPatientTypeAdded(PatientType()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// /// UI
// class PatientTypesPage extends UI {
//   const PatientTypesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FScaffold(
//       header: FHeader.nested(
//         title: const Text('Patient Types'),
//         prefixes: [
//           FButton.icon(
//             child: Icon(FIcons.arrowLeft),
//             onPress: () {
//               navigator.back();
//             },
//           ),
//         ],
//         suffixes: [
//           FButton.icon(
//             child: Icon(FIcons.plus),
//             onPress: () => _patientTypes(NavigateToAddTypeDialogEvent()),
//           ),
//         ],
//       ),
//       child: ListView.builder(
//         itemCount: _patientTypes().types.length,
//         itemBuilder: (context, index) {
//           final patientType = _patientTypes().types[index];
//           return PatientTypeItem(patientType: patientType);
//         },
//       ),
//     );
//   }
// }

// class PatientTypeItem extends UI {
//   final PatientType patientType;
//   const PatientTypeItem({super.key, required this.patientType});
//   @override
//   Widget build(BuildContext context) {
//     return FTextField(
//       key: Key('${patientType.id}'),
//       initialText: patientType.type,
//       onChange: (value) {
//         _patientTypes(
//           UpdatePatientTypeEvent(patientType..type = value),
//         );
//       },
//       label: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text('${patientType.id}. ${patientType.type}'),
//           FButton.icon(
//             child: Icon(FIcons.delete),
//             onPress: () =>
//                 _patientTypes(RemovePatientTypeEvent(patientType.id)),
//           ),
//         ],
//       ),
//     );
//   }
// }
