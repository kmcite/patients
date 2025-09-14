import 'package:file_picker/file_picker.dart';
import 'package:patients/domain/api/imageries_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/utils/architecture.dart';

class ImageriesBloc extends Bloc {
  late final ImageriesRepository imageriesRepository;

  @override
  void initState() {
    imageriesRepository = watch<ImageriesRepository>();
  }

  bool get loading => imageriesRepository.items.isLoading;
  List<Imagery> get imageries => imageriesRepository.items.data ?? [];

  void put(Imagery imagery) {
    imageriesRepository.put(imagery);
  }

  void remove(Imagery imagery) {
    imageriesRepository.remove(imagery);
  }

  Future<void> pickAndSave() async {
    final pickerResult = await FilePicker.platform.pickFiles();
    if (pickerResult != null) {
      final pickedPath = pickerResult.files.first.path;

      if (pickedPath != null) {
        // Create and save imagery
        final imagery = Imagery()..path = pickedPath;
        put(imagery);
      }
    }
  }
}
