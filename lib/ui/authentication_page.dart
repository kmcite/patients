// import 'package:flutter/material.dart';
// import 'package:forui/forui.dart';
// import 'package:manager/manager.dart';
// import 'package:patients/domain/api/authentication_repository.dart';
// import 'package:patients/domain/api/doctors_repository.dart';
// import 'package:patients/domain/api/patients_repository.dart';
// import 'package:patients/domain/models/authentication.dart';
// import 'package:states_rebuilder/states_rebuilder.dart';

// mixin AuthenticationBloc {
//   final indexRM = RM.inject(() => 0);
//   int index([int? value]) {
//     if (value != null) {
//       indexRM.state = value;
//     }
//     return indexRM.state;
//   }

//   final nameRM = RM.injectTextEditing(text: 'Adn');
//   final emailRM = RM.injectTextEditing(text: 'adn@gmail.com');
//   final passwordRM = RM.injectTextEditing(text: '123456');

//   void login() {
//     final type = switch (index()) {
//       0 => UserType.doctor,
//       _ => UserType.patient,
//     };
//     final request = switch (type) {
//       UserType.doctor => () {
//           final doctor = doctorsRepository.getAll().where(
//             (doc) {
//               return doc.email == emailRM.text;
//             },
//           ).firstOrNull;
//           if (doctor?.password == passwordRM.text) {
//             return (doctor, null);
//           } else {
//             return (null, null);
//           }
//         },
//       UserType.patient => () {
//           final patient = patientsRepository.getAll().where(
//             (doc) {
//               return doc.email == emailRM.text;
//             },
//           ).firstOrNull;
//           if (patient?.password == passwordRM.text) {
//             return (null, patient);
//           } else {
//             return (null, null);
//           }
//         },
//     };
//     final (doctor, patient) = request();
//     authentication = authentication
//       ..id = doctor?.id ?? patient?.id ?? 0
//       ..userType = type
//       ..name = nameRM.text
//       ..email = emailRM.text
//       ..password = passwordRM.text;
//   }

//   bool get invalidCredentials {
//     return emailRM.text.isEmpty || passwordRM.text.isEmpty;
//   }
// }

// class AuthenticationPage extends UI with AuthenticationBloc {
//   AuthenticationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Authentication'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             FTabs(
//               initialIndex: index(),
//               onPress: index,
//               children: [
//                 FTabEntry(
//                   label: 'DOCTOR'.text(),
//                   child: FLabel(
//                     axis: Axis.vertical,
//                     child: Column(
//                       children: [
//                         FTextField(
//                           label: 'Name'.text(),
//                           controller: nameRM.controller,
//                         ).pad(),
//                         FTextField.email(
//                           controller: emailRM.controller,
//                         ).pad(),
//                         FTextField.password(
//                           controller: passwordRM.controller,
//                         ).pad(),
//                       ],
//                     ),
//                   ),
//                 ),
//                 FTabEntry(
//                   label: 'PATIENT'.text(),
//                   child: Column(
//                     children: [
//                       FTextField(
//                         label: 'Name'.text(),
//                         controller: nameRM.controller,
//                       ).pad(),
//                       FTextField.email(
//                         controller: emailRM.controller,
//                       ).pad(),
//                       FTextField.password(
//                         controller: passwordRM.controller,
//                       ).pad(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             FButton(
//               onPress: invalidCredentials ? null : () => login(),
//               child: const Text('Login'),
//             ).pad(),
//             FButton(
//               child: const Text('By pass login'),
//               onPress: () {
//                 authentication = Authentication()..id = 1;
//               },
//             ).pad(),
//           ],
//         ),
//       ),
//     );
//   }
// }
