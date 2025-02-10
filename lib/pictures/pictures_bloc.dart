import 'package:patients/pictures/picture.dart';

import 'pictures_repository.dart';

class PicturesBloc {
  List<Picture> get pictures => picturesRepository.getAll();
  late final put = picturesRepository.put;
  late final remove = picturesRepository.remove;
  late final removeAll = picturesRepository.removeAll;
}

final PicturesBloc picturesBloc = PicturesBloc();
