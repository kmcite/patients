import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/domain/api/duties_repository.dart';
import 'package:patients/domain/models/duty.dart';
import 'package:patients/utils/architecture.dart';
import 'table_cell_builder.dart';

@injectable
class RosterTableBloc extends Bloc<RosterTable> {
  late final DutiesRepository dutiesRepository;

  @override
  void initState() {
    dutiesRepository = watch<DutiesRepository>();
  }

  List<Duty> get duties =>
      dutiesRepository.duties.hasData ? dutiesRepository.duties.data! : [];

  void toggleDuty(DayType day, ShiftType shift) {
    try {
      final existingDuty = duties.firstWhere(
        (duty) => duty.dayType() == day && duty.shiftType() == shift,
      );
      dutiesRepository.removeDuty(existingDuty);
    } catch (e) {
      // Duty doesn't exist, create new one
      final newDuty = Duty()
        ..dayType(day)
        ..shiftType(shift);
      dutiesRepository.addDuty(newDuty);
    }
  }

  bool isDutyScheduled(DayType day, ShiftType shift) {
    return duties.any(
      (duty) => duty.dayType() == day && duty.shiftType() == shift,
    );
  }
}

class RosterTable extends Feature<RosterTableBloc> {
  const RosterTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        border: TableBorder.all(width: 2),
        children: [
          const TableRow(
            children: [
              TableCellBuilder(
                  child:
                      Text('Day\\Shift', textScaler: TextScaler.linear(0.8))),
              TableCellBuilder(
                  child: Text('Morning', textScaler: TextScaler.linear(0.8))),
              TableCellBuilder(
                  child: Text('Evening', textScaler: TextScaler.linear(0.8))),
              TableCellBuilder(
                  child: Text('Night', textScaler: TextScaler.linear(0.8))),
            ],
          ),
          ...DayType.values.map(
            (day) => TableRow(
              children: [
                TableCellBuilder(
                  child: Text(
                    day.name,
                    textScaler: const TextScaler.linear(0.75),
                  ),
                ),
                ...ShiftType.values.map(
                  (shift) => TableCellBuilder(
                    child: Switch(
                      value: controller.isDutyScheduled(day, shift),
                      onChanged: (value) => controller.toggleDuty(day, shift),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
