import 'package:patients/domain/models/patient.dart';
import 'package:patients/utils/architecture.dart';
import 'package:patients/utils/crud.dart';

class ImageriesRepository extends Repository<Imagery> with CRUD<Imagery> {}
