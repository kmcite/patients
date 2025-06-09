import 'package:forui/forui.dart';
import 'package:manager/dark/dark_repository.dart';
import 'package:patients/domain/api/hospital_repository.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/hospital.dart';
import 'package:patients/ui/app_drawer.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/ui/investigations_page.dart';
import 'package:patients/ui/patient_types/patient_types_page.dart';
import 'package:patients/ui/pictures/pictures_page.dart';
import 'package:patients/ui/settings_page.dart';
import 'package:patients/ui/personal/user_page.dart';

import '../../main.dart';

void toggleThemeMode() {
  darkRepository.state = !dark;
}

Hospital get hospital => hospitalRepository.value;
int get count => patientsRepository.count();

class HomePage extends UI {
  @override
  void didMountWidget(BuildContext context) {
    FlutterNativeSplash.remove();
  }

  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
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
            onPress: toggleThemeMode,
            child: Icon(switch (dark) {
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
                      '$count',
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
                    hospital.name.text().pad(),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    hospital.city.text(),
                    hospital.info.text(),
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
                    _buildActionButton(context, FIcons.user, 'Patients',
                        () => navigator.to(PatientsPage())),
                    _buildActionButton(
                      context,
                      FIcons.cassetteTape,
                      'Types',
                      () => navigator.to(PatientTypesPage()),
                    ),
                    _buildActionButton(
                      context,
                      FIcons.pictureInPicture,
                      'Pictures',
                      () => navigator.to(const PicturesPage()),
                    ),
                    _buildActionButton(
                      context,
                      FIcons.settings,
                      'Settings',
                      () => navigator.to(SettingsPage()),
                    ),
                    _buildActionButton(
                      context,
                      FIcons.calendar,
                      'Duty Roster',
                      () => navigator.to(const DutyRoster()),
                    ),
                    _buildActionButton(
                      context,
                      FIcons.file,
                      'Investigations',
                      () => navigator.to(const InvestigationsPage()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              FCard(
                subtitle: Row(
                  children: [
                    Icon(
                      FIcons.hospital,
                    ).pad(),
                    Text(
                      'Upcoming Duties',
                    ).pad(),
                  ],
                ),
                child: UpcomingDuties(),
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
          SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
