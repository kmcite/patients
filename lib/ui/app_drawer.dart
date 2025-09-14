import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:patients/ui/settings_page.dart';
import 'package:patients/utils/architecture.dart';

class AppDrawerBloc extends Bloc {
  // Simple bloc for drawer - no specific logic needed
}

class AppDrawer extends BlocWidget<AppDrawerBloc> {
  const AppDrawer({super.key});

  @override
  AppDrawerBloc createBloc() => AppDrawerBloc();

  @override
  Widget build(BuildContext context, AppDrawerBloc bloc) {
    return FScaffold(
      header: FHeader(
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FAvatar.raw(
                size: 120,
                child: const Icon(
                  FIcons.hospital,
                  size: 80,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Patients',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
      child: FTileGroup(
        label: FButton.icon(
          child: const Icon(FIcons.x),
          onPress: () => Navigator.of(context).pop(),
        ),
        divider: FItemDivider.full,
        children: [
          FTile(
            prefix: const Icon(FIcons.user),
            title: const Text('Patients'),
            onPress: () {
              Navigator.of(context).pop();
              // TODO: Navigate to patients page
            },
          ),
          FTile(
            prefix: const Icon(FIcons.type),
            title: const Text('Patient Types'),
            onPress: () {
              Navigator.of(context).pop();
              // TODO: Navigate to patient types page
            },
          ),
          FTile(
            prefix: const Icon(FIcons.pictureInPicture2),
            title: const Text('Pictures'),
            onPress: () {
              Navigator.of(context).pop();
              // TODO: Navigate to pictures page
            },
          ),
          FTile(
            prefix: const Icon(FIcons.settings2),
            title: const Text('Settings'),
            onPress: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
          FTile(
            prefix: const Icon(FIcons.calendar),
            title: const Text('Duty Roster'),
            onPress: () {
              Navigator.of(context).pop();
              // TODO: Navigate to duty roster page
            },
          ),
        ],
      ),
    );
  }
}
