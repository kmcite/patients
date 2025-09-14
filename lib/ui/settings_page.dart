import 'package:flutter/material.dart';
import 'package:patients/domain/api/authentication_repository.dart';
import 'package:patients/domain/api/hospital_repository.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/domain/models/hospital.dart';
import 'package:patients/utils/architecture.dart';

class SettingsBloc extends Bloc {
  late final SettingsRepository settingsRepository;
  late final HospitalRepository hospitalRepository;
  late final AuthenticationRepository authRepository;

  @override
  void initState() {
    settingsRepository = watch<SettingsRepository>();
    hospitalRepository = watch<HospitalRepository>();
    authRepository = watch<AuthenticationRepository>();
  }

  Hospital get hospital => hospitalRepository.hospital;
  String get clinicName => settingsRepository.clinicName;
  ThemeMode get themeMode => settingsRepository.themeMode;

  void changeHospitalName(String name) {
    hospitalRepository.updateHospital(hospital.copyWith(name: name));
  }

  void changeHospitalCity(String name) {
    hospitalRepository.updateHospital(hospital.copyWith(city: name));
  }

  void changeHospitalInfo(String name) {
    hospitalRepository.updateHospital(hospital.copyWith(info: name));
  }

  void setThemeMode(ThemeMode mode) {
    settingsRepository.setThemeMode(mode);
  }

  Future<void> logout() async {
    await authRepository.logout();
  }

  bool get isAuthenticated => authRepository.isAuthenticated;
  String get userName => authRepository.currentUser?.name ?? 'Unknown';
  String get userEmail => authRepository.currentUser?.email ?? 'Unknown';
  String get userType => authRepository.currentUser?.userType.name ?? 'Unknown';
}

class SettingsPage extends Feature<SettingsBloc> {
  const SettingsPage({super.key});

  @override
  SettingsBloc createBloc() => SettingsBloc();

  @override
  Widget build(BuildContext context, SettingsBloc bloc) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: bloc.logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
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
                  ...ThemeMode.values.map((mode) => RadioListTile<ThemeMode>(
                        title: Text(_getThemeModeLabel(mode)),
                        value: mode,
                        groupValue: bloc.themeMode,
                        onChanged: (value) {
                          if (value != null) bloc.setThemeMode(value);
                        },
                        contentPadding: EdgeInsets.zero,
                      )),
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
                    initialValue: bloc.hospital.name,
                    decoration: const InputDecoration(
                      labelText: 'Hospital / Clinic Name',
                      prefixIcon: Icon(Icons.business),
                    ),
                    onChanged: bloc.changeHospitalName,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: bloc.hospital.city,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    onChanged: bloc.changeHospitalCity,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: bloc.hospital.info,
                    decoration: const InputDecoration(
                      labelText: 'Additional Information',
                      prefixIcon: Icon(Icons.info),
                    ),
                    maxLines: 3,
                    onChanged: bloc.changeHospitalInfo,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // User Information Card
          if (bloc.isAuthenticated) ...[
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
                    _buildInfoRow(context, 'Name', bloc.userName, Icons.person),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                        context, 'Email', bloc.userEmail, Icons.email),
                    const SizedBox(height: 8),
                    _buildInfoRow(context, 'Role', bloc.userType.toUpperCase(),
                        Icons.badge),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: bloc.logout,
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System Default';
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
    }
  }

  Widget _buildInfoRow(
      BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
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
