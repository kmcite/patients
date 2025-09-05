// import 'package:flutter/material.dart';
// import 'package:forui/forui.dart';
// import 'package:manager/manager.dart';
// import 'package:patients/domain/api/navigator.dart';
// import 'package:patients/ui/patient_tile.dart';
// import 'package:patients/ui/patients_bloc.dart';

// class PatientsPage extends UI {
//   const PatientsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FScaffold(
//       header: FHeader(
//         title: const Text('dermatoma'),
//         suffixes: [
//           FHeaderAction.back(onPress: navigator.back),
//         ],
//       ),
//       child: ListView.builder(
//         physics: const BouncingScrollPhysics(),
//         itemCount: patientsBloc.patients.length,
//         itemBuilder: (context, index) => PatientTile(
//           patient: patientsBloc.patients[index],
//         ),
//       ),
//     );
//   }
// }
