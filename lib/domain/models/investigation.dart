import 'package:patients/main.dart';

@Entity()
class Investigation {
  @Id()
  int id = 0;
  String name = '';
  int price = 200;
}
