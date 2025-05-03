import 'dart:async';

import 'package:forui/forui.dart';
import 'package:patients/domain/models/duty.dart';

import '../../main.dart';

typedef _UpcomingDutiesState = ({Duty? duty, List<Duty> duties});

class _UpcomingDuties extends Bloc<void, _UpcomingDutiesState> {
  StreamSubscription? _subscription;

  _UpcomingDuties() {
    _subscription = dutiesRepository.watch().listen(
      (duties) {
        emit(
          (
            duty: upcomingDutyFinder.findNextRosterEntry(
              DateTime.now(),
              duties,
            ),
            duties: duties,
          ),
        );
      },
    );
  }
  @override
  get initialState => (
        duty: upcomingDutyFinder.findNextRosterEntry(
          DateTime.now(),
          dutiesRepository(),
        ),
        duties: dutiesRepository()
      );
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final upcomingDuties = _UpcomingDuties();

class UpcomingDuties extends UI {
  const UpcomingDuties({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (upcomingDuties().duties.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Please setup your personal roster to see your upcoming duty.',
              textAlign: TextAlign.center,
            ),
          )
        else ...[
          Text('Upcoming Duty').pad(),
          Column(
            children: [
              _buildRow(
                '  DAY  ',
                upcomingDuties().duty?.dayType().name.toUpperCase() ?? '-',
              ),
              _buildRow(
                '  SHIFT  ',
                upcomingDuties().duty?.shiftType().name.toUpperCase() ?? '-',
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FLabel(
          axis: Axis.vertical,
          child: label.text(
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        FBadge(label: value.text()),
      ],
    );
  }
}
