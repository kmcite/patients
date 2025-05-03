import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:manager/manager.dart';
import 'package:patients/_dermatosis/domain/api/patients_repository.dart';
import 'package:patients/_dermatosis/domain/models/patient.dart';
import 'package:patients/_dermatosis/navigator.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../patients/patient_page.dart';

final searchRM = SearchBloc();

class SearchBloc {
  final searchRM = RM.injectTextEditing(text: '');

  TextEditingController get controller => searchRM.controller;
  Iterable<Patient> get queriedPatients {
    return patientsRepository.searchByName(controller.text);
  }
}

class SearchPage extends UI {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: 'Search'.text(),
        actions: [
          FHeaderAction.back(
            onPress: navigator.back,
          ),
        ],
      ),
      content: Column(
        children: [
          FTextField(
            controller: searchRM.searchRM.controller,
          ).pad(),
          Expanded(
            child: searchRM.searchRM.text.isEmpty
                ? 'No results'.text().center()
                : ListView.builder(
                    itemCount: searchRM.queriedPatients.length,
                    itemBuilder: (context, index) {
                      final qpt = searchRM.queriedPatients.elementAt(index);
                      return FTile(
                        title: qpt.name.text(),
                        subtitle: qpt.complaints.text(),
                        onPress: () => navigator.to(
                          PatientPage(qpt.id),
                        ),
                      ).pad();
                    },
                  ),
          )
        ],
      ),
    );
  }
}
