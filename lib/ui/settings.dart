import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/domain/api/authentication_repository.dart';
import 'package:patients/domain/api/hospital_repository.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/ui/authentication.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class SettingsBloc extends Bloc<SettingsPage> {
  late final settingsRepository = watch<SettingsRepository>();
  late final hospitalRepository = watch<HospitalRepository>();
  late final authenticationRepository = watch<AuthenticationRepository>();

  String get hospitalName => hospitalRepository.name;
  String get hospitalCity => hospitalRepository.city;
  String get hospitalInfo => hospitalRepository.info;
  ThemeMode get themeMode => settingsRepository.themeMode;

  void onHospitalNameChanged(String name) {
    hospitalRepository.onNameChanged(name);
  }

  void onHospitalCityChanged(String name) {
    hospitalRepository.onCityChanged(name);
  }

  void onHospitalInfoChanged(String name) {
    hospitalRepository.onInfoChanged(name);
  }

  void onThemeModeChanged(ThemeMode? mode) {
    settingsRepository.setThemeMode(mode!);
  }

  void onThemeModeToggled() {
    settingsRepository.setThemeMode(
      themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
    );
  }

  Future<void> onLoggedOut() async {
    await authenticationRepository.logout();
    await navigator.toAndRemoveUntil(AuthenticationView());
  }

  bool get isAuthenticated => authenticationRepository.isAuthenticated;
  String get userName =>
      authenticationRepository.currentUser?.name ?? 'Unknown';
  String get userEmail =>
      authenticationRepository.currentUser?.email ?? 'Unknown';
  String get userType =>
      authenticationRepository.currentUser?.userType.name ?? 'Unknown';
}

class SettingsPage extends Feature<SettingsBloc> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.onLoggedOut,
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          // Theme Settings Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.palette,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Appearance',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Theme Mode',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: controller.onThemeModeToggled,
                    child: Text(controller.themeMode.name.toUpperCase()),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Hospital Settings Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_hospital,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Hospital Information',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: controller.hospitalName,
                    decoration: const InputDecoration(
                      labelText: 'Hospital / Clinic Name',
                      prefixIcon: Icon(Icons.business),
                    ),
                    onChanged: controller.onHospitalNameChanged,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: controller.hospitalCity,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    onChanged: controller.onHospitalCityChanged,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: controller.hospitalInfo,
                    decoration: const InputDecoration(
                      labelText: 'Additional Information',
                      prefixIcon: Icon(Icons.info),
                    ),
                    maxLines: 3,
                    onChanged: controller.onHospitalInfoChanged,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // User Information Card
          if (controller.isAuthenticated) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'User Information',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                        context, 'Name', controller.userName, Icons.person),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                        context, 'Email', controller.userEmail, Icons.email),
                    const SizedBox(height: 8),
                    _buildInfoRow(context, 'Role',
                        controller.userType.toUpperCase(), Icons.badge),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
