// import 'package:forui/forui.dart';
// import 'package:patients/domain/api/navigator.dart';
// import 'package:patients/domain/api/patients_repository.dart';
// import 'package:patients/domain/models/patient.dart';
// import 'package:patients/main.dart';

// import '../../domain/models/patient_types.dart';

// typedef AddPatientState = ({String name, double age, PatientType? type});

// class AddPatientEvent {}

// class SavePatientEvent extends AddPatientEvent {}

// class ChangeNameEvent extends AddPatientEvent {
//   final String name;
//   ChangeNameEvent(this.name);
// }

// class ChangeAgeEvent extends AddPatientEvent {
//   final String age;
//   ChangeAgeEvent(this.age);
// }

// class CancelDialogEvent extends AddPatientEvent {}

// class AddPatientBloc extends Bloc<AddPatientEvent, AddPatientState> {
//   AddPatientBloc() {
//     on<ChangeNameEvent>(
//       (event) => emit(
//         (name: event.name, age: state.age, type: state.type),
//       ),
//     );
//     on<ChangeAgeEvent>(
//       (event) => emit(
//         (
//           name: state.name,
//           age: double.tryParse(event.age) ?? 0.0,
//           type: state.type,
//         ),
//       ),
//     );
//     on<SavePatientEvent>(
//       (event) {
//         final patient = Patient()
//           ..name = state.name
//           ..age = state.age;
//         patientsRepository(patient);
//         navigator.back();
//       },
//     );
//     on<CancelDialogEvent>(
//       (event) => navigator.back(),
//     );
//   }
//   @override
//   get initialState => (name: '', age: 20, type: null);
// }

// late AddPatientBloc _addPatientBloc;

// class AddPatientPage extends UI {
//   const AddPatientPage({super.key});

//   @override
//   void didMountWidget(BuildContext context) {
//     super.didMountWidget(context);
//     _addPatientBloc = AddPatientBloc();
//   }

//   @override
//   void didUnmountWidget() {
//     _addPatientBloc.dispose();
//     super.didUnmountWidget();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FDialog(
//       title: const Text('add patient'),
//       body: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           FTextField(
//             label: Text('Name'),
//             initialText: _addPatientBloc().name,
//             onChange: (value) => _addPatientBloc(ChangeNameEvent(value)),
//           ),
//           FTextField(
//             label: Text('Age'),
//             initialText: _addPatientBloc().age.toString(),
//             onChange: (value) => _addPatientBloc(ChangeAgeEvent(value)),
//           ),
//         ],
//       ),
//       actions: [
//         FButton(
//           onPress: () => _addPatientBloc(SavePatientEvent()),
//           child: const Text('save'),
//         ),
//         FButton(
//           onPress: () => _addPatientBloc(CancelDialogEvent()),
//           child: const Text('cancel'),
//         ),
//       ],
//     );
//   }
// }
