import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/domain/api/hospital_repository.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/ui/new_quick_patient.dart';
import 'package:patients/ui/app_drawer.dart';
import 'package:patients/ui/investigations.dart';
import 'package:patients/ui/patients/patients.dart';
import 'package:patients/ui/personal/user.dart';
import 'package:patients/ui/settings.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class HomeBloc extends Bloc<HomeView> {
  late final settingsRepository = watch<SettingsRepository>();
  late final patientsRepository = watch<PatientsRepository>();
  late final hospital = watch<HospitalRepository>();

  @override
  void initState() {
    FlutterNativeSplash.remove();
  }

  bool get dark => settingsRepository.themeMode == ThemeMode.dark;
  int get patientsCount => patientsRepository.patients.hasData
      ? patientsRepository.patients.data!.length
      : 0;

  void toggleDark() {
    if (dark) {
      settingsRepository.setThemeMode(ThemeMode.light);
    } else {
      settingsRepository.setThemeMode(ThemeMode.dark);
    }
  }
}

class HomeView extends Feature<HomeBloc> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => navigator.to(const AppDrawer()),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => navigator.to(const UserPage()),
          ),
          IconButton(
            icon: Icon(controller.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: controller.toggleDark,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.local_hospital,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Welcome..!',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.hospital.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Total Patients',
                    value: '${controller.patientsCount}',
                    icon: Icons.people,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'Today\'s Visits',
                    value: '12',
                    icon: Icons.today,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Quick Actions Section
            Text(
              'Quick Actions',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                ActionCard(
                    title: 'Patients',
                    icon: Icons.people,
                    color: theme.colorScheme.primary,
                    onTap: () {
                      navigator.to(const PatientsView());
                    }),
                ActionCard(
                    title: 'Appointments',
                    icon: Icons.calendar_today,
                    color: theme.colorScheme.secondary,
                    onTap: () {
                      // navigator.to(const AppointmentsPage());
                    }),
                ActionCard(
                  title: 'Investigations',
                  icon: Icons.science,
                  color: theme.colorScheme.tertiary,
                  onTap: () {
                    navigator.to(const InvestigationsPage());
                  },
                ),
                ActionCard(
                    title: 'Settings',
                    icon: Icons.settings,
                    color: theme.colorScheme.outline,
                    onTap: () => navigator.to(const SettingsPage())),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await navigator.toDialog<Patient>(const NewQuickPatientView());
        },
        icon: const Icon(Icons.add),
        label: const Text('New Patient'),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(
                  value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(
                    // red: theme.colorScheme.primary.red,
                    // green: theme.colorScheme.primary.green,
                    // blue: theme.colorScheme.primary.blue,
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
