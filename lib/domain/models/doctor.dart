import 'package:objectbox/objectbox.dart';
import 'package:patients/domain/models/patient.dart';

@Entity()
class Doctor {
  @Id()
  int id = 0;

  String name = '';
  String email = '';
  String phone = '';
  String specialization = '';
  String licenseNumber = '';
  String qualifications = '';

  @Property(type: PropertyType.date)
  DateTime? dateOfBirth;

  @Property(type: PropertyType.date)
  DateTime? joinedDate;

  String department = '';
  String designation = ''; // e.g., "Senior Consultant", "Resident"

  double? consultationFee;
  String workingHours = ''; // e.g., "9 AM - 5 PM"
  String workingDays = ''; // e.g., "Mon-Fri"

  bool isActive = true;
  String notes = '';

  final patients = ToMany<Patient>();

  @Transient()
  int get experienceYears {
    if (joinedDate == null) return 0;
    return DateTime.now().difference(joinedDate!).inDays ~/ 365;
  }

  @Transient()
  int? get age {
    if (dateOfBirth == null) return null;
    return DateTime.now().difference(dateOfBirth!).inDays ~/ 365;
  }

  @Transient()
  String get fullTitle =>
      'Dr. $name${specialization.isNotEmpty ? ' ($specialization)' : ''}';

  @override
  String toString() {
    return 'Doctor(id: $id, name: $name, specialization: $specialization)';
  }
}
