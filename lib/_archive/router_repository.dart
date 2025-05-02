// import 'package:go_router/go_router.dart';
// import 'package:patients/ui/add_patient_dialog.dart';
// import 'package:patients/ui/home_page_hmis.dart';
// import 'package:patients/ui/investigations_page.dart';
// import 'package:patients/ui/patients/patient/patient_page.dart';
// import 'package:patients/ui/patients/patients_page.dart';
// import 'package:patients/ui/settings_page.dart';
// import 'package:patients/ui/user_page.dart';

// final routerRepository = RouterRepository();

// class RouterRepository {
//   final router = GoRouter(
//     routes: [
//       GoRoute(
//         name: HomePageHmis.name,
//         path: '/',
//         builder: (context, state) => const HomePageHmis(),
//         routes: [
//           GoRoute(
//             name: InvestigationsPage.name,
//             path: '/investigations_page',
//             builder: (context, state) => const InvestigationsPage(),
//           ),
//           GoRoute(
//             name: PatientsPage.name,
//             path: '/patients_page',
//             builder: (context, state) => PatientsPage(),
//             routes: [
//               GoRoute(
//                 name: AddPatientPage.name,
//                 path: '/add_patients_page',
//                 pageBuilder: (_, __) =>
//                     NoTransitionPage(child: AddPatientPage()),
//               ),
//               GoRoute(
//                 name: PatientPage.name,
//                 path: '/patient_page',
//                 builder: (context, state) =>
//                     PatientPage(id: state.extra as int),
//               ),
//             ],
//           ),
//           GoRoute(
//             name: SettingsPage.name,
//             path: '/settings_page',
//             builder: (context, state) => SettingsPage(),
//           ),
//           GoRoute(
//             name: UserPage.name,
//             path: '/user_page',
//             builder: (context, state) => const UserPage(),
//           ),
//         ],
//       ),
//     ],
//   );

//   void toRouteByName(String name) {
//     router.goNamed(name);
//   }

//   void toRouteByPath(String path) {
//     router.go(path);
//   }
// }
