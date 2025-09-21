import 'package:patients/domain/models/investigation.dart';
import 'package:patients/utils/crud.dart';
import 'package:injectable/injectable.dart';

@singleton
class InvestigationsRepository extends CrudRepository<Investigation> {}
