import '../../main.dart';
import '../models/duty.dart';

final dutyHoursCalculator = DutyHoursCalculator();

class DutyHoursCalculator {
  Duration calculateTotalDutyHours() {
    Duration totalDutyDuration = Duration.zero;
    for (final duty in dutiesRepository.getAll()) {
      int shiftDurationHours = getShiftDuration(duty.shiftType());
      Duration dutyShiftDuration = Duration(hours: shiftDurationHours);
      totalDutyDuration += dutyShiftDuration;
    }
    return totalDutyDuration;
  }

  int getShiftDuration(ShiftType shiftType) {
    return switch (shiftType) {
      ShiftType.morning => 6,
      ShiftType.evening => 6,
      ShiftType.night => 12,
    };
  }
}
