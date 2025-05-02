import 'package:objectbox/objectbox.dart';
import 'package:patients/domain/models/investigation.dart';

import 'patient_types.dart';
import 'picture.dart';

@Entity()
class Patient {
  @Id()
  int id = 0;
  String name = '';
  double age = 0; // in years
  @Property(type: PropertyType.date)
  DateTime timeOfPresentation = DateTime.now();
  final patientType = ToOne<PatientType>();
  final pictures = ToMany<Picture>();
  String complaints = '';
  String examination = '';
  String management = '';
  String diagnosis = '';
  String other = '';
  bool attended = false;
  bool editing = false;
  bool gender = true; // true male
  String createdAt = '';
  final investigations = ToMany<Investigation>();
  @Transient()
  OutComeStatus outComeStatus = OutComeStatus.emergency;

  @Transient()
  String get date {
    return '${timeOfPresentation.day.toString().padLeft(2, '0')}/${timeOfPresentation.month.toString().padLeft(2, '0')}/${timeOfPresentation.year}';
  }
}

enum OutComeStatus {
  emergency,
  discharged,
  admitted,
  referred,
  expired;
}
