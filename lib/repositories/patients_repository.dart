import 'package:objectbox/objectbox.dart';
import 'package:patients/utils/get.dart';
import 'package:patients/utils/services/repository.dart';
import '../models/patient.dart';
import 'package:injectable/injectable.dart';

@singleton
class PatientsRepository extends Repository<List<PatientNew>> {
  Future<Iterable<PatientNew>> getAll() async {
    return get<Store>().box<PatientNew>().getAll();
  }

  @override
  final List<PatientNew> initialState = get<Store>().box<PatientNew>().getAll();
  Iterable<PatientNew> searchByName(String name) {
    return initialState.where((pt) => pt.name.contains(name));
  }

  R when<R>({
    required R Function(dynamic error, dynamic message)? error,
    required R Function(dynamic patients)? data,
    required R Function() empty,
  }) {
    throw UnimplementedError();
  }

  // Resource<List<PatientNew>> get patients => items;
}

@singleton
class VisitsRepository extends Repository<List<Visit>> {
  @override
  final List<Visit> initialState = get<Store>().box<Visit>().getAll();
}
