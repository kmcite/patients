import 'package:forui/forui.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/ui/app_drawer.dart';
import 'package:patients/ui/personal/user_page.dart';

import '../../main.dart';

// Hospital get hospital => hospitalRepository.value;
// int get count => patientsRepository.count();

class HomeBloc extends Bloc {
  late SettingsRepository settingsRepository = watch();
  bool get dark => MediaQuery.of(context).platformBrightness == Brightness.dark;
  int get patientsCount => 0;

  @override
  void initState() {
    FlutterNativeSplash.remove();
  }

  void toggleDark() {
    if (dark) {
      settingsRepository.setThemeMode(ThemeMode.light);
    } else {
      settingsRepository.setThemeMode(ThemeMode.dark);
    }
  }
}

class HomePage extends Feature<HomeBloc> {
  @override
  HomeBloc create() => HomeBloc();

  const HomePage({super.key});
  @override
  Widget build(BuildContext context, controller) {
    return FScaffold(
      header: FHeader.nested(
        title: 'HOME'.text(),
        prefixes: [
          FButton.icon(
            child: Icon(FIcons.menu),
            onPress: () {
              navigator.to(AppDrawer());
            },
          ),
        ],
        suffixes: [
          FButton.icon(
            child: Icon(FIcons.personStanding),
            onPress: () {
              navigator.to(UserPage());
            },
          ),
          FButton.icon(
            onPress: controller.toggleDark,
            child: Icon(switch (controller.dark) {
              false => FIcons.sun,
              true => FIcons.moon,
            }),
          ).pad(right: 8),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FCard(
                subtitle: Row(
                  children: [
                    Icon(FIcons.badgeInfo).pad(),
                    Text('INFOROMATION SYSTEM').pad(),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('All attended patients'),
                    Text(
                      '${controller.patientsCount}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ).pad(),
              ),
              SizedBox(height: 16),
              FCard(
                subtitle: Row(
                  children: [
                    Icon(
                      FIcons.hospital,
                    ).pad(),
                    // hospital.name.text().pad(),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // hospital.city.text(),
                    // hospital.info.text(),
                  ],
                ).pad(),
              ),
              SizedBox(height: 16),
              FCard(
                subtitle: Row(
                  children: [
                    Icon(
                      FIcons.hospital,
                    ).pad(),
                    'QUICK ACTIONS'.text().pad(),
                  ],
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    // _buildActionButton(context, FIcons.user, 'Patients',
                    //     () => navigator.to(PatientsPage())),
                    // _buildActionButton(
                    //   context,
                    //   FIcons.cassetteTape,
                    //   'Types',
                    //   () => navigator.to(PatientTypesPage()),
                    // ),
                    // _buildActionButton(
                    //   context,
                    //   FIcons.pictureInPicture,
                    //   'Pictures',
                    //   () => navigator.to(const PicturesPage()),
                    // ),
                    // _buildActionButton(
                    //   context,
                    //   FIcons.settings,
                    //   'Settings',
                    //   () => navigator.to(SettingsPage()),
                    // ),
                    // _buildActionButton(
                    //   context,
                    //   FIcons.calendar,
                    //   'Duty Roster',
                    //   () => navigator.to(const DutyRoster()),
                    // ),
                    _buildActionButton(
                      context,
                      FIcons.file,
                      'Investigations',
                      () {
                        // navigator.to(InvestigationsPage());
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // FCard(
              //   subtitle: Row(
              //     children: [
              //       Icon(
              //         FIcons.hospital,
              //       ).pad(),
              //       Text(
              //         'Upcoming Duties',
              //       ).pad(),
              //     ],
              //   ),
              //   child: UpcomingDuties(),
              // ),
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
          SizedBox(height: 8),
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
