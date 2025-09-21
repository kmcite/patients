import 'package:patients/domain/models/duty.dart';
import 'package:patients/utils/crud.dart';
import 'package:patients/utils/architecture.dart';
import 'package:injectable/injectable.dart';

@singleton
class DutiesRepository extends CrudRepository<Duty> {
  // All CRUD functionality is inherited from CrudRepository
  // items Resource<List<Duty>> is available for UI binding

  void addDuty(Duty duty) {
    put(duty); // Uses CRUD functionality
  }

  void removeDuty(Duty duty) {
    remove(duty); // Uses CRUD functionality
  }

  // Convenient getter for UI
  Resource<List<Duty>> get duties => items;
}
