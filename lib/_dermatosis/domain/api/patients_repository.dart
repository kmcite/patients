// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:manager/manager.dart';
import 'package:patients/_dermatosis/domain/models/patient.dart';

final patientsRepository = PatientsRepository();

class PatientsRepository extends CRUD<Patient> {
  Iterable<Patient> searchByEmail(String email) {
    return getAll().where(
      (pt) {
        return pt.email == email;
      },
    );
  }

  Iterable<Patient> searchByName(String name) {
    return getAll().where(
      (pt) {
        return pt.name.contains(name);
      },
    );
  }
}
