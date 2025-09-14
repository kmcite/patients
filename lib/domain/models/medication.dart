import 'package:objectbox/objectbox.dart';
import 'patient.dart';

@Entity()
class Medication {
  @Id()
  int id = 0;

  String name = '';
  String genericName = '';
  String dosage = ''; // e.g., "500mg"
  String frequency = ''; // e.g., "twice daily"
  String route = ''; // e.g., "oral", "IV", "topical"

  @Property(type: PropertyType.date)
  DateTime startDate = DateTime.now();

  @Property(type: PropertyType.date)
  DateTime? endDate;

  String instructions = '';
  String sideEffects = '';
  String contraindications = '';

  double? price;
  String? manufacturer;

  int categoryIndex = MedicationCategory.tablet.index;

  @Transient()
  MedicationCategory get category => MedicationCategory.values[categoryIndex];

  @Transient()
  set category(MedicationCategory value) {
    categoryIndex = value.index;
  }

  @Transient()
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) &&
        (endDate == null || now.isBefore(endDate!));
  }

  @Transient()
  int? get durationDays {
    if (endDate == null) return null;
    return endDate!.difference(startDate).inDays;
  }
}

@Entity()
class Prescription {
  @Id()
  int id = 0;

  @Property(type: PropertyType.date)
  DateTime prescribedDate = DateTime.now();

  String notes = '';

  final patient = ToOne<Patient>();
  final medications = ToMany<Medication>();

  @Transient()
  int get medicationCount => medications.length;
}

enum MedicationCategory {
  tablet,
  capsule,
  syrup,
  injection,
  cream,
  ointment,
  drops,
  inhaler,
  patch
}
