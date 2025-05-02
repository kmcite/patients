import '../main.dart';
import '../domain/models/duty.dart';

mixin RosterTableBloc {
  CollectionModifier<Duty> get duties => dutiesRepository.call;
  void put(Duty duty) {
    dutiesRepository.put(duty);
  }

  void remove(int id) {
    dutiesRepository.remove(id);
  }
}

// ignore: must_be_immutable
class RosterTable extends UI with RosterTableBloc {
  RosterTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(width: 2),
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
                    value: duties().any(
                      (entry) {
                        return entry.dayType() == day &&
                            entry.shiftType() == shift;
                      },
                    ),
                    onChanged: (value) {
                      try {
                        final entry = dutiesRepository.getAll().firstWhere(
                          (eachRosterEntry) {
                            return eachRosterEntry.dayType() == day &&
                                eachRosterEntry.shiftType() == shift;
                          },
                        );
                        remove(entry.id);
                      } catch (e) {
                        put(
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
