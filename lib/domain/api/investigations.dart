import 'package:patients/domain/models/investigation.dart';
import 'package:patients/utils/crud.dart';

import '../../main.dart';

class InvestigationsRepository extends Repository<Investigation>
    with CRUD<Investigation> {}
