import '../main.dart';
import 'duty.dart';

class RosterTable extends UI {
  const RosterTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        width: 2,
        color: materialColor(),
        borderRadius: BorderRadius.circular(borderRadius()),
      ),
      children: [
        TableRow(
          children: [
            TableCellBuilder(child: 'Day\\Shift'.text(textScaleFactor: .8)),
            TableCellBuilder(child: 'Morning'.text(textScaleFactor: .8)),
            TableCellBuilder(child: 'Evening'.text(textScaleFactor: .8)),
            TableCellBuilder(child: 'Night'.text(textScaleFactor: .8)),
          ],
        ),
        ...DayType.values.map(
          (day) => TableRow(
            children: [
              TableCellBuilder(
                child: day.name.text(
                  textScaleFactor: .75,
                ),
              ),
              ...ShiftType.values.map(
                (shift) => TableCellBuilder(
                  child: Switch(
                    value: dutiesRepository.getAll().any(
                          (entry) =>
                              entry.dayType() == day &&
                              entry.shiftType() == shift,
                        ),
                    onChanged: (value) {
                      try {
                        final entry = dutiesRepository.getAll().firstWhere(
                          (eachRosterEntry) {
                            return eachRosterEntry.dayType() == day &&
                                eachRosterEntry.shiftType() == shift;
                          },
                        );
                        removeDuty(entry.id);
                      } catch (e) {
                        addDuty(
                          Duty()
                            ..shiftType(shift)
                            ..dayType(day),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ).pad();
  }
}
