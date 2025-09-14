import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
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

class SettingsPage extends BlocWidget<SettingsBloc> {
  const SettingsPage({super.key});

  @override
  SettingsBloc createBloc() => SettingsBloc();

  @override
  Widget build(BuildContext context, SettingsBloc bloc) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('Settings'),
        prefixes: [
          FButton.icon(
            onPress: () => Navigator.of(context).pop(),
            child: const Icon(FIcons.arrowLeft),
          ),
        ],
        suffixes: [
          FButton.icon(
            onPress: bloc.logout,
            child: const Icon(FIcons.logOut),
          )
        ],
      ),
      child: ListView(
        children: [
          // Theme Mode Selection
          FLabel(
            axis: Axis.vertical,
            label: const Text('Theme Mode'),
            description: FTileGroup.builder(
              divider: FItemDivider.full,
              count: ThemeMode.values.length,
              tileBuilder: (context, index) {
                final mode = ThemeMode.values.elementAt(index);
                return FTile(
                  title: Text(mode.name.toUpperCase()),
                  onPress: () => bloc.setThemeMode(mode),
                );
              },
            ),
            child: FTile(
              title: Text('Current: ${bloc.themeMode.name.toUpperCase()}'),
            ),
          ),

          const FDivider(),

          // Hospital Settings
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FTextField(
              label: const Text('Clinic / Hospital Name'),
              initialText: bloc.hospital.name,
              onChange: bloc.changeHospitalName,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FTextField(
              label: const Text('Hospital City'),
              initialText: bloc.hospital.city,
              onChange: bloc.changeHospitalCity,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FTextField(
              label: const Text('Hospital Info'),
              initialText: bloc.hospital.info,
              onChange: bloc.changeHospitalInfo,
            ),
          ),

          const FDivider(),

          // User Information
          if (bloc.isAuthenticated) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('User Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  FBadge(child: Text('Name: ${bloc.userName}')),
                  const SizedBox(height: 8),
                  FBadge(child: Text('Email: ${bloc.userEmail}')),
                  const SizedBox(height: 8),
                  FBadge(child: Text('Type: ${bloc.userType}')),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
