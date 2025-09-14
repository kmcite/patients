import 'package:flutter/material.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/ui/settings_page.dart';
import 'package:patients/utils/architecture.dart';

class AppDrawerBloc extends Bloc {
  // Simple bloc for drawer - no specific logic needed
}

class AppDrawer extends Feature<AppDrawerBloc> {
  const AppDrawer({super.key});

  @override
  AppDrawerBloc createBloc() => AppDrawerBloc();

  @override
  Widget build(BuildContext context, AppDrawerBloc bloc) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Icon(
                    Icons.local_hospital,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Patients Management',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Healthcare System',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  context,
                  Icons.people,
                  'Patients',
                  'Manage patient records',
                  () {
                    Navigator.of(context).pop();
                    // TODO: Navigate to patients page
                  },
                ),
                _buildMenuItem(
                  context,
                  Icons.calendar_today,
                  'Appointments',
                  'Schedule and manage appointments',
                  () {
                    Navigator.of(context).pop();
                    // TODO: Navigate to appointments page
                  },
                ),
                _buildMenuItem(
                  context,
                  Icons.science,
                  'Investigations',
                  'Lab tests and medical investigations',
                  () {
                    Navigator.of(context).pop();
                    // TODO: Navigate to investigations page
                  },
                ),
                _buildMenuItem(
                  context,
                  Icons.medication,
                  'Medications',
                  'Prescription and medication management',
                  () {
                    Navigator.of(context).pop();
                    // TODO: Navigate to medications page
                  },
                ),
                _buildMenuItem(
                  context,
                  Icons.category,
                  'Patient Types',
                  'Manage patient categories',
                  () {
                    Navigator.of(context).pop();
                    // TODO: Navigate to patient types page
                  },
                ),
                _buildMenuItem(
                  context,
                  Icons.schedule,
                  'Duty Roster',
                  'Staff duty scheduling',
                  () {
                    Navigator.of(context).pop();
                    // TODO: Navigate to duty roster page
                  },
                ),
                const Divider(),
                _buildMenuItem(
                  context,
                  Icons.settings,
                  'Settings',
                  'App preferences and configuration',
                  () {
                    Navigator.of(context).pop();
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

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
