import '../../main.dart';

@Entity()
class Picture extends Model {
  @override
  @Id()
  int id = 0;
  String path = '';
}
