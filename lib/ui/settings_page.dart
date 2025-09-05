import 'package:forui/forui.dart';
import 'package:patients/domain/api/hospital_repository.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/domain/models/hospital.dart';
import 'package:patients/main.dart';
import 'package:patients/ui/add_doctor_dialog.dart';

import '../domain/api/authentication_repository.dart';

class SettingsBloc extends Bloc {
  late final SettingsRepository settingsRepository = watch();
  late final HospitalRepository hospitalRepository = watch();

  static const double paddingValue = 16.0;
  static const double borderRadiusValue = 12.0;
  static const double iconSize = 24.0;

  Hospital get hospital => hospitalRepository();

  void changeHospitalName(String name) {
    hospitalRepository(hospital.copyWith(name: name));
  }

  void changeHospitalCity(String name) {
    hospitalRepository(hospital.copyWith(city: name));
  }

  void changeHospitalInfo(String name) {
    hospitalRepository(hospital.copyWith(info: name));
  }

  // void restoreInvestigations() {}
  // void toggleThemeMode() {
  //   // darkRepository.state = !dark;
  // }
  void logout() {
    // authentication = Authentication();
    // navigator.toAndRemoveUntil(LoginPage());
  }

  // final authentication = authenticationRepository.authentication;
  String get clinicName => settingsRepository.clinicName;
  ThemeMode get themeMode => settingsRepository.themeModeToggler();

  bool get dark => settingsRepository.dark;

  void setThemeMode(ThemeMode mode) {
    settingsRepository.setThemeMode(mode);
  }
}

class SettingsPage extends UI<SettingsBloc> {
  @override
  SettingsBloc create() => SettingsBloc();

  const SettingsPage({super.key});
  @override
  Widget build(context, bloc) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('Settings'),
        prefixes: [
          FButton.icon(
            onPress: () => navigator.back(),
            child: Icon(FIcons.arrowLeft),
          ),
        ],
        suffixes: [
          FButton.icon(
            onPress: () => bloc.logout(),
            child: Icon(FIcons.logOut),
          )
        ],
      ),
      child: ListView(
        children: [
          FLabel(
            axis: Axis.vertical,
            description: FTileGroup.builder(
              divider: FItemDivider.full,
              count: ThemeMode.values.length,
              tileBuilder: (context, index) {
                final mode = ThemeMode.values.elementAt(index);
                return FTile(
                  title: mode.name.toUpperCase().text(),
                  onPress: () {
                    bloc.setThemeMode(mode);
                  },
                );
              },
            ),
            child: FTile(
              title: (bloc.themeMode.name.toUpperCase()).text(),
            ),
          ),
          FDivider(),
          FTextField(
            label: Text('Clinic / Hospital Name'),
            initialText: bloc.hospital.name,
            onChange: bloc.changeHospitalName,
          ).pad(),
          FDivider(),
          FButton(
            onPress: () => navigator.toDialog(AddDoctorDialog()),
            child: "Create a Doctor".text(),
          ).pad(),
          FDivider(),
          FBadge(
            child: authentication.name.text(),
          ).pad(),
          FBadge(
            child: authentication.userType.text(),
          ).pad(),
          FBadge(
            child: authentication.email.text(),
          ).pad(),
          FBadge(
            child: authentication.password.text(),
          ).pad(),
        ],
      ),
    );
  }
}
