import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forui/forui.dart';
import 'package:patients/domain/api/hospital_repository.dart';
import 'package:patients/domain/api/router_bloc.dart';
import 'package:patients/ui/custom_app_bar.dart';
import 'package:patients/ui/investigations_page.dart';

import '../main.dart';

class HomePage extends EUI {
  static const name = 'home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: const SizedBox(),
        title: 'HMIS',
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: .3,
            child: Align(
              child: FIcon(
                FAssets.icons.hospital,
              ),
            ),
          ),
          Opacity(
            opacity: 0.4,
            child: Align(
              child: Text(hospitalRepository.name),
            ),
          ),
          Opacity(
            opacity: .9,
            child: ListView(
              children: [
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton.icon(
                    onPressed: null,
                    icon: const Icon(
                      FontAwesomeIcons.hospital,
                    ),
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          hospitalRepository.name.text(),
                          hospitalRepository.city.text(),
                          hospitalRepository.info.text(),
                        ],
                      ),
                    ).pad(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton.icon(
                    onPressed: () => context
                        .of<RouterBloc>()
                        .toRouteByName(PatientsPage.name),
                    icon: const Icon(FontAwesomeIcons.route),
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: 'patients'.text(),
                    ).pad(),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => context
                      .of<RouterBloc>()
                      .toRouteByName(InvestigationsPage.name),
                  icon: const Icon(FontAwesomeIcons.fileInvoice),
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: 'investigations'.text(),
                    ),
                  ),
                ).pad(),
                FilledButton.icon(
                  onPressed: () {
                    context.of<RouterBloc>().toRouteByName('settings');
                  },
                  icon: const Icon(FontAwesomeIcons.confluence),
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('settings'),
                    ),
                  ),
                ).pad(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
