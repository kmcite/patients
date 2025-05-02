import 'package:patients/domain/api/patient_types_repository.dart';
import 'package:patients/main.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/domain/models/patient_types.dart';
import 'package:patients/ui/patient_types/add_patient_type_dialog.dart';

mixin class PatientTypesBloc {
  CollectionModifier<PatientType> get patientTypes => patientTypesRepository;
  void put(PatientType type) {
    patientTypesRepository.put(type);
  }

  void remove(int id) {
    patientTypesRepository.remove(id);
  }

  void addType() => navigator.toDialog(AddPatientTypeDialog());
}

class PatientTypesPage extends UI with PatientTypesBloc {
  const PatientTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Types'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addType,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: Text(
                'List Of Available Patient Types. Add, Edit, Update & Delete in Realtime:-',
                style: TextStyle(fontSize: 16),
              ).pad(),
            ).pad(),
            ...patientTypes().map(
              (data) => data.text(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: patientTypes().length,
                itemBuilder: (context, index) {
                  final patientType = patientTypes()[index];
                  return PatientTypeItem(patientType: patientType);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientTypeItem extends UI with PatientTypesBloc {
  final PatientType patientType;

  PatientTypeItem({required this.patientType, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        key: Key('${patientType.id}'),
        initialValue: patientType.type,
        onChanged: (value) => put(patientType..type = value),
        decoration: InputDecoration(
          labelText: 'Type #${patientType.id}',
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => remove(patientType.id),
      ),
    );
  }
}
