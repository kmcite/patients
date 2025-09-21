import 'package:objectbox/objectbox.dart';

@Entity()
class PatientType {
  @Id()
  int id = 0;
  String type = '';
}
