import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forui/forui.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/utils/architecture.dart';

class HomeBloc extends Bloc {
  late final SettingsRepository settingsRepository;
  late final PatientsRepository patientsRepository;

  @override
  void initState() {
    settingsRepository = watch<SettingsRepository>();
    patientsRepository = watch<PatientsRepository>();
    FlutterNativeSplash.remove();
  }

  bool get dark => settingsRepository.themeMode == ThemeMode.dark;
  int get patientsCount => patientsRepository.patients.hasData
      ? patientsRepository.patients.data!.length
      : 0;

  void toggleDark() {
    if (dark) {
      settingsRepository.setThemeMode(ThemeMode.light);
    } else {
      settingsRepository.setThemeMode(ThemeMode.dark);
    }
  }
}

class HomePage extends BlocWidget<HomeBloc> {
  const HomePage({super.key});

  @override
  HomeBloc createBloc() => HomeBloc();

  @override
  Widget build(BuildContext context, HomeBloc bloc) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('HOME'),
        prefixes: [
          FButton.icon(
            child: const Icon(FIcons.menu),
            onPress: () {
              // TODO: Open drawer
            },
          ),
        ],
        suffixes: [
          FButton.icon(
            child: const Icon(FIcons.personStanding),
            onPress: () {
              // TODO: Navigate to user page
            },
          ),
          FButton.icon(
            onPress: bloc.toggleDark,
            child: Icon(bloc.dark ? FIcons.moon : FIcons.sun),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FCard(
                subtitle: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(FIcons.badgeInfo),
                    ),
                    Text('INFORMATION SYSTEM'),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('All attended patients'),
                      Text(
                        '${bloc.patientsCount}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FCard(
                subtitle: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(FIcons.hospital),
                    ),
                    Text('HOSPITAL INFO'),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hospital Management System'),
                      Text('Emergency and Trauma Center'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FCard(
                subtitle: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(FIcons.zap),
                    ),
                    Text('QUICK ACTIONS'),
                  ],
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildActionButton(
                      context,
                      FIcons.user,
                      'Patients',
                      () {
                        // TODO: Navigate to patients page
                      },
                    ),
                    _buildActionButton(
                      context,
                      FIcons.settings,
                      'Settings',
                      () {
                        // TODO: Navigate to settings page
                      },
                    ),
                    _buildActionButton(
                      context,
                      FIcons.file,
                      'Investigations',
                      () {
                        // TODO: Navigate to investigations page
                      },
                    ),
                    _buildActionButton(
                      context,
                      FIcons.calendar,
                      'Duty Roster',
                      () {
                        // TODO: Navigate to duty roster page
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return FButton(
      onPress: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// // ignore_for_file: unused_local_variable, unused_element

// import 'package:forui/forui.dart';
// import 'package:patients/domain/api/navigator.dart';
// import 'package:patients/domain/api/patients_repository.dart';
// import 'package:patients/domain/api/settings_repository.dart';
// import 'package:patients/domain/models/doctor.dart';
// import 'package:patients/main.dart';
// import 'package:patients/ui/add_patient_dialog.dart';
// import 'package:patients/ui/patient_page.dart';
// import 'package:patients/ui/patients_bloc.dart';
// import 'package:patients/ui/search_page.dart';
// import 'package:patients/ui/settings_page_2.dart';
// import 'package:patients/domain/models/patient.dart';

// mixin HomeBloc {
//   final clinicName = settingsRepository.clinicName;
//   int get numberOfTodaysPatients {
//     final today = DateTime.now();
//     final oneDayBefore = today.subtract(const Duration(days: 1));
//     return patientsRepository.getAll().where(
//       (pt) {
//         return true;
//         // pt.presentation.betweenDate(today, oneDayBefore);
//       },
//     ).length;
//   }

//   /// recently modified patients are patients which are
//   /// modified recently and at least contains 5 patients.
//   Iterable<Patient> get recentlyModifiedPatients {
//     return patientsRepository.getAll().where(
//       (pt) {
//         // return pt.modifiedOn.lessOrEqualDate(
//         //   DateTime.now(),
//         // );
//         return true;
//       },
//     ).take(5);
//   }

//   int get numberOfRecentlyModifiedPatients => recentlyModifiedPatients.length;

//   Doctor? onDutyDoctor() {
//     return null;

//     // return doctorsRepository.get(authenticationRepository.authentication().id);
//   }
// }

// class HomePage extends UI with HomeBloc {
//   HomePage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return FScaffold(
//       header: FHeader(
//         title: const Text('Home'),
//         suffixes: [
//           FButton.icon(
//             onPress: () => navigator.to(SettingsPage()),
//             child: Icon(FIcons.settings),
//           ),
//         ],
//       ),
//       child: ListView(
//         children: [
//           FLabel(
//             axis: Axis.vertical,
//             label: clinicName().text(),
//             description: '$numberOfTodaysPatients patients served today'.text(),
//             child: 'emeregncy and trauma center'.text(),
//           ).pad(),
//           FLabel(
//             axis: Axis.vertical,
//             label: Text('quick actions'),
//             child: Row(
//               children: [
//                 FButton.icon(
//                   onPress: () async {
//                     final patient = await navigator.toDialog<Patient>(
//                       AddPatientDialog(),
//                     );
//                     if (patient != null) patientsBloc.put(patient);
//                   },
//                   child: Icon(FIcons.plus),
//                 ).pad(),
//                 FButton.icon(
//                   onPress: () => navigator.to(SearchPage()),
//                   child: Icon(FIcons.search),
//                 ).pad(),
//                 FButton.icon(
//                   onPress: () => navigator.to(PatientsPage()),
//                   child: Icon(FIcons.list),
//                 ).pad(),
//               ],
//             ),
//           ).pad(),
//           FLabel(
//             axis: Axis.vertical,
//             label: Text('Total Patients'),
//             description:
//                 '${onDutyDoctor()?.name}, ${onDutyDoctor()?.email}'.text(),
//             child: '${patientsBloc.patients.length}'.text(),
//           ).pad(),
//           FTileGroup(
//             // maxHeight: 630,
//             label: 'recent modifications'.text(),
//             description:
//                 '$numberOfRecentlyModifiedPatients recently modified.'.text(),
//             children: recentlyModifiedPatients.map(
//               (patient) {
//                 return FTile(
//                   onPress: () {
//                     navigator.to(
//                       PatientPage(patient.id),
//                     );
//                   },
//                   title: patient.name.text(),
//                 );
//               },
//             ).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// extension on DateTime {
//   bool lessOrEqualDate(DateTime dateTime) =>
//       isBefore(dateTime) || isAtSameMomentAs(dateTime);
//   bool betweenDate(DateTime today, DateTime oneDayBefore) =>
//       isAfter(oneDayBefore) && isBefore(today);
// }
