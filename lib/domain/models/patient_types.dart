import '../../main.dart';

@Entity()
class PatientType extends Model {
  @override
  @Id()
  int id = 0;
  String type = '';
}
