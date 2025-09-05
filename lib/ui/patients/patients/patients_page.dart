// import 'dart:async';

// import 'package:forui/forui.dart';
// import 'package:patients/domain/api/navigator.dart';
// import 'package:patients/domain/api/patients_repository.dart';
// import 'package:patients/ui/patients/add_patient_dialog.dart';
// import 'package:patients/ui/patients/patient_tile.dart';
// import 'package:patients/ui/patients/sort_and_filter.dart';

// import '../../../main.dart';
// import '../../../domain/models/patient.dart';

// part 'patients_bloc.dart';

// late PatientsBloc _patientsBloc;

// class PatientsPage extends UI {
//   const PatientsPage({super.key});
//   @override
//   void didMountWidget(BuildContext context) {
//     _patientsBloc = PatientsBloc();
//     super.didMountWidget(context);
//   }

//   @override
//   void didUnmountWidget() {
//     _patientsBloc.dispose();
//     super.didUnmountWidget();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FScaffold(
//       header: FHeader.nested(
//         title: 'Patients'.text(),
//         prefixes: [
//           FButton.icon(
//             onPress: () => navigator.back(),
//             child: Icon(FIcons.x),
//           ),
//           FAvatar.raw(
//             child: '${_patientsBloc.sorted.length}'.text(),
//           ),
//         ],
//         suffixes: [
//           FButton.icon(
//             onPress: () => _patientsBloc(ToggleFilterEvent()),
//             child: Icon(
//               switch (_patientsBloc().filter) {
//                 FilterPatients.all => FIcons.calendar,
//                 FilterPatients.today => FIcons.fileType,
//                 FilterPatients.last10 => FIcons.tent,
//               },
//             ),
//           ),
//           FButton.icon(
//             onPress: () => _patientsBloc(ToggleSortEvent()),
//             child: Icon(
//               switch (_patientsBloc().sort) {
//                 SortPatients.date => FIcons.arrowUpAZ,
//                 SortPatients.name => FIcons.diameter,
//               },
//             ),
//           ),
//           FButton.icon(
//             onPress: () => _patientsBloc(OpenNewPatientDialogEvent()),
//             child: Icon(FIcons.plus),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           SortAndFilter(
//             filter: _patientsBloc().filter,
//             sort: _patientsBloc().sort,
//             onFilterChanged: (filter) => ChangeFilterEvent(filter),
//             onSortChanged: (sort) => ChangeSortEvent(sort),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(8),
//               itemCount: _patientsBloc.sorted.length,
//               itemBuilder: (context, index) {
//                 return PatientTile(
//                   patient: _patientsBloc.sorted.elementAt(index),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
