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
              child: Icon(
                FIcons.hospital,
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
      child: FTileGroup(
        label: FButton.icon(
          child: Icon(FIcons.x),
          onPress: () => navigator.back(),
        ),
        divider: FTileDivider.full,
        children: [
          FTile(
            prefixIcon: Icon(FIcons.user),
            title: Text('Patients'),
            onPress: () => navigator
              ..back()
              ..to(PatientsPage()),
          ),
          FTile(
            prefixIcon: Icon(FIcons.type),
            title: Text('Patient Types'),
            onPress: () => navigator
              ..back()
              ..to(PatientTypesPage()),
          ),
          FTile(
            prefixIcon: Icon(FIcons.pictureInPicture2),
            title: Text('Pictures'),
            onPress: () {
              navigator
                ..back()
                ..to(const PicturesPage());
            },
          ),
          FTile(
            prefixIcon: Icon(FIcons.settings2),
            title: Text('Settings'),
            onPress: () => navigator
              ..back()
              ..to(SettingsPage()),
          ),
          FTile(
            prefixIcon: Icon(FIcons.calendar),
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
