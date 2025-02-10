import 'package:patients/roster/duty.dart';

import '../main.dart';

final _duties = store.box<Duty>();

void addDuty(Duty duty) => _duties.put(duty);
void removeDuty(int id) => _duties.remove(id);

class DutiesRepository with CRUD<Duty> {}

final dutiesRepository = DutiesRepository();
