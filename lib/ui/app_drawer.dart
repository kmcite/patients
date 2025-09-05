import 'package:forui/forui.dart';
import 'package:patients/main.dart';
import 'package:patients/ui/settings_page.dart';

class AppDrawerBloc extends Bloc {}

class AppDrawer extends UI<AppDrawerBloc> {
  @override
  AppDrawerBloc create() => AppDrawerBloc();

  const AppDrawer({super.key});

  @override
  Widget build(context, bloc) {
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
        divider: FItemDivider.full,
        children: [
          FTile(
            prefix: Icon(FIcons.user),
            title: Text('Patients'),
            onPress: () {
              // navigator
              // ..back()
              // ..to(PatientsPage());
            },
          ),
          FTile(
            prefix: Icon(FIcons.type),
            title: Text('Patient Types'),
            onPress: () {
              // navigator
              // ..back()
              // ..to(PatientTypesPage());
            },
          ),
          FTile(
            prefix: Icon(FIcons.pictureInPicture2),
            title: Text('Pictures'),
            onPress: () {
              //   navigator
              //     ..back()
              //     ..to(const PicturesPage());
            },
          ),
          FTile(
            prefix: Icon(FIcons.settings2),
            title: Text('Settings'),
            onPress: () {
              navigator
                ..back()
                ..to(SettingsPage());
            },
          ),
          FTile(
            prefix: Icon(FIcons.calendar),
            title: Text('Duty Roster'),
            onPress: () {
              // navigator
              // ..back()
              // ..to(const DutyRoster());
            },
          ),
        ],
      ),
    );
  }
}
