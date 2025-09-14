import 'package:patients/domain/models/picture.dart';
import 'package:patients/utils/architecture.dart';

class PicturesRepository extends Repository {
  final Resource<List<Picture>> pictures = Resource<List<Picture>>();

  @override
  void init() {
    loadPictures();
  }

  Future<void> loadPictures() async {
    await pictures.execute(() async {
      // TODO: Load from database or API
      return <Picture>[];
    });
    notifyListeners();
  }

  void addPicture(Picture picture) {
    if (pictures.hasData) {
      pictures.data!.add(picture);
      notifyListeners();
    }
  }
}
