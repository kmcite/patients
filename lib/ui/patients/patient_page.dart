import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:patients/domain/api/investigations.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/main.dart';
import 'package:patients/ui/patients/patients_bloc.dart';

class PatientBloc extends Bloc<Patient, void> {
  @override
  void get initialState {}
}

class PatientPage extends UI {
  const PatientPage({super.key, required this.id});

  final int id;

  static const name = 'patient';

  @override
  Widget build(BuildContext context) {
    final patient = patientsBloc.get(id);
    final update = patientsBloc.put;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // context.pop();
          },
          icon: const FaIcon(
            FontAwesomeIcons.heartPulse,
            color: Colors.redAccent,
          ),
        ),
        title: Text(patient.name, textScaleFactor: 1.5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'name',
              textScaleFactor: 1.2,
            ),
            TextFormField(
              initialValue: patient.name,
              onChanged: (name) => update(patient..name = name),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
              ),
            ),
            'age'.text(textScaleFactor: 1.2).pad(),
            TextFormField(
              initialValue: patient.age.toString(),
              onChanged: (age) =>
                  update(patient..age = double.tryParse(age) ?? 0),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.cake, color: Colors.blueAccent),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('investigations', textScaleFactor: 1.2),
                PopupMenuButton(
                  onSelected: (investigation) {
                    // update(patient..investigations.add(investigation));
                  },
                  itemBuilder: (_) => investigationsRepository().map(
                    (value) {
                      return PopupMenuItem(
                        value: value,
                        child: Row(
                          children: [
                            if (patient.investigations.any(
                              (inv) => inv.id == value.id,
                            ))
                              const Icon(Icons.done, color: Colors.green)
                            else
                              const Icon(Icons.cancel, color: Colors.red),
                            value.name.text().pad(),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
            Wrap(
              children: patient.investigations
                  .map(
                    (eachInvestigaion) => Chip(
                      labelPadding: const EdgeInsets.all(1),
                      label: Text(eachInvestigaion.name),
                      onDeleted: () {
                        update(
                          patient..investigations.remove(eachInvestigaion),
                        );
                      },
                      backgroundColor: Colors.deepOrange,
                    ),
                  )
                  .toList(),
            ),
            Text(
              'bills',
              textScaleFactor: 1.2,
            ),
            '${patient.investigations.fold(0, (i, s) => i + s.price)}'.text(),
            TextFormField(
              initialValue: patient.diagnosis,
              onChanged: (value) => update(
                patient..diagnosis = value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
