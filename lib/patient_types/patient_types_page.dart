import 'package:patients/main.dart';
import 'package:patients/patient_types/patient_types.dart';
import 'package:patients/patient_types/patient_types_bloc.dart';

final _patientTypeField = RM.injectTextEditing();

class PatientTypesPage extends UI {
  const PatientTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Types'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => patientTypesBloc.put(PatientType()),
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
            Expanded(
              child: ListView.builder(
                itemCount: patientTypesBloc.patientTypes.length,
                itemBuilder: (context, index) {
                  final patientType = patientTypesBloc.patientTypes[index];
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

class PatientTypeItem extends UI {
  final PatientType patientType;

  const PatientTypeItem({required this.patientType, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        key: Key('${patientType.id}'),
        initialValue: patientType.type,
        onChanged: (value) => patientTypesBloc.put(patientType..type = value),
        decoration: InputDecoration(
          labelText: 'Type #${patientType.id}',
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => patientTypesBloc.remove(patientType.id),
      ),
    );
  }
}
