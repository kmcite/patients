import 'package:patients/domain/models/investigation.dart';

import '../../main.dart';

class InvestigationsRepository extends CRUD<Investigation> {}

final investigationsRepository = InvestigationsRepository();
