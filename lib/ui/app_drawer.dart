import 'package:patients/main.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/ui/patient_types/patient_types_page.dart';
import 'package:patients/ui/pictures/pictures_page.dart';

class AppDrawer extends UI {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    child: Icon(
                      Icons.local_hospital,
                      size: 80,
                    ),
                  ).pad(),
                  Text(
                    'Patients',
                    style: TextStyle(
                      // color: Colors.white,
                      fontSize: 24,
                    ),
                  ).pad(),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Patients'),
              onTap: () => navigator
                ..back()
                ..to(PatientsPage()),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Patient Types'),
              onTap: () => navigator
                ..back()
                ..to(PatientTypesPage()),
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Pictures'),
              onTap: () {
                navigator
                  ..back()
                  ..to(const PicturesPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => navigator
                ..back()
                ..to(SettingsPage()),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Duty Roster'),
              onTap: () => navigator
                ..back()
                ..to(const RosterPage()),
            ),
          ],
        ),
      ),
    );
  }
}
