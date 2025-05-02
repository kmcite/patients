import 'package:patients/ui/app_drawer.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/ui/patient_types/patient_types_page.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/ui/pictures/pictures_page.dart';

import '../main.dart';

mixin class HomePageBloc {
  Modifier<bool> get dark => darkRepository.dark;

  int get patientsCount => patientsRepository().length;
}

class HomePage extends UI with HomePageBloc {
  static String name = '';

  @override
  void didMountWidget(BuildContext context) {
    FlutterNativeSplash.remove();
  }

  HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'HOME'.text(),
        actions: [
          IconButton(
            icon: Icon(dark() ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              dark(!dark());
            },
          ).pad(right: 8),
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
                      () => navigator.to(PatientsPage())),
                  _buildActionCard(context, Icons.category, 'Patient Types',
                      () => navigator.to(PatientTypesPage())),
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
            Icon(icon, size: 32),
            SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
