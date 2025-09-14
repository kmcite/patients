import 'package:objectbox/objectbox.dart';
import 'patient.dart';
import 'doctor.dart';

@Entity()
class Appointment {
  @Id()
  int id = 0;

  @Property(type: PropertyType.date)
  DateTime scheduledDateTime = DateTime.now();

  @Property(type: PropertyType.date)
  DateTime? actualStartTime;

  @Property(type: PropertyType.date)
  DateTime? actualEndTime;

  String reason = '';
  String notes = '';

  int statusIndex = AppointmentStatus.scheduled.index;
  int typeIndex = AppointmentType.consultation.index;

  final patient = ToOne<Patient>();
  final doctor = ToOne<Doctor>();

  @Transient()
  AppointmentStatus get status => AppointmentStatus.values[statusIndex];

  @Transient()
  set status(AppointmentStatus value) {
    statusIndex = value.index;
  }

  @Transient()
  AppointmentType get type => AppointmentType.values[typeIndex];

  @Transient()
  set type(AppointmentType value) {
    typeIndex = value.index;
  }

  @Transient()
  Duration? get actualDuration {
    if (actualStartTime == null || actualEndTime == null) return null;
    return actualEndTime!.difference(actualStartTime!);
  }

  @Transient()
  bool get isToday {
    final now = DateTime.now();
    final scheduled = scheduledDateTime;
    return now.year == scheduled.year &&
        now.month == scheduled.month &&
        now.day == scheduled.day;
  }
}

enum AppointmentStatus {
  scheduled,
  confirmed,
  inProgress,
  completed,
  cancelled,
  noShow,
  rescheduled
}

enum AppointmentType { consultation, followUp, emergency, procedure, checkup }
