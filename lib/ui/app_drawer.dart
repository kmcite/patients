import 'package:forui/forui.dart';
import 'package:patients/main.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/ui/patient_types/patient_types_page.dart';
import 'package:patients/ui/pictures/pictures_page.dart';
import 'package:patients/ui/settings_page.dart';

class AppDrawer extends UI {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: Column(
          children: [
            FAvatar.raw(
              size: 120,
              child: FIcon(
                FAssets.icons.hospital,
                size: 80,
              ),
            ).pad(),
            Text(
              'Patients',
              style: TextStyle(
                fontSize: 24,
              ),
            ).pad(),
          ],
        ),
      ),
      content: FTileGroup(
        label: FButton.icon(
          child: FIcon(FAssets.icons.x),
          onPress: () => navigator.back(),
        ),
        divider: FTileDivider.full,
        children: [
          FTile(
            prefixIcon: FIcon(FAssets.icons.user),
            title: Text('Patients'),
            onPress: () => navigator
              ..back()
              ..to(PatientsPage()),
          ),
          FTile(
            prefixIcon: FIcon(FAssets.icons.type),
            title: Text('Patient Types'),
            onPress: () => navigator
              ..back()
              ..to(PatientTypesPage()),
          ),
          FTile(
            prefixIcon: FIcon(FAssets.icons.pictureInPicture2),
            title: Text('Pictures'),
            onPress: () {
              navigator
                ..back()
                ..to(const PicturesPage());
            },
          ),
          FTile(
            prefixIcon: FIcon(FAssets.icons.settings2),
            title: Text('Settings'),
            onPress: () => navigator
              ..back()
              ..to(SettingsPage()),
          ),
          FTile(
            prefixIcon: FIcon(FAssets.icons.calendar),
            title: Text('Duty Roster'),
            onPress: () => navigator
              ..back()
              ..to(const DutyRoster()),
          ),
        ],
      ),
    );
  }
}
