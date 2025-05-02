import 'package:manager/manager.dart';
import 'package:patients/domain/models/duty.dart';

class DutiesRepository extends CRUD<Duty> {}

final dutiesRepository = DutiesRepository();
