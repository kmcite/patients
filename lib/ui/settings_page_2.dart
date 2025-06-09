import 'package:forui/forui.dart';
import 'package:patients/domain/api/authentication_repository.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/domain/models/authentication.dart';
import 'package:patients/main.dart';
import 'package:patients/ui/login_page.dart';
import 'package:patients/ui/add_doctor_dialog.dart';

mixin SettingsBloc {
  void logout() {
    authentication = Authentication();
    navigator.toAndRemoveUntil(LoginPage());
  }

  // final authentication = authenticationRepository.authentication;
  final clinicName = settingsRepository.clinicName;
  // final themeMode = settingsRepository.themeMode;
}

class SettingsPage extends UI with SettingsBloc {
  SettingsPage({super.key});
  @override
  Widget build(context) {
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
            onPress: () => logout(),
            child: Icon(FIcons.logOut),
          )
        ],
      ),
      child: ListView(
        children: [
          FLabel(
            axis: Axis.vertical,
            description: FTileGroup.builder(
              divider: FTileDivider.full,
              count: ThemeMode.values.length,
              tileBuilder: (context, index) {
                final mode = ThemeMode.values.elementAt(index);
                return FTile(
                  title: mode.name.toUpperCase().text(),
                  onPress: () {
                    // this.themeMode(mode);
                  },
                );
              },
            ),
            child: FTile(
              title: (dark ? 'DARK' : 'LIGHT').text(),
            ),
          ),
          FDivider(),
          FTextField(
            label: Text('Clinic / Hospital Name'),
            initialText: clinicName(),
            onChange: clinicName,
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
