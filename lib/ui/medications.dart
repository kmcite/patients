import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/domain/models/medication.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class MedicationsBloc extends Bloc<MedicationsPage> {
  void onMedicationAdded(Medication medication) {}
}

class MedicationsPage extends Feature<MedicationsBloc> {
  const MedicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medications'),
      ),
      body: const Center(
        child: Text('Medications Management - Coming Soon'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.onMedicationAdded(Medication()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
