import 'package:flutter/material.dart';
import 'package:patients/domain/api/duties_repository.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/utils/architecture.dart';
import 'roster_table.dart';

class DutyRosterBloc extends Bloc {
  late final DutiesRepository dutiesRepository;

  @override
  void initState() {
    dutiesRepository = watch<DutiesRepository>();
  }

  int get totalHours {
    // TODO: Implement duty hours calculation
    return 40; // Placeholder
  }
}

class DutyRoster extends Feature<DutyRosterBloc> {
  const DutyRoster({super.key});

  @override
  DutyRosterBloc createBloc() => DutyRosterBloc();

  @override
  Widget build(BuildContext context, DutyRosterBloc bloc) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Duty Roster'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: navigator.back,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Total Hours Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total Weekly Hours',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${bloc.totalHours}",
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Hours',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Roster Table
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Schedule',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const RosterTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
