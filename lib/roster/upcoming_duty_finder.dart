import 'package:patients/roster/duty.dart';

final upcomingDutyFinder = UpcomingDutyFinder();

class UpcomingDutyFinder {
  Duty? findNextRosterEntry(
    DateTime currentDateTime,
    List<Duty> rosterEntries,
  ) {
    List<Duty> futureEntries = rosterEntries.where((entry) {
      DateTime entryDateTime = getNextOccurrence(currentDateTime, entry);
      return entryDateTime.isAfter(currentDateTime);
    }).toList();
    futureEntries.sort(
      (a, b) {
        DateTime aDateTime = getNextOccurrence(currentDateTime, a);
        DateTime bDateTime = getNextOccurrence(currentDateTime, b);
        return aDateTime.compareTo(bDateTime);
      },
    );
    return futureEntries.isNotEmpty ? futureEntries.first : null;
  }

  DateTime calculateNextEntryDateTime(
      DateTime currentDateTime, Duty rosterEntry, bool isDutyCompleted) {
    DateTime nextOccurrence = getNextOccurrence(currentDateTime, rosterEntry);
    if (isDutyCompleted) {
      nextOccurrence = getNextOccurrence(nextOccurrence, rosterEntry);
    }
    return nextOccurrence;
  }

  DateTime getNextOccurrence(
    DateTime currentDateTime,
    Duty rosterEntry,
  ) {
    DateTime nextOccurrence = currentDateTime;
    while (nextOccurrence.weekday != rosterEntry.dayType().index + 1) {
      nextOccurrence = nextOccurrence.add(const Duration(days: 1));
    }
    switch (rosterEntry.shiftType()) {
      case ShiftType.morning:
        nextOccurrence = DateTime(nextOccurrence.year, nextOccurrence.month,
            nextOccurrence.day, 8, 0);
        break;
      case ShiftType.evening:
        nextOccurrence = DateTime(nextOccurrence.year, nextOccurrence.month,
            nextOccurrence.day, 14, 0);
        break;
      case ShiftType.night:
        nextOccurrence = DateTime(nextOccurrence.year, nextOccurrence.month,
            nextOccurrence.day, 20, 0);
        break;
    }
    return nextOccurrence;
  }
}
