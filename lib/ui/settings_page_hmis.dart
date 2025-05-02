import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:patients/domain/api/hospital_repository.dart';
import 'package:patients/domain/api/investigations.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/main.dart';
import 'package:patients/ui/custom_app_bar.dart';

const double paddingValue = 16.0;
const double borderRadiusValue = 12.0;
const double iconSize = 24.0;

class SettingsPage extends EUI {
  static const name = 'settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(paddingValue),
        children: [
          _buildHospitalTile(context),
          const SizedBox(height: paddingValue),
          _buildThemeToggleButton(context),
          const SizedBox(height: paddingValue),
          _buildInvestigationsButton(context),
        ],
      ),
    );
  }

  Widget _buildHospitalTile(BuildContext context) {
    return ListTile(
      title: const Text('HOSPITAL INFORMATIONS'),
      subtitle: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'NAME',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusValue),
              ),
            ),
            initialValue: settingsRepository.userName,
            onChanged: (name) => Events(HospitalNameChangedEvent(name)),
            maxLength: 4,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'CITY',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusValue),
              ),
            ),
            initialValue: hospitalRepository.city,
            onChanged: (city) => Events(HospitalCityChangedEvent(city)),
            maxLength: 20,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'INFORMATIONS',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusValue),
              ),
            ),
            initialValue: hospitalRepository.info,
            onChanged: (info) => Events(HospitalInfoChangedEvent(info)),
            minLines: 2,
            maxLength: 50,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggleButton(BuildContext context) {
    return FilledButton(
      onPressed: () => Events(ThemeModeToggledEvent(context)),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(FontAwesomeIcons.circleHalfStroke),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Toggle Theme Mode'),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestigationsButton(BuildContext context) {
    return FilledButton(
      onPressed: context
              .of<InvestigationsBloc>()
              .investigations
              .toSet()
              .containsAll([])
          ? null
          : () {
              // for (final investigation in investigationsBuiltIn) {
              //   if (!context.of<InvestigationsBloc>().state.contains(
              //         investigation,
              //       )) {
              //     context.of<InvestigationsBloc>().put(investigation);
              //   }
              // }
            },
      child: Row(
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(FontAwesomeIcons.flask),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Built-In Investigations'),
          ),
        ],
      ),
    );
  }
}
