import 'dart:async';

import 'package:forui/forui.dart';
import 'package:patients/domain/api/hospital_repository.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/domain/models/hospital.dart';
import 'package:patients/main.dart';

const double paddingValue = 16.0;
const double borderRadiusValue = 12.0;
const double iconSize = 24.0;

class SettingsEvent {
  const SettingsEvent();
}

class HospitalNameChangedEvent extends SettingsEvent {
  final String name;
  const HospitalNameChangedEvent(this.name);
}

class HospitalCityChangedEvent extends SettingsEvent {
  final String city;
  const HospitalCityChangedEvent(this.city);
}

class HospitalInfoChangedEvent extends SettingsEvent {
  final String info;
  const HospitalInfoChangedEvent(this.info);
}

class RestoreInvestigationsEvent extends SettingsEvent {}

class ThemeModeToggledEvent extends SettingsEvent {
  final BuildContext context;
  const ThemeModeToggledEvent(this.context);
}

final settingsBloc = SettingsBloc();

typedef SettingsState = ({
  Hospital hospital,
  ThemeMode themeMode,
});

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  StreamSubscription<Hospital>? _subscription;
  SettingsBloc() {
    on<HospitalNameChangedEvent>(
      (event) {
        hospitalRepository(
          state.hospital.copyWith(name: event.name),
        );
      },
    );
    on<HospitalCityChangedEvent>(
      (event) {
        hospitalRepository(
          state.hospital.copyWith(city: event.city),
        );
      },
    );
    on<HospitalInfoChangedEvent>(
      (event) {
        hospitalRepository(
          state.hospital.copyWith(info: event.info),
        );
      },
    );
    on<ThemeModeToggledEvent>(
      (event) {
        final themeMode = switch (settingsRepository.themeMode) {
          ThemeMode.system => ThemeMode.light,
          ThemeMode.light => ThemeMode.dark,
          ThemeMode.dark => ThemeMode.system,
        };
        settingsRepository.setThemeMode(themeMode);
        emit(
          (hospital: state.hospital, themeMode: themeMode),
        );
      },
    );
    on<RestoreInvestigationsEvent>(
      (event) {
        // for (final investigation in investigationsBuiltIn) {
        //   if (!context.of<InvestigationsBloc>().state.contains(
        //         investigation,
        //       )) {
        //     context.of<InvestigationsBloc>().put(investigation);
        //   }
        // }
      },
    );
    _subscription = hospitalRepository.stream.listen(
      (hospital) {
        emit(
          (hospital: hospital, themeMode: state.themeMode),
        );
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  get initialState => (
        hospital: hospitalRepository(),
        themeMode: settingsRepository.themeMode,
      );
}

class SettingsPage extends UI {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixActions: [
          FButton.icon(
            child: FIcon(FAssets.icons.x),
            onPress: () => navigator.back(),
          ),
        ],
        title: Text('Settings'),
      ),
      content: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(paddingValue),
        children: [
          _buildThemeToggleButton(context),
          const SizedBox(height: paddingValue),
          _buildInvestigationsButton(context),
          const SizedBox(height: paddingValue),
          _buildHospitalTile(context),
        ],
      ),
    );
  }

  Widget _buildHospitalTile(BuildContext context) {
    return Column(
      children: [
        Text('HOSPITAL INFORMATIONS'),
        FTextField(
          label: Text('NAME'),
          initialValue: settingsBloc().hospital.name,
          onChange: (name) => settingsBloc(HospitalNameChangedEvent(name)),
          maxLength: 4,
        ),
        FTextField(
          label: Text('CITY'),
          initialValue: settingsBloc().hospital.city,
          onChange: (city) => settingsBloc(HospitalCityChangedEvent(city)),
          maxLength: 20,
        ),
        FTextField(
          label: Text('INFORMATIONS'),
          initialValue: settingsBloc().hospital.info,
          onChange: (info) => settingsBloc(HospitalInfoChangedEvent(info)),
          minLines: 2,
          maxLength: 50,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildThemeToggleButton(BuildContext context) {
    return FButton(
      onPress: () => settingsBloc(ThemeModeToggledEvent(context)),
      label: Row(
        children: [
          FIcon(
            switch (settingsBloc().themeMode) {
              ThemeMode.system => FAssets.icons.settings,
              ThemeMode.light => FAssets.icons.sun,
              ThemeMode.dark => FAssets.icons.moon,
            },
          ).pad(),
          Text(settingsBloc().themeMode.name.toUpperCase()),
        ],
      ),
    );
  }

  Widget _buildInvestigationsButton(BuildContext context) {
    return FButton(
      onPress:
          // investigationsRepository.getAll().toSet().containsAll([])
          //     ? null
          //     :
          () {
        settingsBloc(RestoreInvestigationsEvent());
      },
      label: Row(
        children: [
          FIcon(FAssets.icons.flaskRound).pad(),
          Text('RESTORE INVESTIGATIONS'),
        ],
      ),
    );
  }
}
