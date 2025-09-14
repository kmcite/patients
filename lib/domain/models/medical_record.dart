import 'package:objectbox/objectbox.dart';
import 'patient.dart';
import 'doctor.dart';
import 'investigation.dart';

@Entity()
class MedicalRecord {
  @Id()
  int id = 0;

  @Property(type: PropertyType.date)
  DateTime visitDate = DateTime.now();

  String chiefComplaint = '';
  String historyOfPresentIllness = '';
  String pastMedicalHistory = '';
  String familyHistory = '';
  String socialHistory = '';

  // Physical Examination
  String generalExamination = '';
  String systemicExamination = '';

  // Vital Signs
  double? temperature; // Celsius
  int? systolicBP;
  int? diastolicBP;
  int? heartRate; // BPM
  int? respiratoryRate; // per minute
  double? oxygenSaturation; // percentage
  double? weight; // kg
  double? height; // cm

  // Assessment & Plan
  String assessment = '';
  String plan = '';
  String prescription = '';
  String followUpInstructions = '';

  @Property(type: PropertyType.date)
  DateTime? nextVisitDate;

  final patient = ToOne<Patient>();
  final doctor = ToOne<Doctor>();
  final investigations = ToMany<Investigation>();

  @Transient()
  double? get bmi {
    if (weight == null || height == null) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  @Transient()
  String get bloodPressure {
    if (systolicBP == null || diastolicBP == null) return 'Not recorded';
    return '$systolicBP/$diastolicBP mmHg';
  }

  @Transient()
  String get vitalSigns {
    final vitals = <String>[];
    if (temperature != null) vitals.add('Temp: ${temperature!}°C');
    if (systolicBP != null && diastolicBP != null) {
      vitals.add('BP: $bloodPressure');
    }
    if (heartRate != null) vitals.add('HR: $heartRate bpm');
    if (respiratoryRate != null) vitals.add('RR: $respiratoryRate/min');
    if (oxygenSaturation != null) vitals.add('O2 Sat: $oxygenSaturation%');
    return vitals.join(', ');
  }
}
