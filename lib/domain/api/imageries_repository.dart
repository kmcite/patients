import 'package:manager/manager.dart';
import 'package:patients/domain/models/patient.dart';

final imageriesRepository = ImageriesRepository();

class ImageriesRepository extends CRUD<Imagery> {}
