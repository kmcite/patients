import 'package:objectbox/objectbox.dart';
import 'package:patients/domain/models/patient.dart';

@Entity()
class Doctor
//  extends Model
{
  // @override
  @Id()
  int id = 0;
  String name = '';
  String description = '';
  String email = '';
  String password = '';
  final patients = ToMany<Patient>();
}
