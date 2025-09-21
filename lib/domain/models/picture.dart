import 'package:objectbox/objectbox.dart';

@Entity()
class Picture {
  @Id()
  int id = 0;
  String path = '';
}
