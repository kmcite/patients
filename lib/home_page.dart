import 'package:patients/navigation/navigation_bloc.dart';
import 'package:patients/patient_types/patient_types_page.dart';
import 'package:patients/patients/patients_repository.dart';
import 'package:patients/pictures/pictures_page.dart';

import 'main.dart';

mixin class HomePageBloc {
  final patientsCountRM = RM.inject(() => patientsRepository.count());
  int get patientsCount => patientsCountRM.state;
}

class HomePage extends UI with HomePageBloc {
  HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'HOME'.text(),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Information System',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'These are the patients I have attended in my duties',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      SizedBox(height: 16),
                      Text(
                        '$patientsCount',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildActionCard(context, Icons.people, 'Patients List',
                      () => navigator.to(const PatientsPage())),
                  _buildActionCard(context, Icons.category, 'Patient Types',
                      () => navigator.to(const PatientTypesPage())),
                  _buildActionCard(context, Icons.photo_library, 'Pictures',
                      () => navigator.to(const PicturesPage())),
                  _buildActionCard(context, Icons.settings, 'Settings',
                      () => navigator.to(SettingsPage())),
                  _buildActionCard(context, Icons.calendar_today, 'Duty Roster',
                      () => navigator.to(const RosterPage())),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Upcoming Duties',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 8),
              UpcomingDuties(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

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
              onTap: () => navigator.toFromDrawer(const PatientsPage()),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Patient Types'),
              onTap: () => navigator.toFromDrawer(const PatientTypesPage()),
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Pictures'),
              onTap: () => navigator.toFromDrawer(const PicturesPage()),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => navigator.toFromDrawer(SettingsPage()),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Duty Roster'),
              onTap: () => navigator.toFromDrawer(const RosterPage()),
            ),
          ],
        ),
      ),
    );
  }
}
