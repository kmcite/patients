import 'package:patients/domain/models/investigation.dart';
import 'package:patients/main.dart';

import 'patient_types.dart';
import 'picture.dart';

@Entity()
class Patient extends Model {
  @override
  @Id()
  int id = 0;
  String name = '';
  double age = 0; // in years
  @Property(type: PropertyType.date)
  DateTime? dateOfBirth;
  @Property(type: PropertyType.date)
  DateTime timeOfPresentation = DateTime.now();
  final patientType = ToOne<PatientType>();
  final pictures = ToMany<Picture>();
  String complaints = '';
  String examination = '';
  String management = '';
  String diagnosis = '';
  String other = '';
  String password = '';
  String email = '';

  final address = ToOne<Address>();

  final contact = ToOne<Contact>();

  @Backlink('patient')
  final lesions = ToMany<Lesion>();

  final images = ToMany<Imagery>();
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

@Entity()
class Lesion {
  @Id()
  int id = 0;
  String patterns = '';

  final patient = ToOne<Patient>();
}

@Entity()
class Contact {
  @Id()
  int id = 0;
  String countryCode = '';
  String mnp = '';
  String phoneCode = '';

  final patient = ToOne<Patient>();
}

@Entity()
class Address {
  @Id()
  int id = 0;
  String town = '';
  String city = '';
  String province = '';
  String country = '';

  final patient = ToOne<Patient>();
}

@Entity()
class Imagery extends Model {
  @override
  @Id()
  int id = 0;
  String path = '';
  final patient = ToOne<Patient>();
}
