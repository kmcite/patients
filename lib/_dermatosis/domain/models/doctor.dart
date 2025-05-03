import 'package:manager/model.dart';
import 'package:objectbox/objectbox.dart';

import 'patient.dart';

@Entity()
class Doctor extends Model {
  @override
  @Id()
  int id = 0;
  String name = '';
  String description = '';
  String email = '';
  String password = '';
  final patients = ToMany<Patient>();
}
