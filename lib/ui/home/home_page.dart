import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/ui/add_patient_dialog.dart';
import 'package:patients/ui/app_drawer.dart';
import 'package:patients/ui/investigations_page.dart';
import 'package:patients/ui/patients/patients_page.dart';
import 'package:patients/ui/personal/user_page.dart';
import 'package:patients/ui/settings_page.dart';
import 'package:patients/utils/architecture.dart';

class HomeBloc extends Bloc {
  late final SettingsRepository settingsRepository;
  late final PatientsRepository patientsRepository;

  @override
  void initState() {
    settingsRepository = watch<SettingsRepository>();
    patientsRepository = watch<PatientsRepository>();
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

class HomePage extends Feature<HomeBloc> {
  const HomePage({super.key});

  @override
  HomeBloc createBloc() => HomeBloc();

  @override
  Widget build(BuildContext context, HomeBloc bloc) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients Management'),
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
            icon: Icon(bloc.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: bloc.toggleDark,
          ),
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
                          'Welcome to Patients Management',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Emergency and Trauma Center',
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
                  child: _buildStatCard(
                    context,
                    'Total Patients',
                    '${bloc.patientsCount}',
                    Icons.people,
                    theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Today\'s Visits',
                    '12', // TODO: Get actual count
                    Icons.today,
                    theme.colorScheme.secondary,
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
                _buildActionCard(
                  context,
                  'Patients',
                  Icons.people,
                  theme.colorScheme.primary,
                  () {
                    navigator.to(const PatientsPage());
                  },
                ),
                _buildActionCard(
                  context,
                  'Appointments',
                  Icons.calendar_today,
                  theme.colorScheme.secondary,
                  () {
                    // TODO: Navigate to appointments page
                  },
                ),
                _buildActionCard(
                  context,
                  'Investigations',
                  Icons.science,
                  theme.colorScheme.tertiary,
                  () {
                    navigator.to(const InvestigationsPage());
                  },
                ),
                _buildActionCard(
                  context,
                  'Settings',
                  Icons.settings,
                  theme.colorScheme.outline,
                  () => navigator.to(const SettingsPage()),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await navigator.toDialog<Patient>(const AddPatientDialog());
        },
        icon: const Icon(Icons.add),
        label: const Text('New Patient'),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
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

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
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
                  color: color.withOpacity(0.1),
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
