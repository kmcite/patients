import 'package:patients/main.dart';

@Entity()
class Investigation extends Model {
  @override
  @Id()
  int id = 0;
  String name = '';
  int price = 200;
}
