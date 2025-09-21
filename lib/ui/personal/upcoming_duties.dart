import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/domain/api/duties_repository.dart';
import 'package:patients/domain/api/upcoming_duty_finder.dart';
import 'package:patients/domain/models/duty.dart';
import 'package:patients/utils/architecture.dart';
import 'package:patients/utils/dependencies.dart';

@injectable
class UpcomingDutiesBloc extends Bloc<UpcomingDuties> {
  late final DutiesRepository dutiesRepository = watch();
  late final UpcomingDutyFinder upcomingDutyFinder = get();

  List<Duty> get duties =>
      dutiesRepository.duties.hasData ? dutiesRepository.duties.data! : [];

  Duty? get upcomingDuty {
    if (duties.isEmpty) return null;
    return upcomingDutyFinder.findNextRosterEntry(DateTime.now(), duties);
  }
}

class UpcomingDuties extends Feature<UpcomingDutiesBloc> {
  const UpcomingDuties({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (controller.duties.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Please setup your personal roster to see your upcoming duty.',
              textAlign: TextAlign.center,
            ),
          )
        else ...[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Upcoming Duty'),
          ),
          Column(
            children: [
              _buildRow(
                '  DAY  ',
                controller.upcomingDuty?.dayType().name.toUpperCase() ?? '-',
                context,
              ),
              _buildRow(
                '  SHIFT  ',
                controller.upcomingDuty?.shiftType().name.toUpperCase() ?? '-',
                context,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildRow(String label, String value, BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
