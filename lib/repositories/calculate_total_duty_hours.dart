import '../models/duty.dart';

Duration caculateTotalDutyHours(Iterable<Duty> duties) {
  Duration totalDutyDuration = Duration.zero;
  for (final duty in duties) {
    int shiftDurationHours = _getShiftDuration(duty.shiftType());
    Duration dutyShiftDuration = Duration(hours: shiftDurationHours);
    totalDutyDuration += dutyShiftDuration;
  }
  return totalDutyDuration;
}

int _getShiftDuration(ShiftType shiftType) {
  return switch (shiftType) {
    ShiftType.morning => 6,
    ShiftType.evening => 6,
    ShiftType.night => 12,
  };
}
