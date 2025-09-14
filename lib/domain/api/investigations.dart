import 'package:patients/domain/models/investigation.dart';
import 'package:patients/utils/crud.dart';
import 'package:patients/utils/architecture.dart';

class InvestigationsRepository extends CrudRepository<Investigation> {
  // All CRUD functionality is inherited from CrudRepository
  // items Resource<List<Investigation>> is available for UI binding

  void addInvestigation(Investigation investigation) {
    put(investigation); // Uses CRUD functionality
  }

  void removeInvestigation(Investigation investigation) {
    remove(investigation); // Uses CRUD functionality
  }

  // Convenient getter for UI
  Resource<List<Investigation>> get investigations => items;
}
