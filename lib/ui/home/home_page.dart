import 'dart:async';

import 'package:forui/forui.dart';
import 'package:patients/domain/api/hospital_repository.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/domain/models/hospital.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/domain/models/settings.dart';
import 'package:patients/ui/app_drawer.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/ui/investigations_page.dart';
import 'package:patients/ui/patient_types/patient_types_page.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/ui/pictures/pictures_page.dart';
import 'package:patients/ui/settings_page.dart';
import 'package:patients/ui/personal/user_page.dart';

import '../../main.dart';

typedef _HomeState = ({
  Hospital hospital,
  ThemeMode themeMode,
  int count,
});

class ToggleThemeModeHomeEvent {
  const ToggleThemeModeHomeEvent();
}

class _Home extends Bloc<ToggleThemeModeHomeEvent, _HomeState> {
  StreamSubscription<Hospital>? _hospitalSubscription;
  StreamSubscription<Settings>? _darkSubscription;
  StreamSubscription<List<Patient>>? _countSubscription;
  _Home() {
    on<ToggleThemeModeHomeEvent>(
      (event) {
        final themeMode = switch (state.themeMode) {
          ThemeMode.system => ThemeMode.light,
          ThemeMode.light => ThemeMode.dark,
          ThemeMode.dark => ThemeMode.system,
        };
        settingsRepository.setThemeMode(themeMode);
        emit(
          (
            hospital: state.hospital,
            themeMode: themeMode,
            count: state.count,
          ),
        );
      },
    );
    _hospitalSubscription = hospitalRepository.stream.listen(
      (hospital) => emit(
        (
          hospital: hospital,
          themeMode: state.themeMode,
          count: state.count,
        ),
      ),
    );
    _darkSubscription = settingsRepository().listen(
      (settings) => emit(
        (
          hospital: state.hospital,
          themeMode: settings.themeMode,
          count: state.count,
        ),
      ),
    );
    _countSubscription = patientsRepository.watch().listen(
          (patients) => emit(
            (
              hospital: state.hospital,
              themeMode: state.themeMode,
              count: patients.length,
            ),
          ),
        );
  }
  @override
  get initialState => (
        hospital: hospitalRepository(),
        themeMode: settingsRepository.themeMode,
        count: patientsRepository.count(),
      );

  @override
  void dispose() {
    _hospitalSubscription?.cancel();
    _darkSubscription?.cancel();
    _countSubscription?.cancel();
    super.dispose();
  }
}

late _Home _home;

class HomePage extends UI {
  @override
  void didMountWidget(BuildContext context) {
    _home = _Home();
    FlutterNativeSplash.remove();
  }

  @override
  void didUnmountWidget() {
    _home.dispose();
    super.didUnmountWidget();
  }

  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'HOME'.text(),
        prefixActions: [
          FButton.icon(
            child: FIcon(FAssets.icons.menu),
            onPress: () {
              navigator.to(AppDrawer());
            },
          ),
        ],
        suffixActions: [
          FButton.icon(
            child: FIcon(FAssets.icons.personStanding),
            onPress: () {
              navigator.to(UserPage());
            },
          ),
          FButton.icon(
            onPress: () => _home(ToggleThemeModeHomeEvent()),
            child: FIcon(switch (_home().themeMode) {
              ThemeMode.system => FAssets.icons.puzzle,
              ThemeMode.light => FAssets.icons.sun,
              ThemeMode.dark => FAssets.icons.moon,
            }),
          ).pad(right: 8),
        ],
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FCard(
                subtitle: Row(
                  children: [
                    FIcon(FAssets.icons.badgeInfo).pad(),
                    Text('INFOROMATION SYSTEM').pad(),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('All attended patients'),
                    Text(
                      '${_home().count}',
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
                    FIcon(
                      FAssets.icons.hospital,
                    ).pad(),
                    _home().hospital.name.text().pad(),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _home().hospital.city.text(),
                    _home().hospital.info.text(),
                  ],
                ).pad(),
              ),
              SizedBox(height: 16),
              FCard(
                subtitle: Row(
                  children: [
                    FIcon(
                      FAssets.icons.hospital,
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
                    _buildActionButton(context, FAssets.icons.user, 'Patients',
                        () => navigator.to(PatientsPage())),
                    _buildActionButton(
                      context,
                      FAssets.icons.cassetteTape,
                      'Types',
                      () => navigator.to(PatientTypesPage()),
                    ),
                    _buildActionButton(
                      context,
                      FAssets.icons.pictureInPicture,
                      'Pictures',
                      () => navigator.to(const PicturesPage()),
                    ),
                    _buildActionButton(
                      context,
                      FAssets.icons.settings,
                      'Settings',
                      () => navigator.to(SettingsPage()),
                    ),
                    _buildActionButton(
                      context,
                      FAssets.icons.calendar,
                      'Duty Roster',
                      () => navigator.to(const DutyRoster()),
                    ),
                    _buildActionButton(
                      context,
                      FAssets.icons.file,
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
                    FIcon(
                      FAssets.icons.hospital,
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
    SvgAsset icon,
    String title,
    VoidCallback onTap,
  ) {
    return FButton(
      onPress: onTap,
      label: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FIcon(icon, size: 32),
          SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
