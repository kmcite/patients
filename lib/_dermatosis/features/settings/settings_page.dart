import 'package:forui/forui.dart';
import 'package:patients/_dermatosis/domain/api/authentication_repository.dart';
import 'package:patients/_dermatosis/domain/api/settings_repository.dart';
import 'package:patients/_dermatosis/domain/models/authentication.dart';
import 'package:patients/_dermatosis/features/authentication/login_page.dart';
import 'package:patients/_dermatosis/features/settings/add_doctor_dialog.dart';
import 'package:patients/_dermatosis/navigator.dart';

import '../../main.dart';

mixin SettingsBloc {
  void logout() {
    authenticationRepository.authentication(Authentication());
    navigator.toAndRemoveUntil(LoginPage());
  }

  final authentication = authenticationRepository.authentication;
  final clinicName = settingsRepository.clinicName;
  final themeMode = settingsRepository.themeMode;
}

class SettingsPage extends UI with SettingsBloc {
  SettingsPage({super.key});
  @override
  Widget build(context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('Settings'),
        prefixActions: [
          FButton.icon(
            onPress: () => navigator.back(),
            child: FIcon(FAssets.icons.arrowLeft),
          ),
        ],
        suffixActions: [
          FButton.icon(
            onPress: () => logout(),
            child: FIcon(FAssets.icons.logOut),
          )
        ],
      ),
      content: ListView(
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
                    themeMode(mode);
                  },
                );
              },
            ),
            child: FTile(
              title: themeMode().name.toUpperCase().text(),
            ),
          ),
          FDivider(),
          FTextField(
            label: Text('Clinic / Hospital Name'),
            initialValue: clinicName(),
            onChange: clinicName,
          ).pad(),
          FDivider(),
          FButton(
            onPress: () => navigator.toDialog(AddDoctorDialog()),
            label: "Create a Doctor".text(),
          ).pad(),
          FDivider(),
          FBadge(
            label: authentication().name.text(),
          ).pad(),
          FBadge(
            label: authentication().userType.text(),
          ).pad(),
          FBadge(
            label: authentication().email.text(),
          ).pad(),
          FBadge(
            label: authentication().password.text(),
          ).pad(),
        ],
      ),
    );
  }
}
