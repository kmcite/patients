import 'package:patients/domain/models/patient.dart';
import 'package:patients/utils/architecture.dart';
import 'package:patients/utils/crud.dart';
import 'package:injectable/injectable.dart';

@singleton
class ImageriesRepository extends CrudRepository<Imagery> {
  // All CRUD functionality is inherited from CrudRepository
  // items Resource<List<Imagery>> is available for UI binding

  void addImagery(Imagery imagery) {
    put(imagery); // Uses CRUD functionality
  }

  void removeImagery(Imagery imagery) {
    remove(imagery); // Uses CRUD functionality
  }

  // Convenient getter for UI
  Resource<List<Imagery>> get imageries => items;
}
