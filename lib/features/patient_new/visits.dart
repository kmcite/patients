import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/models/patient.dart';
import 'package:patients/repositories/patients_repository.dart';
import 'package:patients/utils/architecture.dart';

import 'visit_form.dart';

class VisitsView extends Feature<VisitsBloc> {
  const VisitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visits'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: controller.visits.length,
          itemBuilder: (context, index) {
            final visit = controller.visits[index];
            return ListTile(
              title: Text(visit.diagnosis),
              subtitle: Text(
                visit.patient.target?.name ?? 'Unknown',
              ),
              onTap: () {
                navigator.to(
                  VisitForm(initialVisit: visit),
                );
              },
              onLongPress: () => controller.onVisitRemoved(visit),
            );
          },
        ),
      ),
    );
  }
}

@injectable
class VisitsBloc extends Bloc<VisitsView> {
  late VisitsRepository visitsRepository = watch();

  List<Visit> get visits => visitsRepository.value;

  void onVisitRemoved(Visit visit) {
    // visitsRepository.remove(visit);
    notifyListeners();
  }
}
