import 'package:objectbox/objectbox.dart';
import 'package:patients/models/duty.dart';
import 'package:patients/utils/get.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/utils/services/repository.dart';

@singleton
class DutiesRepository extends Repository<List<Duty>> {
  @override
  final List<Duty> initialState = get<Store>().box<Duty>().getAll();
  // All CRUD functionality is inherited from CrudRepository
  // items Resource<List<Duty>> is available for UI binding

  // void addDuty(Duty duty) {
  //   put(duty); // Uses CRUD functionality
  // }

  // void removeDuty(Duty duty) {
  //   remove(duty); // Uses CRUD functionality
  // }

  // // Convenient getter for UI
  // Resource<List<Duty>> get duties => items;
}
