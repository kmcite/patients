import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/domain/api/imageries_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class ImageriesBloc extends Bloc<ImageriesPage> {
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

class ImageriesPage extends Feature<ImageriesBloc> {
  const ImageriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imageries'),
      ),
      body: const Center(
        child: Text('Imageries Page - Coming Soon'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.pickAndSave();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
