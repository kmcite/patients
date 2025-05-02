import 'package:objectbox/objectbox.dart';

@Entity()
class Duty {
  @Id()
  int id = 0;
  int shift = 0;
  int day = 0;
  @Transient()
  ShiftType shiftType([ShiftType? shift_]) {
    if (shift_ != null) shift = shift_.index;
    return ShiftType.values[shift];
  }

  @Transient()
  DayType dayType([DayType? day_]) {
    if (day_ != null) day = day_.index;
    return DayType.values[day];
  }
}

enum ShiftType { morning, evening, night }

enum DayType {
  mon('Monday'),
  tue('Tuesday'),
  wed('Wednesday'),
  thu('Thursday'),
  fri('Friday'),
  sat('Saturday'),
  sun('Sunday');

  const DayType(this.name);
  final String name;
}
