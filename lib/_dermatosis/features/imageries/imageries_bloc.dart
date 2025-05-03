import 'package:file_picker/file_picker.dart';
import 'package:patients/_dermatosis/domain/api/imageries_repository.dart';

import '../../main.dart';
import '../../domain/models/patient.dart';

final imageriesBloc = ImageriesBloc();

class ImageriesBloc {
  final imageriesRM = RM.inject(() => imageriesRepository.getAll());

  bool get loading => imageriesRM.isWaiting;
  List<Imagery> get imageries => imageriesRM.state;

  void put(Imagery imagery) {
    imageriesRepository.put(imagery);
    imageriesRM.state = imageriesRepository.getAll();
  }

  void remove(int id) {
    imageriesRepository.remove(id);
    imageriesRM.state = imageriesRepository.getAll();
  }

  Future<void> pickAndSave() async {
    final pickerResult = await FilePicker.platform.pickFiles();
    if (pickerResult != null) {
      final pickedPath = pickerResult.files.first.path;

      if (pickedPath != null) {
        // put(Imagery()..path = pickedPath);
      }
    }
  }
}
