import 'package:manager/manager.dart';
import 'package:patients/_dermatosis/domain/models/doctor.dart';

class DoctorsRepository extends CRUD<Doctor> {
  Doctor? searchByEmail(String email) {
    return getAll().where((doctor) => doctor.email == email).firstOrNull;
  }
}

final doctorsRepository = DoctorsRepository();
