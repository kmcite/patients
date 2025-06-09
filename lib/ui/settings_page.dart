import 'package:forui/forui.dart';
import 'package:manager/dark/dark_repository.dart';
import 'package:patients/domain/api/hospital_repository.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/main.dart';

const double paddingValue = 16.0;
const double borderRadiusValue = 12.0;
const double iconSize = 24.0;

void changeHospitalName(String name) {
  hospitalRepository(hospital.copyWith(name: name));
}

void changeHospitalCity(String name) {
  hospitalRepository(hospital.copyWith(city: name));
}

void changeHospitalInfo(String name) {
  hospitalRepository(hospital.copyWith(info: name));
}

void restoreInvestigations() {}
void toggleThemeMode() {
  darkRepository.state = !dark;
}

class SettingsPage extends UI {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FButton.icon(
            child: Icon(FIcons.x),
            onPress: () => navigator.back(),
          ),
        ],
        title: Text('Settings'),
      ),
      child: ListView(
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
          initialText: hospital.name,
          onChange: changeHospitalName,
          maxLength: 4,
        ),
        FTextField(
          label: Text('CITY'),
          initialText: hospital.city,
          onChange: changeHospitalCity,
          maxLength: 20,
        ),
        FTextField(
          label: Text('INFORMATIONS'),
          initialText: hospital.info,
          onChange: changeHospitalInfo,
          minLines: 2,
          maxLength: 50,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildThemeToggleButton(BuildContext context) {
    return FButton(
      onPress: toggleThemeMode,
      child: Row(
        children: [
          Icon(
            switch (themeMode) {
              ThemeMode.system => FIcons.settings,
              ThemeMode.light => FIcons.sun,
              ThemeMode.dark => FIcons.moon,
            },
          ).pad(),
          Text(themeMode.name.toUpperCase()),
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
        restoreInvestigations();
      },
      child: Row(
        children: [
          Icon(FIcons.flaskRound).pad(),
          Text('RESTORE INVESTIGATIONS'),
        ],
      ),
    );
  }
}
