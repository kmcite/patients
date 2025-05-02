import 'package:manager/manager.dart' show CRUD;
import 'package:patients/domain/models/picture.dart';

class PicturesRepository extends CRUD<Picture> {}

final PicturesRepository picturesRepository = PicturesRepository();
