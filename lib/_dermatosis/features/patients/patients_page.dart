import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:manager/manager.dart';
import 'package:patients/_dermatosis/features/imageries/patient_tile.dart';
import 'package:patients/_dermatosis/features/patients/patients_bloc.dart';
import 'package:patients/_dermatosis/navigator.dart';

class PatientsPage extends UI {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: const Text('dermatoma'),
        actions: [
          FHeaderAction.back(onPress: navigator.back),
        ],
      ),
      content: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: patientsBloc.patients.length,
        itemBuilder: (context, index) => PatientTile(
          patient: patientsBloc.patients[index],
        ),
      ),
    );
  }
}
