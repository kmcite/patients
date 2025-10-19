import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  @Id()
  int id = 0;

  String name = "Adn";
  String email = "";
  String phone = "";
  String specialization = ""; // For doctors
  String licenseNumber = ""; // For doctors

  @Property(type: PropertyType.date)
  DateTime jobStartedOn = DateTime(2022, 1, 19);

  @Property(type: PropertyType.date)
  DateTime? dateOfBirth;

  int showDurationInIndex = ShowDurationIn.hours.index;

  @Transient()
  ShowDurationIn get showDurationIn =>
      ShowDurationIn.values[showDurationInIndex];

  @Transient()
  set showDurationIn(ShowDurationIn value) {
    showDurationInIndex = value.index;
  }

  @Transient()
  Duration get jobDuration => DateTime.now().difference(jobStartedOn);

  @Transient()
  int get experienceYears => jobDuration.inDays ~/ 365;

  @Transient()
  int? get age {
    if (dateOfBirth == null) return null;
    return DateTime.now().difference(dateOfBirth!).inDays ~/ 365;
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}

enum ShowDurationIn {
  seconds,
  minutes,
  hours,
  days,
  months,
  years,
}
