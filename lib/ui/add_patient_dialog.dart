// import 'package:forui/forui.dart';
// import 'package:patients/domain/api/doctors_repository.dart';
// import 'package:patients/domain/models/patient.dart';
// import 'package:patients/main.dart';

// import '../domain/api/navigator.dart';
// import '../domain/api/patients_repository.dart';

// class AddPatientDialogState {
//   String name = '';
//   String complaints = '';
// }

// mixin AddPatientDialogBloc {
//   final nameRM = RM.injectTextEditing();
//   final emailRM = RM.injectTextEditing(text: '@');
//   final complaintsRM = RM.injectTextEditing();

//   void okay() {
//     final patient = Patient()
//       ..name = nameRM.text
//       ..email = emailRM.text
//       ..complaints = complaintsRM.text;

//     final isEmailTaken = doctorsRepository.getAll().any(
//           (doctor) {
//             return doctor.email == emailRM.text;
//           },
//         ) ||
//         patientsRepository.getAll().any(
//           (pt) {
//             return pt.email == emailRM.text;
//           },
//         );
//     if (!isEmailTaken) patientsRepository.put(patient);
//     cancel();
//   }

//   void cancel() => navigator.back();
// }

// class AddPatientDialog extends UI with AddPatientDialogBloc {
//   AddPatientDialog({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return FDialog(
//       title: 'Patient'.text(),
//       body: Column(
//         children: [
//           FTextField(
//             label: Text('name'),
//             controller: nameRM.controller,
//           ),
//           FTextField(
//             label: Text('email'),
//             controller: emailRM.controller,
//           ),
//           FTextField(
//             label: Text('complaints'),
//             controller: complaintsRM.controller,
//             minLines: 6,
//             maxLines: 15,
//           ),
//         ],
//       ),
//       actions: [
//         FButton(
//           onPress: cancel,
//           child: 'cancel'.text(),
//         ),
//         FButton(
//           onPress: okay,
//           child: 'yes'.text(),
//         ),
//       ],
//     );
//   }
// }
