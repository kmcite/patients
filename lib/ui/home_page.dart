// ignore_for_file: unused_local_variable, unused_element

import 'package:forui/forui.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/domain/models/doctor.dart';
import 'package:patients/main.dart';
import 'package:patients/ui/add_patient_dialog.dart';
import 'package:patients/ui/patient_page.dart';
import 'package:patients/ui/patients_bloc.dart';
import 'package:patients/ui/search_page.dart';
import 'package:patients/ui/settings_page_2.dart';
import 'package:patients/domain/models/patient.dart';

mixin HomeBloc {
  final clinicName = settingsRepository.clinicName;
  int get numberOfTodaysPatients {
    final today = DateTime.now();
    final oneDayBefore = today.subtract(const Duration(days: 1));
    return patientsRepository.getAll().where(
      (pt) {
        return true;
        // pt.presentation.betweenDate(today, oneDayBefore);
      },
    ).length;
  }

  /// recently modified patients are patients which are
  /// modified recently and at least contains 5 patients.
  Iterable<Patient> get recentlyModifiedPatients {
    return patientsRepository.getAll().where(
      (pt) {
        // return pt.modifiedOn.lessOrEqualDate(
        //   DateTime.now(),
        // );
        return true;
      },
    ).take(5);
  }

  int get numberOfRecentlyModifiedPatients => recentlyModifiedPatients.length;

  Doctor? onDutyDoctor() {
    return null;

    // return doctorsRepository.get(authenticationRepository.authentication().id);
  }
}

class HomePage extends UI with HomeBloc {
  HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: const Text('Home'),
        suffixes: [
          FButton.icon(
            onPress: () => navigator.to(SettingsPage()),
            child: Icon(FIcons.settings),
          ),
        ],
      ),
      child: ListView(
        children: [
          FLabel(
            axis: Axis.vertical,
            label: clinicName().text(),
            description: '$numberOfTodaysPatients patients served today'.text(),
            child: 'emeregncy and trauma center'.text(),
          ).pad(),
          FLabel(
            axis: Axis.vertical,
            label: Text('quick actions'),
            child: Row(
              children: [
                FButton.icon(
                  onPress: () async {
                    final patient = await navigator.toDialog<Patient>(
                      AddPatientDialog(),
                    );
                    if (patient != null) patientsBloc.put(patient);
                  },
                  child: Icon(FIcons.plus),
                ).pad(),
                FButton.icon(
                  onPress: () => navigator.to(SearchPage()),
                  child: Icon(FIcons.search),
                ).pad(),
                FButton.icon(
                  onPress: () => navigator.to(PatientsPage()),
                  child: Icon(FIcons.list),
                ).pad(),
              ],
            ),
          ).pad(),
          FLabel(
            axis: Axis.vertical,
            label: Text('Total Patients'),
            description:
                '${onDutyDoctor()?.name}, ${onDutyDoctor()?.email}'.text(),
            child: '${patientsBloc.patients.length}'.text(),
          ).pad(),
          FTileGroup(
            // maxHeight: 630,
            label: 'recent modifications'.text(),
            description:
                '$numberOfRecentlyModifiedPatients recently modified.'.text(),
            children: recentlyModifiedPatients.map(
              (patient) {
                return FTile(
                  onPress: () {
                    navigator.to(
                      PatientPage(patient.id),
                    );
                  },
                  title: patient.name.text(),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}

extension on DateTime {
  bool lessOrEqualDate(DateTime dateTime) =>
      isBefore(dateTime) || isAtSameMomentAs(dateTime);
  bool betweenDate(DateTime today, DateTime oneDayBefore) =>
      isAfter(oneDayBefore) && isBefore(today);
}
