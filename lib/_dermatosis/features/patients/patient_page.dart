import 'package:forui/forui.dart';
import 'package:patients/_dermatosis/domain/api/patients_repository.dart';
import 'package:patients/_dermatosis/domain/models/patient.dart';
import 'package:patients/_dermatosis/features/patients/patients_bloc.dart';
import 'package:patients/_dermatosis/navigator.dart';

import '../../main.dart';

final patientBloc = PatientBloc();

class PatientBloc {
  Patient? get(int id) => patientsRepository.get(id);
}

class PatientPage extends UI {
  const PatientPage(this.patientId, {super.key});
  final int patientId;
  @override
  Widget build(BuildContext context) {
    final patient = patientBloc.get(patientId)!;
    return FScaffold(
      header: FHeader(
        title: patient.name.text(),
        actions: [
          FHeaderAction.back(onPress: navigator.back),
        ],
      ),
      content: ListView(
        children: [
          FTextField(
            label: Text('name'),
            initialValue: patient.name,
            onChange: (value) => patientsBloc.put(patient..name = value),
          ).pad(),
          // complaints
          FTextField(
            label: 'complaints'.text(),
            initialValue: patient.complaints,
            onChange: (value) => patientsBloc.put(patient..complaints = value),
            minLines: 2,
            maxLines: 8,
          ).pad(),
          // management
          FTextField(
            label: 'management'.text(),
            initialValue: patient.management,
            onChange: (value) => patientsBloc.put(patient..management = value),
            minLines: 3,
            maxLines: 10,
          ).pad(),

          // lesions
          FLabel(
            axis: Axis.vertical,
            label: 'lesions'.text(),
            description: FButton.icon(
              child: FIcon(FAssets.icons.plus),
              onPress: () async {
                String patterns = '';
                final lesion = await navigator.toDialog<Lesion>(
                  FDialog(
                    title: 'add new lesion'.text(),
                    body: FTextField(
                      label: Text('patterns'),
                      initialValue: patterns,
                      onChange: (value) => patterns = value,
                      minLines: 5,
                      maxLines: 5,
                    ),
                    actions: [
                      FButton(
                        label: 'save'.text(),
                        onPress: () {
                          // navigator.back(Lesion()..patterns = patterns);
                        },
                      ),
                      FButton(
                        label: 'cancel'.text(),
                        onPress: () => navigator.back(),
                      ),
                    ],
                  ),
                );
                if (lesion != null) {
                  // patientsBloc.put(patient..lesions.add(lesion));
                }
              },
            ),
            child: FTileGroup(
              divider: FTileDivider.full,
              children: patient.lesions.map(
                (lesion) {
                  return FTile(
                    semanticLabel: lesion.patterns,
                    title: lesion.patterns.text(),
                    onPress: () {
                      String patterns = lesion.patterns;
                      navigator.toDialog(
                        FDialog(
                          title: 'add new lesion'.text(),
                          body: FTextField(
                            label: Text('patterns'),
                            initialValue: patterns,
                            onChange: (value) => patterns = value,
                            minLines: 5,
                            maxLines: 5,
                          ),
                          actions: [
                            FButton(
                              label: 'save'.text(),
                              onPress: () {
                                // lesionsRM.put(lesion..patterns = patterns);
                                // patientsBloc.put(
                                //   patient..lesions.add(lesion),
                                // );
                                // navigator.back();
                              },
                            ),
                            FButton(
                              label: 'cancel'.text(),
                              onPress: () => navigator.back(),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ).toList(),
            ),
          ).pad(),

          /// diagnosis
          FTextField(
            label: 'diagnosis'.text(),
            initialValue: patient.diagnosis,
            onChange: (value) {
              patientsBloc.put(patient..diagnosis = value);
            },
            minLines: 1,
            maxLines: 3,
          ).pad(),
          // address
          FTextField(
            label: 'address'.text(),
            // initialValue: patient.address.target?.address,
            onChange: (value) {
              // final town =
              //     RegExp(r'^(.+?)(?:[, ]|$)').firstMatch(value)?.group(1);
              // final city =
              //     RegExp(r',\s*(.+?)(?:[, ]|$)').firstMatch(value)?.group(1);
              // final province =
              //     RegExp(r',\s*(.+?)(?:[, ]|, )').firstMatch(value)?.group(1);
              // final country = RegExp(r',\s*(.+?)$').firstMatch(value)?.group(1);
              // final address = Address()
              //   ..town = town ?? ''
              //   ..city = city ?? ''
              //   ..province = province ?? ''
              //   ..country = country ?? '';
              // patientsBloc.put(
              //   patient..address.target = address,
              // );
            },
            minLines: 2,
            maxLines: 3,
          ).pad(),
          // gender
          FCard(
            title: Text('gender'),
            subtitle: 'toggle gender here'.text(),
            child: FButton.icon(
              onPress: () {
                // patientsBloc.put(patient..gender = !patient.gender);
              },
              child: Icon(
                patient.gender ? Icons.male : Icons.female,
              ),
            ).pad(),
          ).pad(),
          // date of birth
          FCard(
            child: const Text('date of birth'),
            // child: ShadDatePickerFormField(
            //   autovalidateMode: AutovalidateMode.always,
            //   initialValue: patient.dateOfBirth,
            //   onChanged: (value) {
            //     if (value != null)
            //       patientsBloc.put(patient..dateOfBirth = value);
            //   },
            //   description: Text('your age is ${patient.age.inYears}'),
            //   validator: (v) {
            //     if (v == null) {
            //       return 'A date of birth is required.';
            //     }
            //     return null;
            //   },
            //   error: (error) => error.text(),
            // ),
          ).pad(),
        ],
      ),
      footer: FButton(
        onPress: () {
          // patientsBloc.put(
          //   patient..editing = !patient.editing,
          // );
        },
        label: Text(
          (patient.editing ? 'EDITING' : 'READING'),
        ),
      ).pad(),
    );
  }
}
