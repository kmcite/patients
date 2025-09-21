import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/ui/appointments.dart';
import 'package:patients/ui/investigations.dart';
import 'package:patients/ui/medications.dart';
import 'package:patients/ui/patient_types/patient_types.dart';
import 'package:patients/ui/patients/patients.dart';
import 'package:patients/ui/personal/duty_roster.dart';
import 'package:patients/ui/settings.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class AppDrawerBloc extends Bloc<AppDrawer> {
  // Simple bloc for drawer - no specific logic needed
}

class AppDrawer extends Feature<AppDrawerBloc> {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => navigator.back(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 8,
              children: [
                Icon(
                  Icons.local_hospital,
                  size: 60,
                ),
                Text(
                  'Patients Management',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Healthcare System',
                  style: theme.textTheme.bodyMedium?.copyWith(),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                MenuItemView(
                  Icons.people,
                  'Patients',
                  'Manage patient records',
                  () {
                    navigator.back();
                    navigator.to(const PatientsView());
                  },
                ),
                MenuItemView(
                  Icons.calendar_today,
                  'Appointments',
                  'Schedule and manage appointments',
                  () {
                    navigator.back();
                    navigator.to(
                        const AppointmentsPage()); // Navigate to appointments page
                  },
                ),
                MenuItemView(
                  Icons.science,
                  'Investigations',
                  'Lab tests and medical investigations',
                  () {
                    navigator.back();
                    navigator.to(const InvestigationsPage());
                  },
                ),
                MenuItemView(
                  Icons.medication,
                  'Medications',
                  'Prescription and medication management',
                  () {
                    navigator.back();
                    navigator.to(
                      const MedicationsPage(),
                    ); // Navigate to medications page
                  },
                ),
                MenuItemView(
                  Icons.category,
                  'Patient Types',
                  'Manage patient categories',
                  () {
                    navigator.back();
                    navigator.to(
                      const PatientTypesPage(),
                    ); // Navigate to patient types page
                  },
                ),
                MenuItemView(
                  Icons.schedule,
                  'Duty Roster',
                  'Staff duty scheduling',
                  () {
                    navigator.back();
                    navigator.to(const DutyRoster());
                  },
                ),
                const Divider(height: 0),
                MenuItemView(
                  Icons.settings,
                  'Settings',
                  'App preferences and configuration',
                  () {
                    navigator.back();
                    navigator.to(const SettingsPage());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItemView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const MenuItemView(
    this.icon,
    this.title,
    this.subtitle,
    this.onTap, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
