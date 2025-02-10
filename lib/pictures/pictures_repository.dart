import 'package:patients/main.dart';
import 'package:patients/pictures/picture.dart';

class PicturesRepository with CRUD<Picture> {}

final PicturesRepository picturesRepository = PicturesRepository();
