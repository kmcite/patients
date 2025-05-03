import 'package:manager/model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Patient extends Model {
  @override
  @Id()
  int id = 0;

  String name = '';
  String password = '';
  String complaints = '';
  String management = '';
  String diagnosis = '';
  String email = '';
  bool gender = false;
  bool editing = false;
  DateTime? dateOfBirth;
  DateTime? presentation;

  final address = ToOne<Address>();

  final contact = ToOne<Contact>();

  @Backlink('patient')
  final lesions = ToMany<Lesion>();

  final images = ToMany<Imagery>();
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
